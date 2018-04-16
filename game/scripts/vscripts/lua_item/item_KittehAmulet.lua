item_KittehAmulet = class({})
LinkLuaModifier( "modifier_item_kitteh_amulet_passive", "lua_item/item_KittehAmulet.lua" ,LUA_MODIFIER_MOTION_NONE )

function item_kitteh_amulet:OnSpellStart()
	local caster = self:GetCaster()
	local targetPos = self:GetCursorPosition()
	local ogPos = caster:GetAbsOrigin()
	
	local distance = CalculateDistance( targetPos, caster )
	local direction = CalculateDirection( targetPos, caster )
	if distance > 9999 then
		print( 9999 )
		targetPos = caster:GetAbsOrigin() + direction * 9999
	end
	EmitSoundOn("DOTA_Item.BlinkDagger.Activate", caster)
	ParticleManager:FireParticle("particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf", PATTACH_ABSORIGIN, caster, {[0] = caster:GetAbsOrigin()})
	FindClearSpaceForUnit(caster, targetPos, true)
	ProjectileManager:ProjectileDodge( caster )
	ParticleManager:FireParticle("particles/econ/events/ti6/blink_dagger_end_ti6_lvl2.vpcf", PATTACH_ABSORIGIN, caster, {[0] = caster:GetAbsOrigin()})
	EmitSoundOn("DOTA_Item.BlinkDagger.NailedIt", caster)
  
	caster:SetThreat( 0 )
	caster:RefreshAllCooldowns(true)
end


function item_kitteh_amulet:GetIntrinsicModifierName()
	return "modifier_item_kitteh_amulet_passive"
end

modifier_item_kitteh_amulet_passive = class({})


function modifier_item_kitteh_amulet_passive:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
			MODIFIER_PROPERTY_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_MOVESPEED_MAX,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_CAST_RANGE_BONUS,
			MODIFIER_PROPERTY_CAST_RANGE_BONUS_TARGET,
			MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

end

function modifier_item_kitteh_amulet_passive:GetModifierSpellAmplify_Percentage()
		return 1000
end

function modifier_item_kitteh_amulet_passive:GetModifierConstantManaRegen()
		return 8888
end

function modifier_item_kitteh_amulet_passive:GetModifierConstantHealthRegen()
		return 8888
end

function modifier_item_kitteh_amulet_passive:GetModifierHealthRegenPercentage()
		return 25
end

function modifier_item_kitteh_amulet_passive:GetModifierManaRegenPercentage()
		return 25
end

function modifier_item_kitteh_amulet_passive:OnTakeDamage(params)
	if params.attacker == self:GetParent() and not params.inflictor then
		local flHeal = params.damage * 100
		params.attacker:HealEvent(flHeal, self:GetAbility(), params.attacker)
	end

	if params.attacker == self:GetParent() then
		local flHeal = params.damage * 100
		if params.inflictor then ParticleManager:FireParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self) end
		params.attacker:HealEvent(flHeal, self:GetAbility(), params.attacker)
	end
end

function modifier_item_kitteh_amulet_passive:GetModifierMoveSpeed_AbsoluteMin()
	return 550
end

function modifier_item_kitteh_amulet_passive:GetModifierMoveSpeed_Limit()
	return 5000
end

function modifier_item_kitteh_amulet_passive:GetModifierMoveSpeedBonus_Special_Boots()
	return 550
end

function modifier_item_kitteh_amulet_passive:GetModifierMoveSpeed_Max()
	return 5000
end

function modifier_item_kitteh_amulet_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and RollPercentage(95) then
			self:GetAbility():DealDamage(self:GetParent(), params.target, 100, {damage_type = DAMAGE_TYPE_PURE})

		end
	end


	if IsServer() then
		if not params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			local parent = self:GetParent()
			parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 17)
			self:GetAbility():SetCooldown()
			Timers:CreateTimer(0.1, function() parent:PerformGenericAttack(params.target, true) end)
		end
	end

	if IsServer() then
		if params.attacker == self:GetParent() then
			for _, enemy in ipairs( self:GetParent():FindEnemyUnitsInRadius( params.target:GetAbsOrigin(), 550) ) do
				if enemy ~= params.target then
					self:GetAbility():DealDamage( self:GetParent(), enemy, params.original_damage * 1, {damage_type = DAMAGE_TYPE_PHYSICAL})
				end
			end
		end
	end


	if IsServer() then
		if params.attacker == self:GetParent() and RollPercentage(50) then
			params.target:DisableHealing(8)
		end
	end

end


function modifier_item_kitteh_amulet_passive:GetModifierAttackRangeBonusUnique()
		return 8000
end


function modifier_item_kitteh_amulet_passive:GetModifierPercentageCooldownStacking()
	return 95
end

function modifier_item_kitteh_amulet_passive:GetModifierTotal_ConstantBlock()
	if RollPercentage(100) then
		return 500
end


function modifier_item_kitteh_amulet_passive:GetModifierAttackRangeBonus()
	return 8000
end

function modifier_item_kitteh_amulet_passive:GetModifierPreAttack_CriticalStrike()
	if RollPercentage(95) then
		return 500
end

function modifier_item_kitteh_amulet_passive:GetModifierHealthBonus()
	return self:GetParent():GetStrength() * 50
end

function modifier_item_kitteh_amulet_passive:GetModifierBaseDamageOutgoing_Percentage()
	return 100
end

function modifier_item_kitteh_amulet_passive:GetModifierBonusStats_Intellect()
	return 88888
end

function modifier_item_kitteh_amulet_passive:GetModifierBonusStats_Strength()
	return 88888
end

function modifier_item_kitteh_amulet_passive:GetModifierBonusStats_Agility()
	return 88888
end

function modifier_item_kitteh_amulet_passive:GetModifierCastRangeBonus()
	return 8000
end


function modifier_item_kitteh_amulet_passive:GetModifierCastRangeBonusTarget()
	return 8000
end


function modifier_item_kitteh_amulet_passive:GetModifierCastRangeBonusStacking()
	return 8000
end

function modifier_item_kitteh_amulet_passive:GetModifierMoveSpeedBonus_Percentage()
	return 100
end

function modifier_item_kitteh_amulet_passive:IsHidden()
	return true
end


function modifier_item_kitteh_amulet_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
