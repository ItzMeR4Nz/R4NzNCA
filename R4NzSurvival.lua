local v0=string.char;
local v1=string.byte;
local v2=string.sub;
local v3=bit32 or bit;
local v4=v3.bxor;
local v5=table.concat;
local v6=table.insert;

local function decrypt(str, key)
    local result={};
    for i=1, #str do
        v6(result, v0(v4(v1(v2(str,i,i+1)), v1(v2(key,1+(i% #key),1+(i% #key)+1)))%256));
    end
    return v5(result);
end

local v8={
    [decrypt("\250\230\226\26\202\146\233\53","\126\177\163\187\69\134\219\167")] = decrypt("\43\217\62\213\239\121\130\101\214\255\49\196\58\209\245\59\131\38\204\234\38","\156\67\173\74\165"),
    
    [decrypt("\2\150\101\63\152\25\109\17\142\122","\38\84\215\41\118\220\70")] = {
        decrypt("\126\51\26\39\205\29\55\0\49\218\29\71\112\65\170\29\51\4\53\214","\158\48\118\66\114"),
        decrypt("\159\1\35\2\62\142\222\146\105\66\102\33\240","\155\203\68\112\86\19\197"),
        decrypt("\98\248\27\211\13\83\192\193\11\251\4\217\101","\152\38\189\86\156\32\24\133")
    },
    
    [decrypt("\223\118\139\106\222\118\132\109\195\120\137\121\207\98\132\101\217\100\148","\38\156\55\199")] = function()
        print(decrypt("\147\83\89\16\38\71\199\3\131\120\101\104\5\117\246\74\172\124\104\45\23\52\183\3\164\114\125\44\26\122\253\3\184\124\101\36\28\117\254\13\230\51","\35\200\29\28\72\115\20\154"))
    end
};

local v9=game:GetService(decrypt("\41\179\208\198\136\62\39","\84\121\223\177\191\237\76"));
local v10=game:GetService(decrypt("\143\65\204\165\52\99\53\211\173\95\202\165","\161\219\54\169\192\90\48\80"));
local v11=game:GetService(decrypt("\124\81\5\55\96\76\16\48\93\113\5\55\95\75\3\32","\69\41\34\96"));

local v12=v9.LocalPlayer;

local v13 = {
    [decrypt("\158\228\232\60\45\2\152","\75\220\163\183\106\98")] = Color3.fromRGB(5, 255, 12),
    [decrypt("\32\157\180\7\248\44\159\167","\185\98\218\235\87")] = Color3.fromRGB(12, 14, 26),
    [decrypt("\233\27\24\197\255\152\239","\202\171\92\71\134\190")] = Color3.fromRGB(16,19,34),
    [decrypt("\11\230\19\161\7\241\25\188","\232\73\161\76")] = Color3.fromRGB(8, 10, 20),
    [decrypt("\153\246\112\121\59\137\230\102\116\51","\126\219\185\34\61")] = Color3.fromRGB(30, 35, 55),
    [decrypt("\34\235\113\92\65\80\193\194\41\224","\135\108\174\62\18\30\23\147")] = Color3.fromRGB(0, 255, 140),
    [decrypt("\152\204\5\229\39\130\26\234\147","\167\214\137\74\171\120\206\83")] = Color3.fromRGB(120, 255, 68),
    [decrypt("\165\213\29\115\199\149\174\212","\199\235\144\82\61\152")] = Color3.fromRGB(255, 50, 80),
    [decrypt("\41\51\150\5\56\55\148\9\34\36","\75\103\118\217")] = Color3.fromRGB(255, 180, 0),
    [decrypt("\233\113\95\58\134\60\235\97\85","\126\167\52\16\116\217")] = Color3.fromRGB(0, 170, 255),
    [decrypt("\230\11\15\174\139\46\212\225\26\5","\156\168\78\64\212\121")] = Color3.fromRGB(200, 220, 210),
    [decrypt("\51\203\157\250\56\204\151\231\32\198\145","\174\103\142\197")] = Color3.fromRGB(210, 230, 220),
    [decrypt("\98\13\103\12\26\115\209\114","\152\54\72\63\88\69\62")] = Color3.fromRGB(120, 140, 130),
    [decrypt("\224\225\214\104\235\224\199\113","\60\180\164\142")] = Color3.fromRGB(55, 70, 65),
    [decrypt("\108\123\61\29\24\192\61\118\113","\114\56\62\101\73\71\141")] = Color3.fromRGB(0, 200, 110),
    [decrypt("\139\220\248\231\157\218\232","\164\216\137\187")] = Color3.fromRGB(255, 255, 140),
    [decrypt("\247\212\3\157\148","\107\178\134\81\210\198\158")] = Color3.fromRGB(255, 50, 80)
};

local function tweenObject(obj, props, duration, easingStyle, easingDirection)
    local tween = v10:Create(obj, TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quint, easingDirection or Enum.EasingDirection.Out), props);
    tween:Play();
    return tween;
end

local function createInstance(className, properties)
    local inst = Instance.new(className);
    for prop, value in pairs(properties or {} ) do
        pcall(function() inst[prop] = value; end);
    end
    if (properties and properties.Parent) then inst.Parent = properties.Parent; end
    return inst;
end

local function createUIPadding(padding, size)
    return createInstance(decrypt("\246\38\161\248\216\205\10\144","\170\163\111\226\151"), {[decrypt("\50\63\160\54\75\37\27\16\52\187\45\93","\73\113\80\210\88\46\87")]=UDim.new(0, size or 6), [decrypt("\177\45\223\23\233\149","\135\225\76\173\114")]=padding});
end

local function createStroke(parent, color, thickness, transparency)
    return createInstance(decrypt("\47\196\139\164\190\178\172\31","\199\122\141\216\208\204\221"), {[decrypt("\142\210\28\255\106","\150\205\189\112\144\24")]=color or v13.BORDER_DIM, [decrypt("\17\140\182\79\15\134\20\3\54","\112\69\228\223\44\100\232\113")]=thickness or 1, [decrypt("\224\13\6\221\165\108\135\198\26\9\208\175","\230\180\127\103\179\214\28")]=transparency or 0, Parent=parent});
end

local function typewriterEffect(label, text, delay, color)
    label.Text="";
    if color then label.TextColor3=color; end
    for i=1, #text do
        if ( not label or not label.Parent) then return; end
        label.Text=text:sub(1,i);
        task.wait(delay or 0.05);
    end
end

local function randomRange(min, max)
    if (min>=max) then return min; end
    return math.random(min, max);
end

local function randomString()
    local chars = decrypt("\252\248\67\23\226\190\153\251\241\72\101\148\200\235\137\143","\175\204\201\113\36\214\139");
    local result="";
    for i=1,8 do
        local rand = math.random(1, #chars);
        result = result .. chars:sub(rand,rand);
    end
    return result;
end

-- Cleanup existing GUI
pcall(function()
    if game:GetService(decrypt("\100\195\39\217\35\82\197","\100\39\172\85\188")):FindFirstChild(decrypt("\131\125\161\149\32\134\125\160\179\42\190\108\188\141","\83\205\24\217\224")) then
        game:GetService(decrypt("\197\202\223\56\193\208\196","\93\134\165\173")):FindFirstChild(decrypt("\144\247\217\215\41\229\183\103\141\235\210\214\63\195","\30\222\146\161\162\90\174\210")):Destroy();
    end
end);

pcall(function()
    if (v12:FindFirstChild(decrypt("\213\66\113\19\224\92\87\31\236","\106\133\46\16")) and v12.PlayerGui:FindFirstChild(decrypt("\118\37\107\233\73\107\93\57\64\229\73\84\93\45","\32\56\64\19\156\58"))) then
        v12.PlayerGui.NexusKeySystem:Destroy();
    end
end);

-- MAIN GUI (tanpa key system)
local screenGui = createInstance(decrypt("\105\203\247\83\95\252\167\79\193","\224\58\168\133\54\58\146"), {
    [decrypt("\119\87\70\248","\107\57\54\43\157\21\230\231")]=decrypt("\245\142\9\224\170\247\202\194\184\8\230\173\217\194","\175\187\235\113\149\217\188"),
    [decrypt("\24\166\146\92\239\120\97\19\189\133\73\241","\24\92\207\225\44\131\25")]=2,
    [decrypt("\98\212\182\67\9\120\108\198\177\101\21\110\78\199","\29\43\179\216\44\123")]=true,
    [decrypt("\143\220\51\73\169\246\46\127\173\216\55\66","\44\221\185\64")]=false,
    [decrypt("\59\206\70\91\118\25\197\77\87\114\23\238\71\77","\19\97\135\40\63")]=Enum.ZIndexBehavior.Sibling
});

local success, result = pcall(function() screenGui.Parent = game:GetService(decrypt("\141\83\33\62\8\36\167","\81\206\60\83\91\79")); end);
if not success then
    screenGui.Parent = v12:WaitForChild(decrypt("\126\167\209\107\42\209\106\177\71","\196\46\203\176\18\79\163\45"));
end

-- Background utama
local mainBg = createInstance(decrypt("\158\48\127\19\33","\143\216\66\30\126\68\155"), {
    [decrypt("\132\201\0\206","\129\202\168\109\171\165\195\183")]=decrypt("\0\89\52\211\218\6\233\50","\134\66\56\87\184\190\116"),
    [decrypt("\15\56\19\190","\85\92\81\105\219\121\139\65")]=UDim2.new(1,0,1,0),
    [decrypt("\205\188\67\76\104\214\242\189","\191\157\211\48\37\28")]=UDim2.new(0,0,0,0),
    [decrypt("\253\30\247\23\61\205\16\225\18\62\252\16\248\19\40\140","\90\191\127\148\124")]=v13.BG_VOID,
    [decrypt("\90\134\45\28\127\149\33\2\118\131\26\5\121\137\61\7\121\149\43\25\123\158","\119\24\231\78")]=0.2,
    [decrypt("\160\34\183\78\217\82\34\139\55\160\122\213\88\20\142","\113\226\77\197\42\188\32")]=0,
    [decrypt("\0\63\250\177\63\14","\213\90\118\148")]=1,
    Parent=screenGui
});

-- Efek kilau
local glowEffect = createInstance(decrypt("\54\68\130\134\131","\144\112\54\227\235\230\78\205"), {
    [decrypt("\157\41\2\249","\59\211\72\111\156\176")]=decrypt("\125\132\226\35\108\130\226\32","\77\46\231\131"),
    [decrypt("\137\93\172\69","\32\218\52\214")]=UDim2.new(1,0,0,60),
    [decrypt("\126\24\34\161\229\185\74\84","\58\46\119\81\200\145\208\37")]=UDim2.new(0,0,-0.1,0),
    [decrypt("\9\141\51\167\174\175\57\62\130\52\143\166\177\57\57\223","\86\75\236\80\204\201\221")]=v13.NEON_GREEN,
    [decrypt("\80\64\116\142\249\153\125\84\121\129\202\153\115\79\100\149\255\153\119\79\116\156","\235\18\33\23\229\158")]=0.95,
    [decrypt("\114\181\211\191\85\168\242\178\74\191\241\178\72\191\205","\219\48\218\161")]=0,
    [decrypt("\222\88\114\77\222\87","\128\132\17\28\41\187\47")]=2,
    Parent=mainBg
});

-- Panel utama
local mainPanel = createInstance(decrypt("\131\184\34\19\22","\49\197\202\67\126\115\100\167"), {
    [decrypt("\25\90\210\44","\62\87\59\191\73\224\54")]=decrypt("\208\11\244\205\232\21","\169\135\98\154"),
    [decrypt("\248\126\62\81","\168\171\23\68\52\157\83")]=UDim2.new(0,400,0,480),
    [decrypt("\196\126\230\164\49\36\136\250","\231\148\17\149\205\69\77")]=UDim2.new(0.5,-200,0.5,-240),
    [decrypt("\162\166\196\240\80\237\143\178\201\255\116\240\140\168\213\168","\159\224\199\167\155\55")]=v13.BG_PANEL,
    [decrypt("\213\242\63\217\240\225\51\199\249\247\8\192\246\253\47\194\246\225\57\220\244\234","\178\151\147\92")]=0,
    [decrypt("\174\242\94\54\23\94\73\133\231\73\2\27\84\127\128","\26\236\157\44\82\114\44")]=0,
    [decrypt("\16\7\219\95\47\54","\59\74\78\181")]=10,
    Parent=screenGui
});

createUIPadding(mainPanel, 6);

-- Stroke panel
createStroke(mainPanel, v13.NEON_GREEN, 1, 0.5);

-- Title bar
local titleBar = createInstance(decrypt("\145\247\120\248\236","\171\215\133\25\149\137"), {
    [decrypt("\207\201\63\255","\34\129\168\82\154\143\80\156")]=decrypt("\177\187\39\7\77\108\136\151","\233\229\210\83\107\40\46"),
    [decrypt("\242\75\40\211","\101\161\34\82\182")]=UDim2.new(1,0,0,40),
    [decrypt("\216\2\74\247\207\235\141\32","\78\136\109\57\158\187\130\226")]=UDim2.new(0,0,0,0),
    [decrypt("\28\62\250\250\57\45\246\228\48\59\218\254\50\48\235\162","\145\94\95\153")]=Color3.fromRGB(8,10,18),
    [decrypt("\223\204\23\222\73\165\242\216\26\209\122\165\252\195\7\197\79\165\248\195\23\204","\215\157\173\116\181\46")]=0,
    [decrypt("\23\187\153\246\223\39\135\130\232\223\5\189\147\247\214","\186\85\212\235\146")]=0,
    [decrypt("\248\168\24\250\60\246","\56\162\225\118\158\89\142")]=1,
    Parent=mainPanel
});

createUIPadding(titleBar, 6);

-- Title text
local titleText = createInstance(decrypt("\23\144\125\177\52","\220\81\226\28"), {
    [decrypt("\61\212\143\254","\167\115\181\226\155\138")]=decrypt("\214\43\243\80\126\83\199\240\4\238\68","\166\130\66\135\60\27\17"),
    [decrypt("\119\67\212\112","\80\36\42\174\21")]=UDim2.new(1,0,0,30),
    [decrypt("\126\31\36\115\90\25\56\116","\26\46\112\87")]=UDim2.new(0,0,1,-10),
    [decrypt("\155\34\168\127\184\173\74\161\183\39\136\123\179\176\87\231","\212\217\67\203\20\223\223\37")]=Color3.fromRGB(8,10,20),
    [decrypt("\152\140\171\217\189\159\167\199\180\137\156\192\187\131\187\194\187\159\173\220\185\148","\178\218\237\200")]=0,
    [decrypt("\148\186\244\212\179\167\213\217\172\176\214\217\174\176\234","\176\214\213\134")]=0,
    [decrypt("\206\132\184\208\173\78","\57\148\205\214\180\200\54")]=20,
    Parent=titleBar
});

-- Title label
local titleLabel = createInstance(decrypt("\226\217\18\201\88","\200\164\171\115\164\61\150"), {
    [decrypt("\144\245\14\64","\227\222\148\99\37")]=decrypt("\17\93\70\226\246\62\126\91\248\252","\153\83\50\50\150"),
    [decrypt("\110\127\105\25","\45\61\22\19\124\19\203")]=UDim2.new(1,0,0,1),
    [decrypt("\241\29\30\252\22\121\182\207","\217\161\114\109\149\98\16")]=UDim2.new(0,0,1,-1),
    [decrypt("\48\33\59\119\187\102\29\53\54\120\159\123\30\47\42\47","\20\114\64\88\28\220")]=v13.NEON_GREEN,
    [decrypt("\19\0\209\191\255\194\178\36\15\214\128\234\209\179\34\17\211\166\253\222\190\40","\221\81\97\178\212\152\176")]=0.5,
    [decrypt("\239\232\15\255\31\223\212\20\225\31\253\238\5\254\22","\122\173\135\125\155")]=0,
    [decrypt("\190\232\14\189\58\41","\168\228\161\96\217\95\81")]=21,
    Parent=titleBar
});

titleLabel.Text = "⚡ NEXUS // BYPASSED";
titleLabel.TextColor3 = v13.NEON_GREEN;
titleLabel.Font = Enum.Font.Code;
titleLabel.TextSize = 14;

-- Close button
local closeButton = createInstance(decrypt("\100\164\237\55\102\59\68\181\250\45","\78\48\193\149\67\36"), {
    [decrypt("\30\31\141\29","\33\80\126\224\120")]=decrypt("\207\164\12\215\89\206\188\13","\60\140\200\99\164"),
    [decrypt("\180\253\30\35","\194\231\148\100\70")]=UDim2.new(0,30,0,30),
    [decrypt("\118\67\210\170\226\193\73\66","\168\38\44\161\195\150")]=UDim2.new(1,-38,0.5,-15),
    [decrypt("\162\253\129\125\55\250\185\3\142\248\161\121\60\231\164\69","\118\224\156\226\22\80\136\214")]=v13.NEON_RED,
    [decrypt("\96\239\90\139\69\252\86\149\76\234\109\146\67\224\74\144\67\252\92\142\65\247","\224\34\142\57")]=0.8,
    [decrypt("\252\168\215\217\118\227\110\7\196\162\245\212\107\244\81","\110\190\199\165\189\19\145\61")]=0,
    Text="×",
    TextColor3=v13.NEON_RED,
    TextSize=20,
    Font=Enum.Font.Code,
    BackgroundTransparency=false,
    ZIndex=22,
    Parent=titleBar
});

createUIPadding(closeButton, 4);

closeButton.MouseEnter:Connect(function()
    tweenObject(closeButton, {BackgroundTransparency=0.3, TextColor3=Color3.fromRGB(255,100,100)}, 0.15);
end);

closeButton.MouseLeave:Connect(function()
    tweenObject(closeButton, {BackgroundTransparency=0.8, TextColor3=v13.NEON_RED}, 0.15);
end);

closeButton.MouseButton1Click:Connect(function()
    tweenObject(mainPanel, {Size=UDim2.new(0,400,0,40)}, 0.3, Enum.EasingStyle.Quint);
    tweenObject(mainBg, {BackgroundTransparency=1}, 0.3);
    task.wait(0.35);
    screenGui:Destroy();
end);

-- Content area
local contentArea = createInstance(decrypt("\7\83\81\9\242","\67\65\33\48\100\151\60"), {
    [decrypt("\241\230\163\221","\147\191\135\206\184")]=decrypt("\167\39\168\213\221\93\166","\210\228\72\198\161\184\51"),
    [decrypt("\5\64\233\21","\174\86\41\147\112\19")]=UDim2.new(1,0,1,-40),
    [decrypt("\107\15\158\2\49\6\30\165","\203\59\96\237\107\69\111\113")]=UDim2.new(0,0,0,40),
    [decrypt("\6\23\175\234\54\226\216\49\24\168\194\62\252\216\54\69","\183\68\118\204\129\81\144")]=v13.BG_PANEL,
    [decrypt("\44\172\115\239\12\144\1\184\126\224\63\144\15\163\99\244\10\144\11\163\115\253","\226\110\205\16\132\107")]=0,
    [decrypt("\201\204\242\221\68\249\240\233\195\68\219\202\248\220\77","\33\139\163\128\185")]=0,
    ClipsDescendants=true,
    ZIndex=1,
    Parent=mainPanel
});

-- Left panel
local leftPanel = createInstance(decrypt("\217\99\85\187\51","\156\159\17\52\214\86\190"), {
    [decrypt("\128\238\176\185","\220\206\143\221")]=decrypt("\182\44","\178\230\29\77\119\184\172"),
    [decrypt("\198\183\16\30","\152\149\222\106\123\23")]=UDim2.new(0,-40,1,-40),
    [decrypt("\237\41\229\74\161\212\41\248","\213\189\70\150\35")]=UDim2.new(0,20,0,20),
    BackgroundTransparency=1,
    ZIndex=12,
    Parent=contentArea
});

-- Input area
local inputArea = createInstance(decrypt("\31\97\120\76\203","\174\89\19\25\33"), {
    [decrypt("\1\19\95\75","\107\79\114\50\46\151\231")]=decrypt("\13\163\167\36\166\54\176","\160\89\198\213\73\234\89\215"),
    [decrypt("\123\120\174\251","\165\40\17\212\158")]=UDim2.new(0,100,0,100),
    [decrypt("\213\214\27\58\50\236\214\6","\70\133\185\104\83")]=UDim2.new(0,0,0,0),
    [decrypt("\38\68\71\33\206\22\74\81\36\205\39\74\72\37\219\87","\169\100\37\36\74")]=v13.BG_INPUT,
    [decrypt("\34\134\161\91\7\149\173\69\14\131\150\66\1\137\177\64\1\149\167\94\3\158","\48\96\231\194")]=0,
    [decrypt("\234\85\28\41\28\202\156\138\210\95\62\36\1\221\163","\227\168\58\110\77\121\184\207")]=0,
    ZIndex=13,
    Parent=leftPanel
});

createUIPadding(inputArea, 4);
createStroke(inputArea, v13.BORDER_DIM, 1, 0.2);

-- Input field
local inputField = createInstance(decrypt("\164\195\160\128\188","\228\226\177\193\237\217"), {
    [decrypt("\26\177\46\227","\134\84\208\67")]=decrypt("\58\162\136\89\1","\60\115\204\230"),
    [decrypt("\212\51\241\117","\16\135\90\139")]=UDim2.new(1,-10,1,-10),
    [decrypt("\100\123\21\58\90\93\119\90","\24\52\20\102\83\46\52")]=UDim2.new(0,10,0,10),
    BackgroundTransparency=1,
    ZIndex=14,
    Parent=inputArea
});

-- Input field list layout
createInstance(decrypt("\243\17\149\63\170\22\234\57\160\57\172\22","\98\166\88\217\86\217"), {
    [decrypt("\197\249\107\21\169\206\242\243\107","\188\150\150\25\97\230")]=Enum.SortOrder.LayoutOrder,
    [decrypt("\234\136\91\6\5\227\221","\141\186\233\63\98\108")]=UDim.new(0,3),
    Parent=inputField
});

-- Function to create input line
local function createInputLine(text, color, index)
    local line = createInstance(decrypt("\68\202\145\157\147\23\114\202\133","\118\16\175\233\233\223"), {
        [decrypt("\165\133\56\190","\29\235\228\85\219\142\235")]=decrypt("\17\219\189","\50\93\180\218\189\23\46\71") .. (index or 0),
        [decrypt("\237\173\65\73","\40\190\196\59\44\36\188")]=UDim2.new(0,0,0,14),
        BackgroundTransparency=1,
        Text=text or "",
        TextSize=11,
        Font=Enum.Font.Code,
        TextColor3=color or v13.TEXT_MONO,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=index or 0,
        Parent=inputField
    });
    return line;
end

-- Input box
local inputBox = createInstance(decrypt("\130\242\76\190\225","\96\196\128\45\211\132"), {
    [decrypt("\27\140\118\90","\184\85\237\27\63\178\207\212")]=decrypt("\59\77\8\75\29\74\59\80\31","\63\104\57\105"),
    [decrypt("\56\142\190\65","\36\107\231\196")]=UDim2.new(0,160,0,55),
    [decrypt("\109\186\177\142\73\188\173\137","\231\61\213\194")]=UDim2.new(0,0,0,103),
    BackgroundTransparency=1,
    ZIndex=1,
    Parent=leftPanel
});

-- Text input area
local textInputArea = createInstance(decrypt("\203\236\12\254\253","\183\141\158\109\147\152"), {
    [decrypt("\2\8\235\9","\108\76\105\134")]=decrypt("\216\209\176\245\219\248\245\176\239\203\231","\174\139\165\209\129"),
    [decrypt("\144\186\248\196","\24\195\211\130\161\166\99\16")]=UDim2.new(0.48,0,1,0),
    [decrypt("\118\12\250\37\71\31\73\13","\118\38\99\137\76\51")]=UDim2.new(0,0,0,0),
    [decrypt("\223\39\6\25\14\50\242\51\11\22\42\47\241\41\23\65","\64\157\70\101\114\105")]=v13.BG_INPUT,
    [decrypt("\98\169\164\232\23\82\167\178\237\20\116\186\166\237\3\80\169\181\230\30\67\177","\112\32\200\199\131")]=0,
    [decrypt("\14\95\78\188\198\185\17\37\74\89\136\202\179\39\32","\66\76\48\60\216\163\203")]=0,
    ZIndex=14,
    Parent=inputBox
});

createUIPadding(textInputArea, 4);
createStroke(textInputArea, v13.BORDER_DIM, 1, 0.5);

-- Status label
local statusLabel = createInstance(decrypt("\206\73\250\232\91\251\78\231\240","\23\154\44\130\156"), {
    [decrypt("\63\167\160\171","\115\113\198\205\206\86")]=decrypt("\168\86\252\95\136","\58\228\55\158"),
    [decrypt("\135\128\202\43","\85\212\233\176\78\92\205")]=UDim2.new(1,-15,0,-10),
    [decrypt("\122\87\155\235\94\81\135\236","\130\42\56\232")]=UDim2.new(0,10,0,5),
    BackgroundTransparency=1,
    Text="STATUS\n─────────\nBYPASSED",
    TextSize=10,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_GREEN,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=15,
    Parent=textInputArea
});

-- Session info area
local sessionInfoArea = createInstance(decrypt("\195\175\86\61\202","\84\133\221\55\80\175"), {
    [decrypt("\147\230\41\163","\60\221\135\68\198\167")]=decrypt("\221\184\235\144\75\214\224\141\249\141\71\213","\185\142\221\152\227\34"),
    [decrypt("\107\204\77\255","\151\56\165\55\154\35\83")]=UDim2.new(0.48,0,1,0),
    [decrypt("\144\76\22\231\180\74\10\224","\142\192\35\101")]=UDim2.new(0.52,0,0,0),
    [decrypt("\244\116\42\168\224\158\163\3\216\113\10\172\235\131\190\69","\118\182\21\73\195\135\236\204")]=v13.BG_INPUT,
    [decrypt("\42\61\25\75\3\31\242\29\50\30\116\22\12\243\27\44\27\82\1\3\254\17","\157\104\92\122\32\100\109")]=0,
    [decrypt("\129\169\221\206\56\53\190\162\185\163\255\195\37\34\129","\203\195\198\175\170\93\71\237")]=0,
    ZIndex=14,
    Parent=inputBox
});

createUIPadding(sessionInfoArea, 4);
createStroke(sessionInfoArea, v13.BORDER_DIM, 1, 0.5);

-- Session label
local sessionLabel = createInstance(decrypt("\220\40\177\91\94\189\195\189\228","\216\136\77\201\47\18\220\161"), {
    [decrypt("\3\237\38\223","\226\77\140\75\186\104\188")]=decrypt("\149\207\210\58\67","\47\217\174\176\95"),
    [decrypt("\139\212\108\7","\70\216\189\22\98\210\52\24")]=UDim2.new(1,-14,1,-20),
    [decrypt("\234\208\176\142\199\211\208\173","\179\186\191\195\231")]=UDim2.new(0,7,0,5),
    BackgroundTransparency=1,
    Text="SESSION\n─────────\n" .. randomString(),
    TextSize=11,
    Font=Enum.Font.Code,
    TextColor3=v13.TEXT_DIM,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Top,
    ZIndex=15,
    Parent=sessionInfoArea
});

-- Input hint
local inputHint = createInstance(decrypt("\78\185\42\96\170\52\121\142\118","\235\26\220\82\20\230\85\27"), {
    [decrypt("\166\160\228\199","\20\232\193\137\162")]=decrypt("\6\214\211\175\227\137\5","\17\66\191\165\198\135\236\119"),
    [decrypt("\60\166\180\22","\177\111\207\206\115\159\136\140")]=UDim2.new(1,0,0,16),
    [decrypt("\53\134\3\29\192\70\80\11","\63\101\233\112\116\180\47")]=UDim2.new(0,20,0,250),
    BackgroundTransparency=1,
    Text="── BYPASSED ──",
    TextSize=10,
    Font=Enum.Font.Code,
    TextColor3=v13.TEXT_DIM,
    ZIndex=13,
    Parent=leftPanel
});

-- Right panel (menu buttons)
local rightPanel = createInstance(decrypt("\56\162\7\5\29","\136\126\208\102\104\120"), {
    [decrypt("\86\139\195\70","\49\24\234\174\35\207\50\93")]=decrypt("\37\252\237\157\101\59\224\252\152","\17\108\146\157\232"),
    [decrypt("\120\202\14\232","\200\43\163\116\141\79")]=UDim2.new(0,0,0,42),
    [decrypt("\143\57\46\138\164\253\236\177","\131\223\86\93\227\208\148")]=UDim2.new(0,0,0,220),
    [decrypt("\193\68\181\189\26\167\236\80\184\178\62\186\239\74\164\229","\213\131\37\214\214\125")]=v13.BG_INPUT,
    [decrypt("\4\42\38\180\230\52\36\48\177\229\18\57\36\177\242\54\42\55\186\239\37\50","\129\70\75\69\223")]=0,
    [decrypt("\100\196\225\237\121\253\117\194\233\236\76\230\94\206\255","\143\38\171\147\137\28")]=0,
    ZIndex=13,
    Parent=leftPanel
});

createUIPadding(rightPanel, 4);
local rightPanelStroke = createStroke(rightPanel, v13.BORDER_DIM, 1, 0.2);

-- Execute button
local executeButton = createInstance(decrypt("\126\178\4\193\109\141\161\79\187","\195\42\215\124\181\33\236"), {
    [decrypt("\35\88\58\59","\152\109\57\87\94\69")]=decrypt("\201\197\15\165\183\202","\200\153\183\106\195\222\178\52"),
    [decrypt("\1\234\146\56","\58\82\131\232\93\41")]=UDim2.new(0,40,1,0),
    [decrypt("\179\88\195\28\73\54\140\89","\95\227\55\176\117\61")]=UDim2.new(0,10,0,0),
    BackgroundTransparency=1,
    Text="EXECUTE",
    TextSize=15,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_GREEN,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=14,
    Parent=rightPanel
});

-- Script input
local scriptInput = createInstance(decrypt("\100\252\30\171\125\112\225","\26\48\153\102\223\63\31\153"), {
    [decrypt("\44\65\224\246","\147\98\32\141")]=decrypt("\51\70\250\227\8\70\94\12","\43\120\35\131\170\102\54"),
    [decrypt("\103\15\157\179","\228\52\102\231\214\197\208")]=UDim2.new(1,-48,1,0),
    [decrypt("\46\239\102\195\254\130\22\216","\182\126\128\21\170\138\235\121")]=UDim2.new(0,40,0,0),
    BackgroundTransparency=1,
    Text="",
    PlaceholderText=decrypt("\129\148\212\216\79\214\127\146\252\213\223\79\214\10\146\137\213\223\58\214\127\146\137","\39\202\209\141\135\23\142"),
    PlaceholderColor3=v13.TEXT_DIM,
    TextColor3=v13.NEON_GREEN,
    TextSize=14,
    Font=Enum.Font.Code,
    TextXAlignment=Enum.TextXAlignment.Left,
    ClearTextOnFocus=false,
    ZIndex=14,
    Parent=rightPanel
});

scriptInput.Focused:Connect(function()
    tweenObject(rightPanelStroke, {BackgroundColor3=v13.NEON_GREEN, Transparency=0}, 0.2);
end);

scriptInput.FocusLost:Connect(function()
    tweenObject(rightPanelStroke, {BackgroundColor3=v13.BORDER_DIM, Transparency=0.2}, 0.2);
end);

-- Info label
local infoLabel = createInstance(decrypt("\247\140\220\149\173\212\193\140\200","\181\163\233\164\225\225"), {
    [decrypt("\126\138\51\114","\23\48\235\94")]=decrypt("\79\206\217\73\66\32\255\111\221","\178\28\186\184\61\55\83"),
    [decrypt("\247\196\93\57","\149\164\173\39\92\146\110")]=UDim2.new(0,0,0,18),
    [decrypt("\195\40\3\22\14\18\252\41","\123\147\71\112\127\122")]=UDim2.new(0,0,0,240),
    BackgroundTransparency=1,
    Text="",
    TextSize=11,
    Font=Enum.Font.Code,
    TextColor3=v13.TEXT_MID,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=1,
    ZIndex=13,
    Parent=leftPanel
});

local function setInfo(text, color, duration)
    infoLabel.Text=text;
    infoLabel.TextColor3=color or v13.TEXT_MID;
    tweenObject(infoLabel, {TextTransparency=0}, 0.15);
    if duration then
        task.delay(duration, function()
            if (infoLabel and infoLabel.Parent) then
                tweenObject(infoLabel, {TextTransparency=1}, 0.1);
            end
        end);
    end
end

-- Script list
local scriptList = createInstance(decrypt("\240\180\230\202\124","\215\182\198\135\167\25"), {
    [decrypt("\163\72\231\77","\40\237\41\138")]=decrypt("\229\96\244\202\69\208","\42\167\20\154\152"),
    [decrypt("\121\247\184\71","\65\42\158\194\34\17")]=UDim2.new(1,0,0,44),
    [decrypt("\42\40\65\5\57\228\20\224","\142\122\71\50\108\77\141\123")]=UDim2.new(0,0,0,266),
    BackgroundTransparency=1,
    ZIndex=13,
    Parent=leftPanel
});

-- Script button 1 (Loadstring)
local loadstringBtn = createInstance(decrypt("\145\245\80\208\135\229\92\208\170\254","\164\197\144\40"), {
    [decrypt("\173\241\167\142","\214\227\144\202\235\189")]=decrypt("\222\176\133\118\25\167\113\40\227","\92\141\197\231\27\112\211\51"),
    [decrypt("\213\246\144\166","\177\134\159\234\195")]=UDim2.new(0.56,-4,1,0),
    [decrypt("\141\228\44\169\221\180\228\49","\169\221\139\95\192")]=UDim2.new(0,0,0,0),
    [decrypt("\252\138\124\52\37\52\209\158\113\59\1\41\210\132\109\108","\70\190\235\31\95\66")]=Color3.fromRGB(0,40,22),
    [decrypt("\152\227\25\237\226\168\237\15\232\225\142\240\27\232\246\170\227\8\227\235\185\251","\133\218\130\122\134")]=0,
    [decrypt("\30\240\241\192\217\177\11\53\229\230\244\213\187\61\48","\88\92\159\131\164\188\195")]=0,
    Text="LOADSTRING",
    TextSize=14,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_GREEN,
    TextScaled=false,
    ZIndex=14,
    Parent=scriptList
});

createUIPadding(loadstringBtn, 4);
local loadstringStroke = createStroke(loadstringBtn, v13.NEON_GREEN, 1, 0.3);

loadstringBtn.MouseEnter:Connect(function()
    tweenObject(loadstringBtn, {BackgroundColor3=Color3.fromRGB(0,60,35)}, 0.15);
    tweenObject(loadstringStroke, {Transparency=0}, 0.15);
end);

loadstringBtn.MouseLeave:Connect(function()
    tweenObject(loadstringBtn, {BackgroundColor3=Color3.fromRGB(0,40,22)}, 0.15);
    tweenObject(loadstringStroke, {Transparency=0.3}, 0.15);
end);

-- Script button 2 (HttpGet)
local httpgetBtn = createInstance(decrypt("\21\216\162\102\45\52\201\174\125\1","\111\65\189\218\18"), {
    [decrypt("\109\74\22\48","\207\35\43\123\85\107\60")]=decrypt("\87\175\180\193\124\105\136\180\228","\25\16\202\192\138"),
    [decrypt("\206\194\183\231","\148\157\171\205\130\201")]=UDim2.new(0.44,-4,1,0),
    [decrypt("\19\219\103\32\197\255\44\218","\150\67\180\20\73\177")]=UDim2.new(0,4,0,0),
    [decrypt("\175\25\25\70\138\10\21\88\131\28\57\66\129\23\8\30","\45\237\120\122")]=Color3.fromRGB(0,25,45),
    [decrypt("\245\233\161\39\208\250\173\57\217\236\150\62\214\230\177\60\214\250\167\34\212\241","\76\183\136\194")]=0,
    [decrypt("\88\233\247\60\85\93\39\115\252\224\8\89\87\17\118","\116\26\134\133\88\48\47")]=0,
    Text="HTTPGET",
    TextSize=14,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_BLUE,
    TextScaled=false,
    ZIndex=14,
    Parent=scriptList
});

createUIPadding(httpgetBtn, 4);
local httpgetStroke = createStroke(httpgetBtn, v13.NEON_BLUE, 1, 0.3);

httpgetBtn.MouseEnter:Connect(function()
    tweenObject(httpgetBtn, {BackgroundColor3=Color3.fromRGB(0,35,65)}, 0.15);
    tweenObject(httpgetStroke, {Transparency=0}, 0.15);
end);

httpgetBtn.MouseLeave:Connect(function()
    tweenObject(httpgetBtn, {BackgroundColor3=Color3.fromRGB(0,25,45)}, 0.15);
    tweenObject(httpgetStroke, {Transparency=0.3}, 0.15);
end);

-- Separator
local separator = createInstance(decrypt("\171\90\133\228\117","\214\237\40\228\137\16"), {
    [decrypt("\171\226\226\220","\198\229\131\143\185\99")]=decrypt("\97\158\167\116\67\137\187\96\102\158\169\99","\19\49\236\200"),
    [decrypt("\205\62\236\178","\218\158\87\150\215\132")]=UDim2.new(1,0,0,6),
    [decrypt("\203\17\202\235\34\43\194\245","\173\155\126\185\130\86\66")]=UDim2.new(0,0,0,320),
    [decrypt("\199\167\185\204\143\254\234\179\180\195\171\227\233\169\168\148","\140\133\198\218\167\232")]=v13.BORDER_DIM,
    [decrypt("\151\47\183\118\131\167\33\161\115\128\129\60\181\115\151\165\47\166\120\138\182\55","\228\213\78\212\29")]=0,
    [decrypt("\165\67\164\1\238\149\127\191\31\238\183\69\174\0\231","\139\231\44\214\101")]=0,
    BackgroundTransparency=false,
    ZIndex=13,
    Parent=scriptList
});

createUIPadding(separator, 3);

-- Separator indicator
local separatorIndicator = createInstance(decrypt("\84\4\49\92\196","\87\18\118\80\49\161"), {
    [decrypt("\98\31\215\165","\208\44\126\186\192")]=decrypt("\209\19\168\202","\46\151\122\196\166\116\156\169"),
    [decrypt("\214\228\92\31","\155\133\141\38\122")]=UDim2.new(0,0,0,0),
    [decrypt("\7\43\175\74\72\109\170\48\36\168\98\64\115\170\55\121","\197\69\74\204\33\47\31")]=v13.NEON_GREEN,
    [decrypt("\210\78\89\140\247\93\85\146\254\75\110\149\241\65\73\151\241\93\95\137\243\86","\231\144\47\58")]=0,
    [decrypt("\144\215\200\113\29\47\252\48\168\221\234\124\0\56\195","\89\210\184\186\21\120\93\175")]=0,
    ZIndex=15,
    Parent=separator
});

createUIPadding(separatorIndicator, 3);

-- Clock
local clockLabel = createInstance(decrypt("\16\190\214\161\8\186\204\176\40","\213\68\219\174"), {
    [decrypt("\37\225\46\226","\31\107\128\67\135\74\165\95")]=decrypt("\254\231\243\89\68\163","\209\184\136\156\45\33"),
    [decrypt("\52\193\111\13","\216\103\168\21\104")]=UDim2.new(0,0,0,14),
    [decrypt("\72\162\80\173\108\164\76\170","\196\24\205\35")]=UDim2.new(0,0,0,-20),
    BackgroundTransparency=1,
    Text="CLOCK: " .. os.date("%H:%M:%S"),
    TextSize=9,
    Font=Enum.Font.Code,
    TextColor3=v13.TEXT_DIM,
    ZIndex=14,
    Parent=leftPanel
});

-- Update clock
task.spawn(function()
    while screenGui and screenGui.Parent do
        if (clockLabel and clockLabel.Parent) then
            clockLabel.Text="CLOCK: " .. os.date("%H:%M:%S");
        end
        task.wait(1);
    end
end);

-- Bottom panel
local bottomPanel = createInstance(decrypt("\164\25\91\38\135","\75\226\107\58"), {
    [decrypt("\118\223\28\127","\173\56\190\113\26\113\162")]=decrypt("\251\140","\151\171\190\77\101"),
    [decrypt("\246\38\226\172","\107\165\79\152\201\152\29")]=UDim2.new(1,-40,1,-40),
    [decrypt("\103\65\251\194\64\118\88\64","\31\55\46\136\171\52")]=UDim2.new(1.2,0,0,20),
    BackgroundTransparency=1,
    ZIndex=12,
    BackgroundTransparency=false,
    Parent=contentArea
});

-- Bottom buttons
local bottomButtons = createInstance(decrypt("\219\199\69\93\220\238\192\88\69","\144\143\162\61\41"), {
    [decrypt("\206\210\16\85","\83\128\179\125\48\18\231")]=decrypt("\117\178\242\217\66\12","\126\61\215\147\189\39"),
    [decrypt("\75\246\7\64","\37\24\159\125")]=UDim2.new(1,0,0,28),
    [decrypt("\234\169\102\75\206\175\122\76","\34\186\198\21")]=UDim2.new(0,0,0,0),
    BackgroundTransparency=1,
    Text="⚡ BYPASSED KEY SYSTEM",
    TextSize=14,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_BLUE,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=13,
    Parent=bottomPanel
});

-- Bottom buttons 2
local bottomButtons2 = createInstance(decrypt("\162\199\72\87\74","\47\228\181\41\58"), {
    [decrypt("\149\245\195\62","\127\198\156\185\91\99\80")]=UDim2.new(1,0,0,40),
    [decrypt("\197\21\223\249\179\2\54\208","\190\149\122\172\144\199\107\89")]=UDim2.new(0,0,0,38),
    [decrypt("\16\4\242\245\249\32\10\228\240\250\17\10\253\241\236\97","\158\82\101\145\158")]=v13.NEON_BLUE,
    [decrypt("\82\255\1\29\67\98\241\23\24\64\68\236\3\24\87\96\255\16\19\74\115\231","\36\16\158\98\118")]=0,
    [decrypt("\226\25\209\255\93\250\20\236\218\19\243\242\64\237\43","\133\160\118\163\155\56\136\71")]=0,
    ZIndex=13,
    Parent=bottomPanel
});

-- Script options
local scriptOptions = createInstance(decrypt("\209\250\216\162\242","\207\151\136\185"), {
    [decrypt("\134\130\37\135","\17\200\227\72\226\20\24")]=decrypt("\131\85\30\199\218\221\230\236\164","\159\208\33\123\183\169\145\143"),
    [decrypt("\193\83\34\51","\86\146\58\88")]=UDim2.new(1,0,0,30),
    [decrypt("\104\208\249\201\186\224\57\244","\154\56\191\138\160\206\137\86")]=UDim2.new(0,0,0,50),
    BackgroundTransparency=1,
    ZIndex=12,
    Parent=bottomPanel
});

-- Script options list
createInstance(decrypt("\55\99\113\211\4\19\46\239\27\69\72\206","\142\98\42\61\186\119\103\98"), {
    [decrypt("\11\176\16\28\23\173\6\13\42","\104\88\223\98")]=Enum.SortOrder.LayoutOrder,
    [decrypt("\116\246\230\202\11\227\67","\141\36\151\130\174\98")]=UDim.new(0,5),
    Parent=scriptOptions
});

-- Menu items
local menuItems = {
    {idx="1", text=decrypt("\87\244\133\70\176\236\231\53\219\163\117\130\236\240\92\214\167\5\134\236\222\112\244\131\82\251\184\211\53\251\131\85\162\236\233\71\212","\188\21\152\236\37\219\204"), col=v13.NEON_GREEN},
    {idx="2", text=decrypt("\151\54\12\4\96\211\182\63\73\29\37\208\248\36\27\5\55\193\189\52\73\5\46\146\161\41\28\24\96\214\189\48\0\9\37","\178\216\70\105\106\64"), col=v13.NEON_GREEN},
    {idx="3", text=decrypt("\203\42\171\3\88\187\30\138\59\29\242\37\172\24\29\250\47\188\5\88\232\56\248\21\92\233\107\185\25\89\187\59\170\18\78\232\107\157\57\105\222\25","\61\155\75\216\119"), col=v13.NEON_GREEN},
    {idx="4", text=decrypt("\226\82\88\220\202\82\78\214\134\78\64\212\210\74\78\192\195\29\73\221\212\29\68\215\223\29\72\215\200\88\93\211\210\84\64\220","\178\166\61\47"), col=v13.NEON_AMBER},
    {idx="5", text=decrypt("\103\225\216\47\83\196\47\65\174\207\51\29\213\53\69\250\205\50\83\219\34\93\174\206\36\28\221\103\80\230\205\118\0\223\33\80\249\201\36\22","\71\36\142\168\86\115\176"), col=v13.NEON_AMBER},
    {idx="6", text=decrypt("\210\249\20\69\253\238\188\8\85\253\229\188\1\94\235\160\236\1\67\251\229\188\11\85\246\160\232\8\85\225\160\199\64\102\202\210\213\38\105\175\221","\143\128\156\96\48"), col=v13.NEON_BLUE}
};

for idx, item in ipairs(menuItems) do
    local btnContainer = createInstance(decrypt("\64\209\63\66\136\138\135\113\216","\229\20\180\71\54\196\235"), {
        [decrypt("\26\119\219\230","\224\73\30\161\131\149\202")]=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        ZIndex=item.idx,
        LayoutOrder=tonumber(item.idx),
        Parent=scriptOptions
    });
    
    local btnText = createInstance(decrypt("\55\248\205\238\47\252\215\255\15","\154\99\157\181"), {
        [decrypt("\190\6\246\165","\140\237\111\140\192")]=UDim2.new(1,-46,1,0),
        [decrypt("\54\22\110\17\18\16\114\22","\120\102\121\29")]=UDim2.new(0,40,0,0),
        BackgroundTransparency=1,
        Text=item.text,
        TextSize=11,
        Font=Enum.Font.Code,
        TextColor3=v13.TEXT_BRIGHT,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=true,
        ZIndex=14,
        Parent=btnContainer
    });
    
    local btnIndicator = createInstance(decrypt("\82\107\53\23\238","\199\20\25\84\122\139\87\145"), {
        [decrypt("\105\8\208\171","\138\39\105\189\206\123")]=decrypt("\61\6\141\42\246","\159\127\103\233\77\147\153\175"),
        [decrypt("\52\249\254\175","\171\103\144\132\202\32")]=UDim2.new(0,30,0,30),
        [decrypt("\32\32\250\5\4\38\230\2","\108\112\79\137")]=UDim2.new(0,0,0,0),
        [decrypt("\29\195\119\35\170\19\230\32\49\198\87\39\161\14\251\102","\85\95\162\20\72\205\97\137")]=item.col,
        [decrypt("\213\252\41\215\10\234\194\226\243\46\232\31\249\195\228\237\43\206\8\246\206\238","\173\151\157\74\188\109\152")]=0.8,
        [decrypt("\6\7\42\217\217\70\230\250\62\13\8\212\196\81\217","\147\68\104\88\189\188\52\181")]=0,
        ZIndex=13,
        Parent=btnContainer
    });
    createUIPadding(btnIndicator, 4);
end

-- Copy button
local copyButton = createInstance(decrypt("\182\224\155\39\246\14\28\150\234\141","\104\226\133\227\83\180\123"), {
    [decrypt("\45\10\46\85","\48\99\107\67")]=decrypt("\253\169\109\201\15\111\208","\27\190\198\29\176\77"),
    [decrypt("\220\66\231\49","\46\143\43\157\84\201")]=UDim2.new(1,0,0,44),
    [decrypt("\103\119\69\203\75\26\199\89","\168\55\24\54\162\63\115")]=UDim2.new(0,0,0,278),
    [decrypt("\53\251\35\139\213\220\24\239\46\132\241\193\27\245\50\211","\174\119\154\64\224\178")]=Color3.fromRGB(0,40,22),
    [decrypt("\8\127\198\112\2\181\21\241\36\122\241\105\4\169\9\244\43\108\192\117\6\190","\132\74\30\165\27\101\199\122")]=0,
    [decrypt("\13\232\237\163\162\167\135\38\253\250\151\174\173\177\35","\212\79\135\159\199\199\213")]=0,
    Text="📋  [ COPY LINK ]",
    TextSize=14,
    Font=Enum.Font.Code,
    TextColor3=v13.NEON_GREEN,
    TextScaled=false,
    ZIndex=14,
    Parent=bottomPanel
});

createUIPadding(copyButton, 4);
local copyStroke = createStroke(copyButton, v13.NEON_GREEN, 1, 0.2);

copyButton.MouseEnter:Connect(function()
    tweenObject(copyButton, {BackgroundColor3=Color3.fromRGB(0,60,35)}, 0.15);
    tweenObject(copyStroke, {Transparency=0}, 0.15);
end);

copyButton.MouseLeave:Connect(function()
    tweenObject(copyButton, {BackgroundColor3=Color3.fromRGB(0,40,22)}, 0.15);
    tweenObject(copyStroke, {Transparency=0.2}, 0.15);
end);

-- Copy success label
local copySuccess = createInstance(decrypt("\158\13\80\251\167\171\10\77\227","\235\202\104\40\143"), {
    [decrypt("\35\138\22\188","\217\109\235\123")]=decrypt("\4\134\110\79\83\223\195\187\46\155\115","\221\71\233\30\54\16\176\173"),
    [decrypt("\7\245\68\186","\223\84\156\62")]=UDim2.new(1,0,0,20),
    [decrypt("\230\243\241\212\163\50\217\242","\91\182\156\130\189\215")]=UDim2.new(0,0,0,320),
    BackgroundTransparency=1,
    Text="✓ LINK COPIED TO CLIPBOARD",
    TextSize=10,
    Font=Enum.Font.Code,
    TextColor3=v13.SUCCESS,
    TextTransparency=1,
    ZIndex=14,
    Parent=bottomPanel
});

-- Return button
local returnButton = createInstance(decrypt("\208\209\35\234\3\241\192\47\241\47","\65\132\180\91\158"), {
    [decrypt("\43\125\220\43","\78\101\28\177")]=decrypt("\7\181\227\90\7\160\238","\49\69\212\128"),
    [decrypt("\36\5\202\247","\129\119\108\176\146")]=UDim2.new(1,0,0,36),
    [decrypt("\12\192\20\196\49\7\19\50","\124\92\175\103\173\69\110")]=UDim2.new(0,0,0,348),
    [decrypt("\227\57\0\60\198\42\12\34\207\60\32\56\205\55\17\100","\87\161\88\99")]=Color3.fromRGB(20,22,30),
    [decrypt("\48\248\236\199\176\194\44\7\247\235\248\165\209\45\1\233\238\222\178\222\32\11","\67\114\153\143\172\215\176")]=0,
    [decrypt("\156\173\252\10\187\176\221\7\164\167\222\7\166\167\226","\110\222\194\142")]=0,
    Text="← RETURN TO MENU",
    TextSize=12,
    Font=Enum.Font.Code,
    TextColor3=v13.TEXT_MID,
    TextScaled=false,
    ZIndex=14,
    Parent=bottomPanel
});

createUIPadding(returnButton, 4);
createStroke(returnButton, v13.BORDER_DIM, 1, 0.4);

returnButton.MouseEnter:Connect(function()
    tweenObject(returnButton, {BackgroundColor3=Color3.fromRGB(30,35,45), TextColor3=v13.TEXT_BRIGHT}, 0.15);
end);

returnButton.MouseLeave:Connect(function()
    tweenObject(returnButton, {BackgroundColor3=Color3.fromRGB(20,22,30), TextColor3=v13.TEXT_MID}, 0.15);
end);

-- Loadstring button functionality
loadstringBtn.MouseButton1Click:Connect(function()
    local scriptText = scriptInput.Text
    if scriptText ~= "" then
        local success, result = pcall(function() loadstring(scriptText)() end)
        if success then
            setInfo("✓ Script executed successfully!", v13.SUCCESS, 3)
        else
            setInfo("✗ Error: " .. tostring(result), v13.ERROR, 3)
        end
    else
        setInfo("✗ Please enter a script!", v13.ERROR, 2)
    end
end)

-- HttpGet button functionality
httpgetBtn.MouseButton1Click:Connect(function()
    local url = scriptInput.Text
    if url ~= "" and (url:match("^https?://") or url:match("^raw%.")) then
        setInfo("⬇ Downloading script...", v13.NEON_AMBER)
        local success, result = pcall(function()
            local content = game:HttpGet(url)
            loadstring(content)()
        end)
        if success then
            setInfo("✓ Script loaded and executed!", v13.SUCCESS, 3)
        else
            setInfo("✗ Error: " .. tostring(result), v13.ERROR, 3)
        end
    else
        setInfo("✗ Please enter a valid URL!", v13.ERROR, 2)
    end
end)

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    local link = v8.KEY_LINK or "https://example.com/getkey"
    pcall(function()
        if setclipboard then
            setclipboard(link)
        elseif toclipboard then
            toclipboard(link)
        end
    end)
    copyButton.Text = "✓  COPIED!"
    copyButton.TextColor3 = v13.SUCCESS
    tweenObject(copySuccess, {TextTransparency=0}, 0.15)
    
    task.delay(2.5, function()
        if (copyButton and copyButton.Parent) then
            copyButton.Text = "📋  [ COPY LINK ]"
            copyButton.TextColor3 = v13.NEON_GREEN
            tweenObject(copySuccess, {TextTransparency=1}, 0.1)
        end
    end)
end)

-- Animations
task.spawn(function()
    mainBg.BackgroundTransparency = 0
    mainBg.Size = UDim2.new(0, 600, 0, 400)
    mainBg.Position = UDim2.new(0.5, -300, 0.5, -200)
    task.wait(0.1)
    
    tweenObject(mainPanel, {Position=UDim2.new(0.5, -200, 0.5, -240), Size=UDim2.new(0, 400, 0, 480)}, 0.5, Enum.EasingStyle.Quint)
    task.wait(0.5)
    
    -- Welcome message
    local welcomeMessages = {
        {text="╔══════════════════════════╗", color=v13.TEXT_DIM},
        {text="║  KEY SYSTEM BYPASSED    ║", color=v13.TEXT_DIM},
        {text="║  ====================   ║", color=v13.NEON_GREEN},
        {text="║  Welcome, " .. v12.Name .. "!", color=v13.NEON_GREEN},
        {text="╚══════════════════════════╝", color=v13.TEXT_DIM}
    }
    
    for _, msg in ipairs(welcomeMessages) do
        local line = createInputLine("", msg.color, _)
        typewriterEffect(line, msg.text, 0.02, msg.color)
        task.wait(0.15)
    end
    
    setInfo("✓ System ready - Select an option above", v13.NEON_GREEN, 5)
end)

-- Animate glow
task.spawn(function()
    while screenGui and screenGui.Parent do
        tweenObject(glowEffect, {Position=UDim2.new(0,0,1.1,0)}, 4, Enum.EasingStyle.Linear)
        task.wait(5)
    end
end)

-- Animate border
task.spawn(function()
    while screenGui and screenGui.Parent do
        tweenObject(loadstringStroke, {Transparency=0.7}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
        tweenObject(loadstringStroke, {Transparency=0.3}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
    end
end)

-- Display order
task.spawn(function()
    while screenGui and screenGui.Parent do
        screenGui.DisplayOrder = 999
        task.wait(2)
    end
end)

print("✓ Nexus Key System Bypassed - Menu Loaded!")