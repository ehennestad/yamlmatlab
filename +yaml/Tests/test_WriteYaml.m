function stat = test_WriteYaml()
    stat.ok = 1;
    stat.desc = '';
    try
        fprintf('Testing write ');
        stat.test_WY_Matrices = test_WY_Universal(PTH_PRIMITIVES('matrices') );
        fprintf('.');
        stat.test_WY_FloatingPoints = test_WY_Universal(PTH_PRIMITIVES('floating_points') );
        fprintf('.');
        stat.test_WY_Indentation = test_WY_Universal(PTH_PRIMITIVES('indentation') );
        fprintf('.');
        stat.test_WY_SequenceMapping = test_WY_Universal(PTH_PRIMITIVES('sequence_mapping') );
        fprintf('.');
        stat.test_WY_Simple = test_WY_Universal(PTH_PRIMITIVES('simple') );
        fprintf('.');
        stat.test_WY_Time = test_WY_Universal(PTH_PRIMITIVES('time') );
        fprintf('.');
        stat.test_WY_ComplexStructure = test_WY_Universal(PTH_IMPORT('import') );
        fprintf('.');
        stat.test_WY_usecase_01 = test_WY_Universal(PTH_PRIMITIVES('usecase_struct_01') );
        fprintf('.\n');
    
        C = struct2cell(stat);
        T = [C{3:end}];
        numOk = sum([T.ok]);
        numTotal = numel(T);
        stat.numOk = numOk;
        stat.numTotal = numTotal;
    catch
        stat.ok = 0;
        stat.desc  = 'Program crash';
    end
end

function result = PTH_PRIMITIVES(fileName)
    testDir = fileparts(mfilename('fullpath'));
    result = fullfile(testDir, 'Data', 'test_primitives', fileName);
end

function result = PTH_IMPORT(fileName)
    testDir = fileparts(mfilename('fullpath'));
    result = fullfile(testDir, 'Data', 'test_import', fileName);
end

function result = PTH_INHERITANCE(fileName)
    testDir = fileparts(mfilename('fullpath'));
    result = fullfile(testDir, 'Data', 'test_inheritance', fileName);
end

function stat = test_WY_Universal(filePathWithoutExtension)
    stat.ok = 1;
    stat.desc = '';
    try
        data = load([filePathWithoutExtension, '.mat']);
        yaml.WriteYaml('~temporary.yaml',data.testval);
        ry = yaml.ReadYaml('~temporary.yaml');
        if ~isequaln(ry, data.testval)
            stat.desc  = 'Wrong values loaded';
            stat.ok = 0;
        end
    catch
        stat.ok = 0;
        stat.desc = 'Crash';
    end
end
