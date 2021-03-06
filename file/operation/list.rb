# begin
@log.trace("Started executing 'flint-util:file:operation:list.rb' flintbit...")
begin
    # Flintbit Input Parameters
    connector_name = @input.get('connector_name')     # Name of the File Connector
    action = "list"                                   # Action
    file_path = @input.get('file')                    # Folder Name and Location

    @log.info("Flintbit input parameters are, connector name :: #{connector_name} | action :: #{action} | file_path :: #{file_path}")

    @log.trace("Calling #{connector_name}...")
    response = @call.connector(connector_name)
                    .set('action', action)
                    .set('file', file_path)
                    .sync

    # File Connector Response Meta Parameters
    response_exitcode = response.exitcode   # Exit status code
    response_message = response.message     # Execution status messages

    # File Connector Response Parameters
    response_file = response.get('file')   # File read
    response_body = response.get('files')  # Response Body, data read from the file

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("File read :: #{response_file} | Data read from the File :: #{response_body}")
        @output.set('files', response_body)
        @output.set('file-path', response_file)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.exit(1, response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-util:file:operation:list.rb' flintbit with error...")
# end
