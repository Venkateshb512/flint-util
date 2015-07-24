#begin
@log.trace("Started executing 'flint-util:jcloud:operation:describe_instance.rb' flintbit...")
#Flintbit Input Parameters
#Mandatory  
@connector_name= @input.get("connector_name")                      #Name of the Cloud Connector
@action = @input.get("action")                                     #Action
@id = @input.get("id")                                             #Id of server

@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                       action ::        #{@action}
                                           id ::            #{@id}")

@log.trace("Calling #{@connector_name}...")

 response = @call.connector(@connector_name)
                 .set("action",@action)
                 .set("id",@id)
                 .sync

#Cloud Connector Response Meta Parameters
response_exitcode=response.exitcode           #Exit status code
response_message=response.message             #Execution status message

#Cloud Connector Response Parameters
result = response.get("describe-instance")
              #Response Body


if response.exitcode == 0
    result.each do |instance_id|
	@log.info("Amazon EC2 Instance id :              #{instance_id.get("id")} |
							   Provider id :         #{instance_id.get("provider-id")}
							   Location :            #{instance_id.get("location")}
							   imageid :             #{instance_id.get("image-id")}
                               os :                  #{instance_id.get("os")}
                               backend-status :      #{instance_id.get("backend-status")}
                               login-port :          #{instance_id.get("login-port")}
                               hostname :            #{instance_id.get("hostname")}
                               private-address :     #{instance_id.get("private-address")}
                               hardware :            #{instance_id.get("hardware")}")
end
	@log.info("SUCCESS in executing cloud Connector where, exitcode :: #{response_exitcode} | 
    	                                                   message ::  #{response_message}")
	@log.info("HTTP Response Body :: #{result}")
	#@output.set("result",result.to_s)
    #@log.info("----response---"+response.to_s)
    @output.setraw("info",result.to_s)
else
	@log.error("ERROR in executing cloud Connector where, exitcode :: #{response_exitcode} | 
		                                                  message ::  #{response_message}")
    @output.exit(1,response_message)
    end
@log.trace("Finished executing 'flint-util:jcloud:operation:describe_instance.rb' flintbit...")
#end
