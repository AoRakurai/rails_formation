module BuildsHelper
    def champion_select
        champions = champions_data
        content_tag(:select, id:"champion_select", :onchange => 'champion_select_changed()') do
            options = []
            for champion in champions do
                champion = champions[champion[0]]
                options << [champion["name"], champion["id"]]
            end
            concat(options_for_select(options))
        end
    end

    def item_select(id)
        items = items_data
        content_tag(:select, id:"item_select_#{id}", :onchange => "item_select_changed(#{id})") do
            options = []
            for item in items do      
                id = item[0]          
                item = items[item[0]]       
                options << [item["name"],id]
            end
            concat(options_for_select(options))
        end
    end

    def item_table(items)
        content_tag(:table) do
            i = 0
            row_items = []
            for item_data in items do
                item_data.each do |key,item|    
                    row_items << item
                end
                if(row_items.length >= 3)
                    concat(item_table_row(row_items,i))
                    row_items.clear
                    i+=3
                end
            end
        end
    end

    def item_table_row(items,i)
        content_tag(:tr) do
            for item in items do                  
                concat(item_table_element(item,i))
                i+=1
            end
        end
    end

    def item_table_element(item,i)
        content_tag(:td) do
            concat(content_tag(:p,item["name"]))
            concat(image_tag("item/#{item["image"]["full"]}", id:"item_image_#{i}"))
        end
    end

    def item_icon(item)
        return "item/" + items_data[item]["image"]["full"]
    end

    def champion_icon(champion)
        return "champion/" + champions_data[champion]["image"]["full"]
    end

    def champions_data
        source = "app/assets/json/championFull.json"
        data = File.read(source)
        result = JSON.parse(data)["data"]
        return result
    end

    def champion_data(champion)
        source = "app/assets/json/champion/#{champion}.json"
        data = File.read(source)
        result = JSON.parse(data)["data"][champion]
        return result
    end

    def items_data
        source = "app/assets/json/item.json"
        data = File.read(source)
        result = JSON.parse(data)["data"]
        return result
    end

    def item_select_changed
        content_tag(:script, "")
    end

    def submit_build
        button_tag("submit",onclick:'submit()')
    end    

    def champion_stats_table(stats,items)
        stats["abilitypower"] = 0
        normal_stats = [
            "hp","mp",
            "armor","spellblock",
            "hpregen","mpregen",
            "crit","attackdamage"
        ]
        unique_stats = [
            "movespeed",
            "attackrange",
            "abilitypower"       
        ]
        stats = stats_total(stats,items)
        content_tag(:table) do
            for stat in normal_stats do
                stat_info = "#{stats[stat]} + #{stats["#{stat}perlevel"]}"
                concat(champion_stats_table_row(stat,stat_info))
            end
            for stat in unique_stats do
                stat_info = "#{stats[stat]}"
                concat(champion_stats_table_row(stat,stat_info))
            end
            concat(champion_stats_table_row("attackspeed","#{stats["attackspeedoffset"]} + #{stats["#attackspeedperlevel"]}"))
        end
    end

    def champion_stats_table_row(stat_name,stat)
        content_tag(:tr) do
            concat(content_tag(:td,stat_name))
            concat(content_tag(:td,stat))
        end
    end

    def stats_total(champion_stats,items)
        key_pairs = [
            ["HPPoolMod","hp"],
            ["MPPoolMod","mp"],
            ["ArmorMod","armor"],
            ["SpellBlockMod","spellblock"],
            ["HPRegenMod","hpregen"],
            ["MPRegenMod","mpregen"],
            ["CritChanceMod","crit"],
            ["PhysicalDamageMod","attackdamage"],
            ["MovementSpeedMod","movespeed"],
            ["MagicDamageMod","abilitypower"],
            ["AttackSpeedMod","attackspeedoffset"]
        ]
        for item_data in items do
            item_data.each do |key,item|    
                for key_pair in key_pairs do
                    if(item["stats"]["Flat#{key_pair[0]}"]) then
                        champion_stats[key_pair[1]] += item["stats"]["Flat#{key_pair[0]}"]
                    end
                end
            end
        end
        return champion_stats
    end
end