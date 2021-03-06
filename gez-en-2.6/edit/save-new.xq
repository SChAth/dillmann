(:xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $app-collection := '/db/apps/dict'
let $data-collection := '/db/apps/dict/data'
 
(\: get the form data that has been "POSTed" to this XQuery :\)
let $item := request:get-data()
 
(\: get the next ID from the next-id.xml file :\)
let $next-id-file-path := concat($app-collection,'/edit/next-id.xml')
let $id := doc($next-id-file-path)/data/next-id/text() 
let $file := concat($id, '.xml')

(\: logs into the collection :\)
let $login := xmldb:login($app-collection, 'Pietro', 'Hdt7.10')

(\: create the new file with a still-empty id element :\)
let $store := xmldb:store($data-collection, $file, $item)

(\: add the correct ID to the new document we just saved :\)
let $update-id :=  update replace doc(concat($data-collection, '/', $file))/entry/id with <id>{$id}</id>

(\: update the next-id.xml file :\)
let $new-next-id :=  update replace doc($next-id-file-path)/data/next-id/text() with ($id + 1)

(\: we need to return the original ID number in our results, but $id has already been increased by 1 :\)
let $original-id := ($id - 1)

return
<html>
    <head>
       <title>Save Confirmation</title>
    </head>
    <body>
        <a href="../index.html">Term Home</a>
        <p>Term {$original-id} has been saved.</p>
        <a href="../list">List all Terms</a> 
    </body>
</html>:)