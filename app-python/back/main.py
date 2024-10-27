import json, boto3, os
from botocore.exceptions import ClientError

# Init resource conection
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get("TABLE_NAME")
 
# Define function entry point to handle invokations
def handler(event, context):
   
    table = dynamodb.Table(table_name)
    
    try:
        action = event.get("action")
        # Inserts item
        if action == "put":
            table.put_item(Item=event.get("item"))
         
            return {
                'statusCode': 200,
                'body': json.dumps('Data inserted successfully!')
            }
        # Gets specified ítem
        elif action == "get_one":
            
            item = event.get("item")
            response = table.get_item(Key=item)
           
            return {
                'statusCode': 200,
                'body': json.dumps(response.get("Item", {}))
            }
        # Gets 10 items 
        elif action == "get_all":
            response = table.scan(Limit=10)
            print(type(response))
            return {
            'statusCode': 200,
            'body': json.dumps(response.get("Items", []))
        }
        # Deletes specified ítem
        elif action == "delete":  # New action to delete an item
            item = event.get("item")
            table.delete_item(Key=item)
            
            return {
                    'statusCode': 200,
                    'body': json.dumps('Data deleted successfully!')
            }

        elif action == "update":
            item = event.get("item")
            update_expression = event.get("update_expression")
            expression_values = event.get("expression_values")
            
            response = table.update_item(
                Key=item,
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_values,
                ReturnValues="UPDATED_NEW"
            )
        
        return {
            "status": "Item updated",
            "updated_attributes": response.get("Attributes", {})
        }
    
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Failed to insert data: {e.response["Error"]["Message"]}')
        }

