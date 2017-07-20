module MyMatching 

function matching(prop_prefs,resp_prefs,reverse)
    
    if reverse == false
    
        m_prefs = prop_prefs
        f_prefs = resp_prefs
        mm = length(m_prefs)
        nn = length(f_prefs)
    
        for o in 1:mm
            push!(m_prefs[o],0)
        end
    
        for k in 1:nn
            push!(f_prefs[k],0)
        end
    
    
        matched_m = zeros(Int64,mm)
        matched_f = zeros(Int64,nn)
        accepted_m = zeros(Int64,mm)
        order = ones(Int64,mm)
    
        while sum(accepted_m) < mm          #男性全員がマッチするまで
        
            for i in 1:mm
            
                if accepted_m[i] == 1     #男性iがマッチ済み
                
                else　　　#男性iがマッチ済みでない
            
                    if m_prefs[i][order[i]] == 0       #男性が独身を希望
                
                        accepted_m[i] = 1
                
                    else　　　　#男性が女性を希望
                
                        if findfirst(f_prefs[m_prefs[i][order[i]]],i) == 0      #男性の希望する女性の選択肢の中に男性がいない
                    
                            order[i] +=1           #男性の志望順位を一つ下げる
                    
                        else　　　　　　#男性が女性の評価対象
                    
                            if matched_f[m_prefs[i][order[i]]] == 0       #男性の希望する女性のもとに誰もいないとき
                        
                                matched_m[i] = m_prefs[i][order[i]]
                                matched_f[m_prefs[i][order[i]]] = i
                                accepted_m[i] = 1
                        
                            else　　　　　　　　　#女性が別の男性とマッチ済み
                        
                                if findfirst(f_prefs[m_prefs[i][order[i]]],i) < findfirst(f_prefs[m_prefs[i][order[i]]],matched_f[m_prefs[i][order[i]]])
                            
                                    order[matched_f[m_prefs[i][order[i]]]] +=1         #取って代わられた男性の志望順位を一つ下げる
                                    accepted_m[i] = 1
                                    matched_m[matched_f[m_prefs[i][order[i]]]] = 0
                                    accepted_m[matched_f[m_prefs[i][order[i]]]] = 0
                                    matched_m[i] = m_prefs[i][order[i]]
                                    matched_f[m_prefs[i][order[i]]] = i
                            
                                else　　　　　#マッチ済みの男性のほうがいい
                            
                                    order[i] +=1
                            
                                end
                            
                            end
                            
                        end
                            
                    end
                
                end
                            
            end
                            
        end
                            
        return matched_m, matched_f
                            
    elseif reverse == true
        
        m_prefs = prop_prefs
        f_prefs = resp_prefs
        mm = length(m_prefs)
        nn = length(f_prefs)
    
        for o in 1:mm
            push!(m_prefs[o],0)
        end
    
        for k in 1:nn
            push!(f_prefs[k],0)
        end
    
    
        matched_m = zeros(Int64,mm)
        matched_f = zeros(Int64,nn)
        accepted_f = zeros(Int64,nn)
        order = ones(Int64,nn)
    
        while sum(accepted_f) < nn          #女性全員がマッチするまで
        
            for i in 1:nn
            
                if accepted_f[i] == 1     #女性iがマッチ済み
                
                else　　　#女性iがマッチ済みでない
            
                    if f_prefs[i][order[i]] == 0       #女性iが独身を希望
                
                        accepted_f[i] = 1
                
                    else　　　　#女性が男性を希望
                
                        if findfirst(m_prefs[f_prefs[i][order[i]]],i) == 0      #男性の希望する女性の選択肢の中に男性がいない
                    
                            order[i] +=1           #男性の志望順位を一つ下げる
                    
                        else　　　　　　#男性が女性の評価対象
                    
                            if matched_m[f_prefs[i][order[i]]] == 0       #男性の希望する女性のもとに誰もいないとき
                        
                                matched_f[i] = f_prefs[i][order[i]]
                                matched_m[f_prefs[i][order[i]]] = i
                                accepted_f[i] = 1
                        
                            else　　　　　　　　　#女性が別の男性とマッチ済み
                        
                                if findfirst(m_prefs[f_prefs[i][order[i]]],i) < findfirst(m_prefs[f_prefs[i][order[i]]],matched_m[f_prefs[i][order[i]]])
                            
                                    order[matched_m[f_prefs[i][order[i]]]] +=1         #取って代わられた男性の志望順位を一つ下げる
                                    accepted_f[i] = 1
                                    matched_f[matched_m[f_prefs[i][order[i]]]] = 0
                                    accepted_f[matched_m[f_prefs[i][order[i]]]] = 0
                                    matched_f[i] = f_prefs[i][order[i]]
                                    matched_m[f_prefs[i][order[i]]] = i
                            
                                else　　　　　#マッチ済みの男性のほうがいい
                            
                                    order[i] +=1
                            
                                end
                            
                            end
                            
                        end
                            
                    end
                
                end
                            
            end
                            
        end
                            
        return matched_m, matched_f
                            
    end
    
end


function matching(prop_prefs,resp_prefs,caps,reverse)
    
    if reverse == false           #学生　→　大学
    
        mm = length(prop_prefs)
        nn = length(resp_prefs)
        for o in 1:mm
            push!(prop_prefs[o],0)
        end

    #resp_prefsに0を入れる必要はなかった
    
        indptr = Array{Int}(nn+1)
        indptr[1] = 1
        for k in 1:nn  
            indptr[k+1] = indptr[k] + caps[k]
        end
        #indptrを関数内に内蔵！
    
        prop_matched = zeros(Int64,mm)
        resp_matched = zeros(Int64,sum(caps))
        prop_accepted = zeros(Int64,mm)
        order = ones(Int64,mm)
    
        while sum(prop_accepted) < mm       #学生全員がマッチするまで
        
            for i in 1:mm
            
                if prop_accepted[i] == 1    #学生iがマッチ済み
         
                else
                
                    if prop_prefs[i][order[i]] == 0   #学生iの第一志望が浪人
                    
                        prop_accepted[i] = 1
                    
                    else

                        if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) == 0  #学生iが志望する大学の選択肢の中に学生iがいない
                        
                            order[i] +=1    #学生iの志望順位を一つ下げる
                        
                        else

                            if findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],0) !== 0
                               #学生iが志望する大学の受け入れ枠に空きがあるとき(0が受け入れ枠にある)
                            
                                z = findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],0)
                                #0が左から何番目にあるか
                            
                                resp_matched[indptr[prop_prefs[i][order[i]]]+z-1] = i     #0...0にiを左詰めで入れる
                                prop_matched[i] = prop_prefs[i][order[i]]
                                prop_accepted[i] = 1
                            
                            
                            else
                            
                                passed = resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1]
                                #受け入れ保留されている学生たちのarray
                            
                                ranking = [findfirst(resp_prefs[prop_prefs[i][order[i]]],passed[p]) for p in 1:length(passed)]
                                #彼らのランキング
                            
                                worst = resp_prefs[prop_prefs[i][order[i]]][maximum(ranking)]
                                #保留されている中で最もランキングの低い学生の”名前”
                            
                                if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) > maximum(ranking)
                                   #最下位の人よりも低い
                                
                                    order[i] += 1
                                
                                else
                                
                                    ww = findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],worst)
                                    #最下位の人が何番目にいるのか
                                
                                    prop_accepted[worst] = 0
                                    prop_accepted[i] = 1
                                    prop_matched[worst] = 0
                                    prop_matched[i] = prop_prefs[i][order[i]]
                                    order[worst] += 1
                                    resp_matched[indptr[prop_prefs[i][order[i]]]+ww-1] = i
                                    
                                
                                end
                            
                            end
                        
                        end
                    
                    end
                
                end
            
            end
        
        end
                                
        return prop_matched, resp_matched, indptr
    
    elseif reverse == true            #大学　→　学生
        
        mm = length(prop_prefs)
        nn = length(resp_prefs)
        for o in 1:nn
            push!(resp_prefs[o],0)
        end

        #今回はprop_prefsに0を入れる必要がない
    
        indptr = Array{Int}(nn+1)
        indptr[1] = 1
        for k in 1:nn  
            indptr[k+1] = indptr[k] + caps[k]
        end
        #indptrを関数内に内蔵！
    
        prop_matched = zeros(Int64,mm)
        resp_matched = zeros(Int64,sum(caps))
        resp_accepted = zeros(Int64,nn)
        order = ones(Int64,nn)
    
        while sum(resp_accepted) < nn       #学生全員がマッチするまで
        
            for i in 1:nn
            
                if resp_accepted[i] == 1    #学生iがマッチ済み
         
                else
                
                    if resp_prefs[i][order[i]] == 0   #大学iの第一志望がいないとき
                    
                        resp_accepted[i] = 1  
                    
                    else

                        if prop_matched[resp_prefs[i][order[i]]] == 0      #希望の学生が空いているとき
                        
                            prop_matched[resp_prefs[i][order[i]]] = i
                            vacant = findfirst(resp_matched[indptr[i]:indptr[i+1]-1],0)   #大学の空いている番号
                            resp_matched[indptr[i]+vacant-1] = resp_prefs[i][order[i]]
                        
                            if findfirst(resp_matched[indptr[i]:indptr[i+1]-1],0) == 0  #大学の定員が埋まったとき
                            
                                resp_accepted[i] = 1
                            
                            else
                            
                                order[i] += 1
                             
                            end
                        
                        else

                            rival = prop_matched[resp_prefs[i][order[i]]]     #希望の学生がすでにマッチング済みの時の相手
                        
                            if findfirst(prop_prefs[resp_prefs[i][order[i]]],rival) < findfirst(prop_prefs[resp_prefs[i][order[i]]],i)
                                #大学iはライバル大学よりも学生に好まれていないとき
                            
                                order[i] += 1
                            
                            else
                                #大学iがライバル大学よりも人気だったとき
                                losestu = findfirst(resp_matched[indptr[rival]:indptr[rival+1]-1],resp_prefs[i][order[i]])
                                #ライバルの定員のどこに学生が位置していたか
                                resp_matched[indptr[rival]+losestu-1] = 0
                                vacant = findfirst(resp_matched[indptr[i]:indptr[i+1]-1],0)   #大学の空いている番号
                                resp_matched[indptr[i]+vacant-1] = resp_prefs[i][order[i]]
                                resp_accepted[rival] = 0
                            
                                if order[rival] < length(resp_prefs[rival])
                                
                                    order[rival] += 1
                                
                                end
                            
                            
                            
                                prop_matched[resp_prefs[i][order[i]]] = i    # 最後に学生のマッチング相手を置き換える
                            
                                if findfirst(resp_matched[indptr[i]:indptr[i+1]-1],0) == 0  #大学の定員が埋まったとき
                                
                                    resp_accepted[i] = 1
                                
                                else
                                
                                    order[i] += 1
                                    
                                
                                end
                            
                            end
                        
                        end
                    
                    end
                
                end
            
            end
        
        end
    
        return prop_matched, resp_matched, indptr 
    
    end
    
end

export matching

end
