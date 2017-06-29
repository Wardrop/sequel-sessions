module Rack
  module Session
    class Sequel < Abstract::Persisted

      DEFAULT_OPTIONS = Abstract::Persisted::DEFAULT_OPTIONS.merge(:table_name => :sessions)

      # Options arguments can be either a Sequel::Database instance, or a hash. Options beyond those defined in
      # Rack::Session::Abstract::Persisted include:
      #   :db => The a Sequel database object.
      #   :table_name => The name of the table to store session data. Defaults to :sessions.
      def initialize(app, options={})
        options = {:db => options } if options.is_a? ::Sequel::Database
        super
        @mutex = Mutex.new
        setup_database
      end

      def find_session(env, sid)
        record = table.filter(sid: sid).first
        if record
          begin
            session = Marshal.load(record[:session].unpack('m*').first)
          rescue ArgumentError
            session = {}
          end
        else
          sid, session = generate_sid, {}
        end
        [sid, session]
      end

      def write_session(req, sid, session, options)
        with_lock(req) do
          begin
            table.insert(sid: sid, session: [Marshal.dump(session)].pack('m*'), :created_at => Time.now.utc)
          rescue ::Sequel::UniqueConstraintViolation
            table.filter(sid: sid).update(sid: sid, session: [Marshal.dump(session)].pack('m*'), :updated_at => Time.now.utc)
          end
          sid
        end
      end

      def delete_session(req, sid, options)
        with_lock(req) do
          table.filter(sid: sid).delete
          generate_sid unless options[:drop]
        end
      end

      def db
        @default_options[:db]
      end

      def table
        db[@default_options[:table_name].to_sym]
      end

    protected

      def with_lock(req)
        @mutex.lock if req.env['rack.multithread']
        yield
      ensure
        @mutex.unlock if @mutex.locked?
      end

      def setup_database
        db.create_table(@default_options[:table_name]) do
          String :sid, :unique => true, :null => false, :primary_key => true
          text :session, :null => false
          DateTime :created_at, :null => false
          DateTime :updated_at
        end unless db.table_exists? @default_options[:table_name]
      end

    end
  end
end
