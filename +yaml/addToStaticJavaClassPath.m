function addToStaticJavaClassPath()

    yamlRootDir = fileparts( which('yaml.WriteYaml') );
    jarFilePath = fullfile(yamlRootDir, 'external', 'snakeyaml-1.9.jar');
    
    if ~isfile(jarFilePath)
        error('The snakeyaml Java Archive was not found.')
    end
    
    wasSuccess = addFilepathToStaticJavapath(jarFilePath); % Local function
    if ~wasSuccess
        error('Failed to add the snakeyaml Java Archive to the static javapath')
    end

    % Since matlab has to be restarted before changes to
    % the static Java class path take effect, the path is
    % added to the dynamic path here if its not already on
    % the static javapath
    if ~ismember(jarFilePath, javaclasspath('-static') )
        javaclasspath( jarFilePath ) % Temp add to dynamic path...
    end

end


function wasSuccess = addFilepathToStaticJavapath(filepath)
%addFilepathToStaticJavapath Add filepath to the static java path
%
%   WASSUCCESS = addFilepathToStaticJavapath(FILEPATH) writes the filepath
%   into the javaclasspath file located in the matlab preferences folder.
%   This makes sure the filepath is on the static java path.
%
%   If the filepath is already in the file, this functions returns.

    wasSuccess = false; 
    
    initDir = prefdir;
    staticJavaFilepath = fullfile(initDir, 'javaclasspath.txt');
    
    % Check if filepath already exists on the static javapath. Note: Need
    % to check the file, because the static classpath is only updated on on
    % matlab startup.    
    str = fileread(staticJavaFilepath);
    existsInPathDef = contains(str, filepath);
    
    if existsInPathDef
        wasSuccess = true;
        [~, name, ~] = fileparts(filepath);
        fprintf('"%s" already exists on the static javapath.\n', name)
        return
    end
    
    % If not, open file and add write the filepath into the file
    if ~exist(staticJavaFilepath, 'file')
        fid = fopen(staticJavaFilepath, 'w', 'n', 'UTF-8');
    else
        fid = fopen(staticJavaFilepath, 'a', 'n', 'UTF-8');
    end

    fprintf(fid, '\n%s', filepath);

    status = fclose(fid);
    if status == 0
        wasSuccess = true;
    end

end