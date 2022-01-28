function generateDicom(Image,Address_Original,Address_New,PathToolkit)

% Creates Dummy
fid = fopen('Dummy.raw', 'wb' );
fwrite(fid,Image', 'uint16');
fclose( fid );
% Writes
copyfile(Address_Original,Address_New);
system(['"' PathToolkit filesep 'dcmodify" -mf "PixelData=Dummy.raw" "' Address_New '"']);
delete([Address_New '.bak']);
delete('Dummy.raw')

