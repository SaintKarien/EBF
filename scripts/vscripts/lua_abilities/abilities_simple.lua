
require( "libraries/Timers" )
require( "lua_abilities/Check_Aghanim" )


if abilities_simple == nil then
    print ( '[abilities_simple] creating abilities_simple' )
    abilities_simple = {} -- Creates an array to let us beable to index abilities_simple when creating new functions
    abilities_simple.__index = abilities_simple
end
 
function abilities_simple:new() -- Creates the new class
    print ( '[abilities_simple] abilities_simple:new' )
    o = o or {}
    setmetatable( o, abilities_simple )
    return o
end

function abilities_simple:start() -- Runs whenever the abilities_simple.lua is ran
    print('[abilities_simple] abilities_simple started!')
end

function projectile_cloud( keys )
    local ability = keys.ability
    local caster = keys.caster

    local casterPoint = caster:GetAbsOrigin()
    -- Spawn projectile
    local projectileTable = {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf",
        vSpawnOrigin = casterPoint,
        fDistance = 1000,
        fStartRadius = 300,
        fEndRadius = 500,
        fExpireTime = GameRules:GetGameTime() + 5,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * 300,
    }
    projectile = ProjectileManager:CreateLinearProjectile(projectileTable)
end
function projectile_spear( keys )
    local ability = keys.ability
    local caster = keys.caster

    local casterPoint = caster:GetAbsOrigin()
    -- Spawn projectile
    local projectileTable = {
        Ability = ability,
        EffectName = "particles/light_spear.vpcf",
        vSpawnOrigin = casterPoint,
        fDistance = 5000,
        fStartRadius = 50,
        fEndRadius = 50,
        fExpireTime = GameRules:GetGameTime() + 5,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * 1200,
        vAcceleration = caster:GetForwardVector() * 200
    }
    projectile = ProjectileManager:CreateLinearProjectile(projectileTable)
end
function projectile_crystal( keys )
    local ability = keys.ability
    local caster = keys.caster
    local projectile_count = 7 --ability:GetLevelSpecialValueFor("projectile_count", ability:GetLevel()-1) -- If you want to make it more powerful with levels
    local number_of_source = ability:GetLevelSpecialValueFor("source_count", ability:GetLevel()-1)
    local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel()-1)
    local distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel()-1)
    local time_interval = 0.20
    local speed = 600
    local forward = caster:GetForwardVector()

    local casterPoint = caster:GetAbsOrigin()
    print (delay)
    -- Spawn projectile
    local projectileTable = {
        Ability = ability,
        EffectName = "particles/crystal_maiden_projectil_spawner_work.vpcf",
        vSpawnOrigin = casterPoint,
        fDistance = 900 + (delay * 300),
        fStartRadius = 50,
        fEndRadius = 50,
        fExpireTime = GameRules:GetGameTime() + 6,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        bDeleteOnHit = false,
        vVelocity = forward * 300,
    }
        projectile = ProjectileManager:CreateLinearProjectile(projectileTable)
    local info = {
        Ability = ability,
        EffectName = "particles/ice_spear.vpcf",
        vSpawnOrigin = casterPoint + forward * 600,
        fDistance = distance,
        fStartRadius = 50,
        fEndRadius = 50,
        fExpireTime = GameRules:GetGameTime() + 10,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        bDeleteOnHit = true,
        vVelocity = forward * 600,
    }

    --Creates the projectiles in 360 degrees
    if number_of_source == 1 or number_of_source > 2 then
        Timers:CreateTimer(delay,function()
            local projectiles_created = 0
            for i=-180,180,(180/projectile_count) do
                i = i+180
                local time = projectiles_created * time_interval
                projectiles_created = projectiles_created + 1

                --EmitSoundOn("", caster) --Add a sound if you wish!
                Timers:CreateTimer(time, function()
                    info.vSpawnOrigin = casterPoint + (forward * 300 * time) + forward * 300* delay + forward * 75
                    info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), forward) * speed
                    small_projectile_1 = ProjectileManager:CreateLinearProjectile( info )
                end)
            end
        end)
    end
    if number_of_source >=2 then
        Timers:CreateTimer(delay,function()
            local projectiles_created = 0
            for i=-180,180,(180/projectile_count) do
                if number_of_source == 3 then
                    i = i - 30
                end
                i = i+90
                local time = projectiles_created * time_interval
                projectiles_created = projectiles_created + 1

                --EmitSoundOn("", caster) --Add a sound if you wish!
                Timers:CreateTimer(time, function()
                    info.vSpawnOrigin = casterPoint + (forward * 300 * time) + forward * 300 * delay + forward * 75
                    info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), forward) * speed
                    small_projectile_2 = ProjectileManager:CreateLinearProjectile( info )
                end)
            end
        end)
    end
    if number_of_source >=2 then
        Timers:CreateTimer(delay,function()
            local projectiles_created = 0
            for i=-180,180,(180/projectile_count) do
                i = i+270
                if number_of_source == 3 then
                    i = i + 30
                end
                local time = projectiles_created * time_interval
                projectiles_created = projectiles_created + 1

                --EmitSoundOn("", caster) --Add a sound if you wish!
                Timers:CreateTimer(time, function()
                    info.vSpawnOrigin = casterPoint + (forward * 300 * time) + forward * 300* delay + forward * 75
                    info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), forward) * speed
                    small_projectile_3 = ProjectileManager:CreateLinearProjectile( info )
                end)
            end
        end)
    end
    if number_of_source == 4 then
        Timers:CreateTimer(delay,function()
            local projectiles_created = 0
            for i=-180,180,(180/projectile_count) do
                local time = projectiles_created * time_interval
                projectiles_created = projectiles_created + 1

                --EmitSoundOn("", caster) --Add a sound if you wish!
                Timers:CreateTimer(time, function()
                    info.vSpawnOrigin = casterPoint + (forward * 300 * time) + forward * 300* delay + forward * 75
                    info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), forward) * speed
                    small_projectile_4 = ProjectileManager:CreateLinearProjectile( info )
                end)
            end
        end)
    end
end
function projectile_lol_orbs( keys )
    local ability = keys.ability
    local caster = keys.caster
    local count = 0
    local casterPoint = caster:GetAbsOrigin()
    -- Spawn projectile
    local direction = caster:GetForwardVector()
    local projectileTable = {}
    print ("yolo")
    Timers:CreateTimer(0.1,function()
        count = count +1
        if count <= 70 then
            projectileTable = {
                Ability = ability,
                EffectName = "particles/boss/boss_shadows_orb.vpcf",
                vSpawnOrigin = casterPoint,
                fDistance = 5000,
                fStartRadius = 80,
                fEndRadius = 80,
                fExpireTime = GameRules:GetGameTime() + 5,
                Source = caster,
                bHasFrontalCone = true,
                bReplaceExisting = false,
                bProvidesVision = false,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                iUnitTargetType = DOTA_UNIT_TARGET_ALL,
                vVelocity = caster:GetForwardVector() * 500,
            }
            projectile = ProjectileManager:CreateLinearProjectile(projectileTable)
            return 0.08
        end
    end)
end
function test()
    print ("test")
end

--[[
    Author: Noya
    Date: April 5, 2015
    Return a front position at a distance
]]
function ShadowrazePoint( event )
    local caster = event.caster
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    local distance = event.distance
    
    local front_position = origin + fv * distance
    local result = {}
    table.insert(result, front_position)

    return result

end

function Shadowraze_effect( event )
    local caster = event.caster
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    local distance = 900
    
    local front_position = origin + fv * distance

    local ability = keys.ability

    local casterPoint = caster:GetAbsOrigin()
    -- Spawn projectile
    local projectileTable = {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf",
        vSpawnOrigin = front_position,
        fDistance = 5,
        fStartRadius = 1,
        fEndRadius = 1,
        fExpireTime = GameRules:GetGameTime() + 5,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * 0,
    }
    projectile = ProjectileManager:CreateLinearProjectile(projectileTable)
end

--[[ 
     Author: Noya
     Date: 26 September 2015
     Creates projectiles in 360 degrees with a time interval between them
--]]
function projectile_dark_orbs( event )
    local caster = event.caster
    local ability = event.ability
    local origin = caster:GetAbsOrigin()
    local projectile_count = 80 --ability:GetLevelSpecialValueFor("projectile_count", ability:GetLevel()-1) -- If you want to make it more powerful with levels
    local speed = 700
    local time_interval = 0.05 -- Time between each launch

    local info = {
        EffectName =  "particles/boss/boss_shadows_orb.vpcf",
        Ability = ability,
        vSpawnOrigin = origin,
        fDistance = 1250,
        fStartRadius = 75,
        fEndRadius = 75,
        Source = caster,
        bHasFrontalCone = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        --fMaxSpeed = 5200,
        bReplaceExisting = false,
        bProvidesVision = false,
        fExpireTime = GameRules:GetGameTime() + 7,
        vVelocity = 0.0, --vVelocity = caster:GetForwardVector() * 1800,
        iMoveSpeed = speed,
    }

    origin.z = 0
    info.vVelocity = origin:Normalized() * speed

    --Creates the projectiles in 1440 degrees
    Timers:CreateTimer(1.0,function()
        local projectiles_created = 0
        for i=-720,720,(1440/projectile_count) do
            local time = projectiles_created * time_interval
            projectiles_created = projectiles_created + 1

            --EmitSoundOn("", caster) --Add a sound if you wish!
            Timers:CreateTimer(time, function()
                info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * speed
                projectile = ProjectileManager:CreateLinearProjectile( info )
            end)
        end
    end)
end















function sacrifice(keys)
    local caster = keys.caster

    for _,unit in pairs ( Entities:FindAllByName( "npc_dota_hero*")) do
        if not unit:IsAlive() and HasCustomScepter(caster) then
            unit:RespawnUnit()
        end
        if unit:IsAlive() then
            unit:SetHealth( unit:GetMaxHealth() )
            unit:SetMana( unit:GetMaxMana() )
        end
    end
    caster:ForceKill(true)
end


function Give_Control( keys )
    local target = keys.target
    local caster = keys.caster
    local PlayerID = caster:GetMainControllingPlayer() 
    target:SetTeam(caster:GetTeam())
    target:SetControllableByPlayer( PlayerID, false)
end

function End_Control( keys )
    local target = keys.target
    local caster = keys.caster
    local level = keys.ability:GetLevelSpecialValueFor( "agh_level" , keys.ability:GetLevel() - 1 )
    target:SetTeam(DOTA_TEAM_BADGUYS)
    target:SetControllableByPlayer( -1, false)
    local hp_percent = keys.ability:GetLevelSpecialValueFor( "hp_regen" , keys.ability:GetLevel() - 1 ) * 0.01
    local regen_health = target:GetMaxHealth()*hp_percent
    if HasCustomScepter(caster) then
        if target:GetLevel() <= level then
                target:ForceKill(true)
        else
            regen_health = 0
        end
    end
    target:SetHealth(target:GetHealth()+regen_health)
    if target:GetHealth() > target:GetMaxHealth() then 
        target:SetHealth(target:GetMaxHealth())
    end
end


function spawn_unit( keys )
    local caster = keys.caster
    local unit = keys.unit_to_spawn
    if keys.number_of_unit==nil then keys.number_of_unit=1 end
    for i = 0, keys.number_of_unit-1 do
        local entUnit = CreateUnitByName( unit ,caster:GetAbsOrigin() + RandomVector(RandomInt(400,400)), true, nil, nil, DOTA_TEAM_BADGUYS )
    end
    
    print ("ça marche !")
end

--[[
    Author: kritth
    Date: 7.1.2015.
    Fire missiles if there are targets, else play dud

    edited by frenchdeath to going with epic boss fight change
]]
function rearm_start( keys )
    local caster = keys.caster
    local ability = keys.ability
    local abilityLevel = ability:GetLevel()
    if abilityLevel <= 3 then 
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_rearm_level_1_datadriven", {} )
    elseif abilityLevel <= 5 then 
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_rearm_level_2_datadriven", {} )
    else
        ability:ApplyDataDrivenModifier( caster, caster, "modifier_rearm_level_3_datadriven", {} )
    end
end

function rearm_refresh_cooldown( keys )
    local caster = keys.caster
    
    -- Reset cooldown for abilities
    local no_refresh_skill = {["omniknight_guardian_angel"] = true}
    for i = 0, caster:GetAbilityCount() - 1 do
        local ability = caster:GetAbilityByIndex( i )
        if ability and ability ~= keys.ability and not no_refresh_skill[ ability:GetAbilityName() ] then
            ability:EndCooldown()
        end
    end

    local no_refresh_item = {["item_sheepstick_2"] = true,["item_ressurection_stone"] = true,["item_refresher"] = true,["item_bahamut_chest"]= true}

    for i = 0, 5 do
        local item = caster:GetItemInSlot( i )
        if item and not no_refresh_item[ item:GetAbilityName() ] then
            item:EndCooldown()
        end
    end
end

function heat_seeking_missile_seek_targets( keys )
    -- Variables
    local caster = keys.caster
    local ability = keys.ability
    local particleName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
    local modifierDudName = "modifier_heat_seeking_missile_dud"
    local projectileSpeed = 900
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local max_targets = ability:GetLevelSpecialValueFor( "targets", ability:GetLevel() - 1 )
    local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = DOTA_UNIT_TARGET_ALL
    local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
    local projectileDodgable = false
    local projectileProvidesVision = false
    
    -- pick up x nearest target heroes and create tracking projectile targeting the number of targets
    local units = FindUnitsInRadius(
        caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)
    if HasCustomScepter(caster) then
        units = FindUnitsInRadius(
        caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 3000, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)
        max_targets = max_targets*2
    end   
    -- Seek out target
    local count = 0
    for k, v in pairs( units ) do
        if count < max_targets then
            local projTable = {
                Target = v,
                Source = caster,
                Ability = ability,
                EffectName = particleName,
                bDodgeable = projectileDodgable,
                bProvidesVision = projectileProvidesVision,
                iMoveSpeed = projectileSpeed, 
                vSpawnOrigin = caster:GetAbsOrigin()
            }
            ProjectileManager:CreateTrackingProjectile( projTable )
            count = count + 1
        else
            break
        end
    end
    
    -- If no unit is found, fire dud
    if count == 0 then
        ability:ApplyDataDrivenModifier( caster, caster, modifierDudName, {} )
    end
end

function heat_seeking_missile_seek_damage( keys )
    -- Variables
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = ability:GetAbilityDamage() 

    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    if HasCustomScepter(caster) then
        local agh_damage = ability:GetLevelSpecialValueFor("damage_agh", ability:GetLevel()-1)
            damageTable = {
            victim = target,
            attacker = caster,
            damage = agh_damage,
            damage_type = DAMAGE_TYPE_MAGICAL
        }
    end
    ApplyDamage( damageTable )
    
    -- pick up x nearest target heroes and create tracking projectile targeting the number of targets
    
end

------------------------------------------------------------------------------
--[[Author: Pizzalol
    Date: 09.02.2015.
    Triggers when the unit attacks
    Checks if the attack target is the same as the caster
    If true then trigger the counter helix if its not on cooldown]]
function CounterHelix( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local helix_modifier = keys.helix_modifier

    -- If the caster has the helix modifier then do not trigger the counter helix
    -- as its considered to be on cooldown
    if target == caster and not caster:HasModifier(helix_modifier) then
        ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
    end
end




function Cooldown_Pure(keys)
    local ability = keys.ability
    local level = ability:GetLevel()
    local duration = ability:GetLevelSpecialValueFor("cooldown_duration", level)
    ability:StartCooldown(duration)
end

function Pierce_skill(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local percent = ability:GetLevelSpecialValueFor("Pierce_percent", ability:GetLevel()-1)
    local damage = keys.damage_on_hit*percent*0.01
    local damageTable = {victim = target,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_PURE,
                }
    ApplyDamage(damageTable)
end
function RageFunctionUrsa(keys)
    local modifierName = "rage"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local current_stack = target:GetModifierStackCount( modifierName, ability )
    local damagebase = ability:GetLevelSpecialValueFor("bonus_damage_per_stack", ability:GetLevel()-1)
    local damage = damagebase*current_stack
    local modifierName2 = "Modifier_Claw"
    if caster:HasModifier( modifierName2 ) then
        local ability_claw = caster:FindAbilityByName("ursa_claw")
        local percent = ability_claw:GetLevelSpecialValueFor("Pierce_percent_fury", ability_claw:GetLevel()-1)*0.01
        local multiplier = ability_claw:GetLevelSpecialValueFor("physical_fury_damage_mult", ability_claw:GetLevel()-1)*0.01
        local damageTable_fury = {victim = target,
                        attacker = caster,
                        damage = damage*percent,
                        damage_type = DAMAGE_TYPE_PURE,
                        }
        ApplyDamage(damageTable_fury)
        damage = damage * (1-percent) * multiplier
    end
    local damageTable = {victim = target,
                        attacker = caster,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
    ApplyDamage(damageTable)

    if target:HasModifier( modifierName ) then
        ability:ApplyDataDrivenModifier( caster, target, modifierName, {duration = 30} )
        target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
    else
        ability:ApplyDataDrivenModifier( caster, target, modifierName, {duration = 30})
        target:SetModifierStackCount( modifierName, ability, 1)
    end
end

function KillTarget(keys)
    local target = keys.target
    target:ForceKill(true)
end

function KillCaster(keys)
    local caster = keys.caster
    caster:ForceKill(true)
end

function HauntFunction(keys)
    local modifierName = "haunt"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:IsIllusion() == false then
        if target:HasModifier( modifierName ) then
            local current_stack = target:GetModifierStackCount( modifierName, ability )
            ability:ApplyDataDrivenModifier( caster, target, modifierName, nil )
            target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
        else
            ability:ApplyDataDrivenModifier( caster, target, modifierName, nil)
            target:SetModifierStackCount( modifierName, ability, 1)
        end
    end
end

function RageFunction(keys)
    local modifierName = "rage"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local current_stack = target:GetModifierStackCount( modifierName, ability )
    local damagebase = ability:GetLevelSpecialValueFor("bonus_damage_per_stack", 0)
    local damage = damagebase*current_stack
    local damageTable = {victim = target,
                        attacker = caster,
                        damage = damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        }
    ApplyDamage(damageTable)

    if target:HasModifier( modifierName ) then
        ability:ApplyDataDrivenModifier( caster, target, modifierName, {duration = 30} )
        target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
    else
        ability:ApplyDataDrivenModifier( caster, target, modifierName, {duration = 30})
        target:SetModifierStackCount( modifierName, ability, 1)
    end
end

function Chen_Bless(keys)
    print ('devil bless function called')
    local modifierName = "Modifier_bless_subtle"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damagebonus = caster:GetAverageTrueAttackDamage() 
    local percent = ability:GetLevelSpecialValueFor("damage_percent", ability:GetLevel()-1)
    local damage = damagebonus*percent*0.01
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)

    ability:ApplyDataDrivenModifier( caster, target, modifierName, {duration = 30} )
    target:SetModifierStackCount( modifierName, ability, damage)
end

function Devour_doom(keys)
    print ('devour function has been called')
    local modifierName = "iseating"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel()
    local gold = ability:GetLevelSpecialValueFor("total_gold", level-1)
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)
    local kill_rand = math.random(1,100)
    gold = gold
    ability:ApplyDataDrivenModifier( caster, caster, modifierName, {duration = duration})
    target:SetModifierStackCount( modifierName, ability, 1)
    ability:StartCooldown(duration)
    local total_unit = 0
    for _,unit in pairs ( Entities:FindAllByName( "npc_dota_hero*")) do
        if not unit:IsIllusion() then
            total_unit = total_unit + 1
        end
    end
    local gold_per_player = gold / total_unit
    for _,unit in pairs ( Entities:FindAllByName( "npc_dota_hero*")) do
        if not unit:IsIllusion() then
            local totalgold = unit:GetGold() + gold_per_player
            unit:SetGold(0 , false)
            unit:SetGold(totalgold, true)
        end
    end
end

function decay( keys )
    -- Variables
    local ability = keys.ability
    local caster = keys.caster
    local health_stack = 0
    local unit_number_decay = 0
    local modifierName = "decay_bonus_health"
    local modifierName_display = "decay_bonus_display"
    local dummyModifierName = "modifier_mystic_flare_dummy_vfx_datadriven"
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local target = keys.target_points[1]
    local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
    local bonus_health = ability:GetLevelSpecialValueFor( "health_bonus_per_unit", ability:GetLevel() - 1 )
    -- Create for VFX particles on ground
    local dummy = CreateUnitByName( "npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
    ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
    
    local units = FindUnitsInRadius(caster:GetTeam(),
                              target,
                              caster,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
    for _,unit in pairs(units) do
        local damageTable = {
                                victim = unit,
                                attacker = caster,
                                damage = damage,
                                damage_type = DAMAGE_TYPE_MAGICAL
                            }
        ApplyDamage( damageTable )
        unit_number_decay = unit_number_decay + 1
    end

    local health_stack = math.floor(unit_number_decay*bonus_health)
    print (health_stack)
    print (unit_number_decay)
    if unit_number_decay > 0 then
        ability:ApplyDataDrivenModifier( caster, caster, modifierName, {duration = duration})
        caster:SetModifierStackCount( modifierName, ability, health_stack)
        ability:ApplyDataDrivenModifier( caster, caster, modifierName_display, {duration = duration})
        caster:SetModifierStackCount( modifierName_display, ability, unit_number_decay)
    end
end


function Soul_Rip(keys)
    print ('Soul RIP function has been called')
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local health = ability:GetLevelSpecialValueFor("health_per_unit", level-1)
    local radius = ability:GetLevelSpecialValueFor("range", level-1)
    local kill_rand = math.random(1,100)
    local unit_number = 0
    local nearbyUnits = FindUnitsInRadius(target:GetTeam(),
                              target:GetAbsOrigin(),
                              nil,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
    local nearbyUnits2 = FindUnitsInRadius(target:GetTeam(),
                              target:GetAbsOrigin(),
                              nil,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
    for _,unit in pairs(nearbyUnits) do
        local damageTable = {
                                victim = unit,
                                attacker = caster,
                                damage = health,
                                damage_type = DAMAGE_TYPE_PURE
                            }
        ApplyDamage( damageTable )
        unit_number = unit_number + 1
    end
    for _,unit in pairs(nearbyUnits2) do
        unit_number = unit_number + 1
    end
    Timers:CreateTimer(1.2,function()
        if target:IsAlive() then
            target:SetHealth(target:GetHealth() + (unit_number*health) )
            if target:GetHealth() >= target:GetMaxHealth() then target:SetHealth(target:GetMaxHealth()) end
        end
    end)

end

function Death_Pact(event)
    print ('Death pact function has been called')
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1 )
    -- Health Gain
    local health_gain_pct = ability:GetLevelSpecialValueFor( "hp_percent" , ability:GetLevel() - 1 ) * 0.01
    local target_health = target:GetMaxHealth()
    local health_gain = math.floor(target_health * health_gain_pct)
    -- Damage Gain
    local damage_gain_pct = ability:GetLevelSpecialValueFor( "damage_percent" , ability:GetLevel() - 1 ) * 0.01
    local damage_gain = math.floor(target_health * damage_gain_pct)
    local damageTable = {
                            victim = target,
                            attacker = caster,
                            damage = health_gain/3,
                            damage_type = DAMAGE_TYPE_PURE
                        }
    ApplyDamage( damageTable )
    local health_modifier = "modifier_death_pact_health"
    ability:ApplyDataDrivenModifier(caster, caster, health_modifier, { duration = duration })
    caster:SetModifierStackCount( health_modifier, ability, health_gain )
    caster:Heal( health_gain, caster)

    local damage_modifier = "modifier_death_pact_damage"
    ability:ApplyDataDrivenModifier(caster, caster, damage_modifier, { duration = duration })
    caster:SetModifierStackCount( damage_modifier, ability, damage_gain )

    print("Gained "..damage_gain.." damage and  "..health_gain.." health")
    caster.death_pact_health = health_gain
end

-- Keeps track of the casters health
function DeathPactHealth( event )
    local caster = event.caster
    if caster:IsAlive() then
        caster.OldHealth = caster:GetHealth()
    end
end

-- Sets the current health to the old health
function SetCurrentHealth( event )
    local caster = event.caster
    if caster:IsAlive() then
        caster:SetHealth(caster.OldHealth)
    end
end

function SlarkFunction(keys)
    local modifierName_caster = "steal_c"
    local modifierName_target = "steal_t"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel()
    local cool_duration = ability:GetLevelSpecialValueFor("cooldown_duration", level-1)
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)
    if caster:IsIllusion() == false and ability:IsCooldownReady() then
        if target:HasModifier( modifierName_target ) then
            local current_stack = target:GetModifierStackCount( modifierName_target, ability )
            ability:ApplyDataDrivenModifier( caster, target, modifierName_target, {duration = duration} )
            target:SetModifierStackCount( modifierName_target, ability, current_stack + 1 )
        else
            ability:ApplyDataDrivenModifier( caster, target, modifierName_target, {duration = duration})
            target:SetModifierStackCount( modifierName_target, ability, 1)
        end
        if caster:HasModifier( modifierName_caster ) then
            local current_stack = caster:GetModifierStackCount( modifierName_caster, ability )
            ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster, {duration = duration} )
            caster:SetModifierStackCount( modifierName_caster, ability, current_stack + 1 )
        else
            ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster, {duration = duration})
            caster:SetModifierStackCount( modifierName_caster, ability, 1)
        end
        ability:StartCooldown(cool_duration)
    end
end

function PudgeFunction(keys)
    local modifierName_caster = "steal_c_pudge"
    local modifierName_caster_display = "steal_display_pudge"
    local modifierName_target = "steal_t_pudge"
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel()
    local cool_duration = ability:GetLevelSpecialValueFor("cooldown_duration", level-1)
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)
    if target:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        if caster:IsIllusion() == false and ability:IsCooldownReady() then
            if target:HasModifier( modifierName_target ) then
                local current_stack = target:GetModifierStackCount( modifierName_target, ability )
                ability:ApplyDataDrivenModifier( caster, target, modifierName_target, {} )
                target:SetModifierStackCount( modifierName_target, ability, current_stack + 1 )
            else
                ability:ApplyDataDrivenModifier( caster, target, modifierName_target, {})
                target:SetModifierStackCount( modifierName_target, ability, 1)
            end
            if caster:HasModifier( modifierName_caster ) then
                local current_stack = caster:GetModifierStackCount( modifierName_caster, ability )
                ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster, {duration = duration} )
                caster:SetModifierStackCount( modifierName_caster, ability, current_stack + 1 )
            else
                ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster, {duration = duration})
                caster:SetModifierStackCount( modifierName_caster, ability, 1)
            end
            if caster:HasModifier( modifierName_caster_display ) then
                local current_stack = caster:GetModifierStackCount( modifierName_caster_display, ability )
                ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster_display, {duration = duration} )
                caster:SetModifierStackCount( modifierName_caster_display, ability, current_stack + 1 )
            else
                ability:ApplyDataDrivenModifier( caster, caster, modifierName_caster_display, {duration = duration})
                caster:SetModifierStackCount( modifierName_caster_display, ability, 1)
            end
            ability:StartCooldown(cool_duration)
            PudgeReduceStack(keys)
        end
    end
end

function PudgeReduceStack(keys)
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local modifierName_caster_display = "steal_display_pudge"
    local duration = ability:GetLevelSpecialValueFor("duration", level-1)
    Timers:CreateTimer(duration,function()
        local current_stack = caster:GetModifierStackCount( modifierName_caster_display, ability )
        caster:SetModifierStackCount( modifierName_caster_display, ability, current_stack - 1 )
    end)
end

function boss_invoke_golem_destroy_skill(keys)
    local caster = keys.caster
    local ability = keys.ability
    caster:RemoveAbility(ability:GetName())
end

function golem_clean(keys)
    for _,unit in pairs ( Entities:FindAllByName( "npc_dota_boss31")) do
        unit:ForceKill(true)
    end
end



--[[
    Mystic flare Author: kritth
    Date: 09.01.2015.
    Deal constant interval damage shared in the radius
]]
function mystic_flare_start( keys )
    -- Variables
    local ability = keys.ability
    local caster = keys.caster
    local current_instance = 0
    local dummyModifierName = "modifier_mystic_flare_dummy_vfx_datadriven"
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local interval = ability:GetLevelSpecialValueFor( "damage_interval", ability:GetLevel() - 1 )
    local max_instances = math.floor( duration / interval )
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local target = keys.target_points[1]
    local total_damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
    local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_HERO
    local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
    local damageType = ability:GetAbilityDamageType() -- DAMAGE_TYPE_MAGICAL
    local soundTarget = "Hero_SkywrathMage.MysticFlare.Target"
    
    -- Create for VFX particles on ground
    local dummy = CreateUnitByName( "npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
    ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
    
    -- Referencing total damage done per interval
    local damage_per_interval = total_damage / max_instances
    
    -- Deal damage per interval equally
    Timers:CreateTimer( function()
            local units = FindUnitsInRadius(caster:GetTeam(),
                              target,
                              caster,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
            if #units > 0 then
                local damage_per_hero = damage_per_interval
                for k, v in pairs( units ) do
                    -- Apply damage
                    local damageTable = {
                                victim = v,
                                attacker = caster,
                                damage = damage_per_hero,
                                damage_type = DAMAGE_TYPE_MAGICAL
                            }
                    if HasCustomScepter(caster) then
                        damageTable = {
                        victim = v,
                        attacker = caster,
                        damage = damage_per_hero,
                        damage_type = DAMAGE_TYPE_PURE
                        }
                    end
                    ApplyDamage(damageTable)
                    
                    -- Fire sound
                    StartSoundEvent( soundTarget, v )
                end
            end
            
            current_instance = current_instance + 1
            
            -- Check if maximum instances reached
            if current_instance >= max_instances then
                dummy:Destroy()
                return nil
            else
                return interval
            end
        end
    )
end


function concussive_shot_seek_target( keys )
    -- Variables
    local caster = keys.caster
    local ability = keys.ability
    local particle_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"
    local radius = ability:GetLevelSpecialValueFor( "launch_radius", ability:GetLevel() - 1 )
    local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
    local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_HERO
    local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
    
    -- pick up x nearest target heroes and create tracking projectile targeting the number of targets
    local units = FindUnitsInRadius(caster:GetTeam(),
                              caster:GetAbsOrigin(),
                              caster,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_CLOSEST, 
                              false
    )
    
    -- Seek out target
    for k, v in pairs( units ) do
        local projTable = {
            EffectName = particle_name,
            Ability = ability,
            Target = v,
            Source = caster,
            bDodgeable = true,
            bProvidesVision = true,
            vSpawnOrigin = caster:GetAbsOrigin(),
            iMoveSpeed = speed,
            iVisionRadius = radius,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
        }
        ProjectileManager:CreateTrackingProjectile( projTable )
        break
    end
end

--[[
    Author: kritth
    Date: 8.1.2015.
    Give post attack vision
]]
function concussive_shot_post_vision( keys )
    local target = keys.target:GetAbsOrigin()
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor( "launch_radius", ability:GetLevel() - 1 )
    local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )

    -- Create node
    ability:CreateVisibilityNode( target, radius, duration )
end


--[[Kill wolves on resummon
    Author: Noya
    Date: 20.01.2015.]]

function KillWolves( event )
    local caster = event.caster
    local targets = caster.wolves or {}
    for _,unit in pairs(targets) do 
        if unit and IsValidEntity(unit) then
            unit:ForceKill(true)
            end
        end
    -- Reset table
    caster.wolves = {}
end

--[[
    Author: Noya
    Date: 20.01.2015.
    Gets the summoning forward direction for the new units
]]

function GetSummonPoints( event )

    local caster = event.caster
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
    local distance = event.distance
-- Gets 2 points facing a distance away from the caster origin and separated from each other at 30 degrees left and right
    ang_right = QAngle(0, -30, 0)
    ang_left = QAngle(0, 30, 0)
local front_position = origin + fv * distance
    point_left = RotatePosition(origin, ang_left, front_position)
    point_right = RotatePosition(origin, ang_right, front_position)
local result = { }
    table.insert(result, point_right)
    table.insert(result, point_left)
return result
end

-- Set the units looking at the same point of the caster
function SetUnitsMoveForward( event )
    local caster = event.caster
    local target = event.target
    local fv = caster:GetForwardVector()
    local origin = caster:GetAbsOrigin()
target:SetForwardVector(fv)
-- Add the target to a table on the caster handle, to find them later
table.insert(caster.wolves, target)
end


--[[
    Author: kritth
    Date: 10.01.2015.
    Init the table
]]
function spiked_carapace_init( keys )
    keys.caster.carapaced_units = {}
end

--[[
    Author: kritth
    Date: 10.01.2015.
    Reflect damage
]]
function spiked_carapace_reflect( keys )
    -- Variables
    local caster = keys.caster
    local attacker = keys.attacker
    local damageTaken = keys.DamageTaken
    local ability = keys.ability
    local damage_multiplier = ability:GetLevelSpecialValueFor( "damage_multplier", 0) * 0.01
    
    -- Check if it's not already been hit
    local damageTable = {
                            victim = attacker,
                            attacker = caster,
                            damage = damageTaken*damage_multiplier,
                            damage_type = DAMAGE_TYPE_PURE
                        }
     if not caster.carapaced_units[ attacker:entindex() ] then
      keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_spiked_carapaced_stun_datadriven", { } )
      caster.carapaced_units[ attacker:entindex() ] = attacker
      ApplyDamage(damageTable)
    end

end

-- Stops the sound from playing
function StopSound( keys )
    local target = keys.target
    local sound = keys.sound

    StopSoundEvent(sound, target)
end