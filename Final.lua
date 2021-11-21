
-- OOP for player objects
Player = {name = '', score = 0}
function Player:new (name, score)
    return setmetatable({
        name = name,
        score = score},
        self)
end

-- Function to create 2 new players
local function newPlayers()
    print('Enter the name for player 1: ')
    local name1 = io.read()
    print('Enter the name for player 2: ')
    local name2 = io.read()

    -- Calls the table's method 'new' in order to create new objects
    local player1 = Player:new(name1, 0)
    local player2 = Player:new(name2, 0)
    
    -- Return multiple values
    return player1, player2
end

-- Function to create new matricies from user input
local function newMatrices()
    print('Enter the number of rows for matrix 1: ')
    local rows1 = io.read()
    print('Enter the number of columns for matrix 1: ')
    local col1 = io.read()
    print('Enter the number of rows for matrix 2: ')
    local rows2 = io.read()
    print('Enter the number of columns for matrix 2: ')
    local col2 = io.read()

    -- Initializing 2d tables
    local matrix1, matrix2 = {}, {}

    print('ENTER THE ELEMENTS FOR MATRIX 1')
    for i = 1, rows1 do
        matrix1[i] = {}
        for j = 1, col1 do
            print(string.format('Enter the element for [%s,%s]: ', i, j))
            matrix1[i][j] = io.read()
        end
    end

    print('ENTER THE ELEMENTS FOR MATRIX 2')
    for i = 1, rows2 do
        matrix2[i] = {}
        for j = 1, col2 do
            print(string.format('Enter the element for [%s,%s]: ', i, j))
            matrix2[i][j] = io.read()
        end
    end
    -- Return mutltiple tables
    return matrix1, matrix2
end

-- Function to perform validation checks on the input matricies
-- *Accepts 2 arguments, then a variable amount afterwards
local function validCheck(rows, col, ...)
    -- If there were no additional arguments, then it is a multiplication
    if select('#', ...) == 0 then
        if (rows ~= col) then
            print('These matrices are incompatible! \n' ..
            'Try new matrices or choose another operation.')
            return false
        end
        return true
    -- Otherwise, there were more arguments given, so it is add/subtract
    else
        local rows2, col2 = ...
        if(rows ~= rows2) or (col ~= col2) then
            print('These matrices are incompatible! \n' ..
            'Try new matrices or choose another operation.')
            return false
        end
    end
    return true
end

-- Function to simulate slowly printing
local function printMatrix(matrix, slowPrint)
    for i = 1, #matrix do
        -- If it is the first time calling the coroutine
        if i == 1 then
            coroutine.resume(slowPrint, matrix)
        -- Pause for 2 seconds, then resume the coroutine
        else
            io.write('Loading...')
            Sleep(2)
            coroutine.resume(slowPrint)
        end
    end
end

-- Coroutine function that serves to print the result matrix row by row
local function slowPrinting (matrix)
   local printTable = ''
   local row = 1
   while true do
       if row ~= 1 then
            printTable = printTable .. '\n'
       end
       for i = 1, #matrix[row] do
           printTable = printTable .. ' ' .. matrix[row][i]
       end
       row = row + 1
       print("\n"..printTable)
       if row > #matrix then
            printTable = ''
            row = 1
        end
        -- Return control to printMatrix to simulate a pause,
        -- then print again with an additional row added
       coroutine.yield()
   end
end

-- Function to create pauses in program execution
function Sleep(s)
    local ntime = os.time() + s
    repeat until os.time() > ntime
end

-- START OF PROGRAM EXECUTION

-- Create 2 player objects, newPlayers() returns multiple objects
local player1, player2 = newPlayers()

-- Create 2 tables to hold 2d matricies
local matrix1, matrix2 = newMatrices()

-- Metatable that defines how operations will be performed on tables
local metaTable = {
    -- Defining multiplication *
    __mul = function (matrix1, matrix2)
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix2[1] do
                result[i][j] = 0
                for k = 1, #matrix1[1] do
                    result[i][j] = result[i][j] + matrix1[i][k] * matrix2[k][j]
                end
            end
        end
        return result
    end,
    -- Defining addtion +
    __add = function (matrix1, matrix2)
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix1[1] do
                result[i][j] = matrix1[i][j] + matrix2[i][j]
            end
        end
        return result
    end,
    -- Defining subtraction -
    __sub = function (matrix1, matrix2)
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix1[1] do
                result[i][j] = matrix1[i][j] - matrix2[i][j]
            end
        end
        return result
    end
}
-- Set the metatable to the 2 input tables being used for calculation
setmetatable(matrix1, metaTable)
setmetatable(matrix2, metaTable)


local done = false
-- Repeat: the menu
-- Until: user wants to end
repeat
    print('Choose an operation: \n' .. 
    'Multiply (M) \n' ..
    'Add (A) \n' ..
    'Subtract (S) \n' ..
    'New Matricies (NM) \n' ..
    'New Players (NP) \n' ..
    'End Game (end)')
    local operation = io.read()
    -- Multiplication
    if operation == 'M' then
        -- validCheck with 2 arugments
        if validCheck(#matrix2, #matrix1[1]) then
            -- Create a new coroutine for printing the result
            local slowPrint = coroutine.create(slowPrinting)
            local matrix3 = matrix1 * matrix2
            printMatrix(matrix3, slowPrint)
        end
    elseif operation == 'A' then
        -- validCheck with 4 arguments
        if validCheck(#matrix1, #matrix1[1], #matrix2, #matrix2[1]) then
            local slowPrint = coroutine.create(slowPrinting)
            local matrix3 = matrix1 + matrix2
            printMatrix(matrix3, slowPrint)
        end
    elseif operation == 'S' then
        -- validCheck with 4 arguments
        if validCheck(#matrix1, #matrix1[1], #matrix2, #matrix2[1]) then
            local slowPrint = coroutine.create(slowPrinting)
            local matrix3 = matrix1 - matrix2
            printMatrix(matrix3, slowPrint)
        end
    elseif operation == 'NM' then
        -- Create 2 new matricies and set the metatable to them
        matrix1, matrix2 = newMatrices()
        setmetatable(matrix1, metaTable)
        setmetatable(matrix2, metaTable)
    elseif operation == 'NP' then
        player1, player2 = newPlayers()
    elseif operation == 'end' then
        done = true
        print('Thank you for playing!')
    end
until done
