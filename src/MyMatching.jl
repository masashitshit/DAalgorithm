module MyMatching 

function matching3(prop_prefs,resp_prefs)
    
    
    mm = length(prop_prefs)
    nn = length(resp_prefs)
    
    for o in 1:mm
        push!(prop_prefs[o],0)
    end
    

    
    
    prop_matched = zeros(Int64,mm)
    resp_matched = zeros(Int64,nn)
    prop_accepted = zeros(Int64,mm)
    order = ones(Int64,mm)
    
    while sum(prop_accepted) < mm          #男性全員がマッチするまで
        
        for i in 1:mm
            
            if prop_accepted[i] == 1     #男性iがマッチ済み
                
            else　　　#男性iがマッチ済みでない
            
                if prop_prefs[i][order[i]] == 0       #男性が独身を希望
                #30
                    prop_accepted[i] = 1
                
                else　　　　#男性が女性を希望
                
                    if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) == 0      #男性の希望する女性の選択肢の中に男性がいない
                    
                        order[i] +=1           #男性の志望順位を一つ下げる
                    
                    else　　　　　　#男性が女性の評価対象
                   #40 
                        if resp_matched[prop_prefs[i][order[i]]] == 0       #男性の希望する女性のもとに誰もいないとき
                        
                            prop_matched[i] = prop_prefs[i][order[i]]
                            resp_matched[prop_prefs[i][order[i]]] = i
                            prop_accepted[i] = 1
                        
                        else　　　　　　　　　#女性が別の男性とマッチ済み
                        
                            if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) < findfirst(resp_prefs[prop_prefs[i][order[i]]],resp_matched[prop_prefs[i][order[i]]])
                      #50      
                                order[resp_matched[prop_prefs[i][order[i]]]] +=1         #取って代わられた男性の志望順位を一つ下げる
                                prop_accepted[i] = 1
                                prop_matched[resp_matched[prop_prefs[i][order[i]]]] = 0
                                prop_accepted[resp_matched[prop_prefs[i][order[i]]]] = 0
                                prop_accepted[i] = prop_prefs[i][order[i]]
                                resp_matched[prop_prefs[i][order[i]]] = i
                            
                            else　　　　　#マッチ済みの男性のほうがいい
                            
                                order[i] +=1
                            
                            end
                            
                        end
                            
                    end
                            
                end
                
            end
                            
        end
                            
    end
                            
    return prop_matched, resp_matched
                            
end

function matching3(prop_prefs,resp_prefs,caps)
    #81
    mm = length(prop_prefs)
    nn = length(resp_prefs)
    for o in 1:mm
        push!(prop_prefs[o],0)
    end

    #resp_prefsに0を入れる必要はなかった
    
    
    #90
    prop_matched = zeros(Int64,mm)
    resp_matched = zeros(Int64,sum(caps))
    prop_accepted = zeros(Int64,mm)
    order = ones(Int64,mm)
    
    while sum(prop_accepted) < mm          #学生全員がマッチするまで
        
        for i in 1:mm
            
            if prop_accepted[i] == 1     #学生iがマッチ済み
       #101         
            else
                
                if prop_prefs[i][order[i]] == 0      #学生iの第一志望が浪人
                    
                    prop_accepted[i] = 1
                    
                else
                    #109
                    if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) == 0      #学生iが志望する大学の選択肢の中に学生iがいない
                        
                        order[i] +=1             #学生iの志望順位を一つ下げる
                        
                    else
                        #115
                        if findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],0) !== 0
                            #学生iが志望する大学の受け入れ枠に空きがあるとき(0が受け入れ枠にある)
                            
                            z = findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],0)
                            #0が左から何番目にあるか
                            resp_matched[indptr[prop_prefs[i][order[i]]]+z-1] = i  #0...0にiを左詰めで入れる
                            prop_matched[i] = prop_prefs[i][order[i]]
                            prop_accepted[i] = 1
                            #45
                            #大学の志望度が一番低い学生を右端に置く
                            
                            zz = findfirst(resp_matched[indptr[prop_prefs[i][order[i]]]:indptr[prop_prefs[i][order[i]]+1]-1],i)
                            #iが何番目に入れられたか
                            if zz == 1
                                
                            else
                                
                                right = findfirst(resp_prefs[prop_prefs[i][order[i]]],i)
                                left = findfirst(resp_prefs[prop_prefs[i][order[i]]],resp_matched[indptr[prop_prefs[i][order[i]]]+zz-2])
                                
                                if right < left
                                
                                    resp_matched[indptr[prop_prefs[i][order[i]]]+zz-1] = resp_matched[indptr[prop_prefs[i][order[i]]]+zz-2]
                                    resp_matched[indptr[prop_prefs[i][order[i]]]+zz-2] = i
                                    
                                else
                                    
                                end
                                
                            end
                            
                        else
                            
                            if findfirst(resp_prefs[prop_prefs[i][order[i]]],i) > findfirst(resp_prefs[prop_prefs[i][order[i]]],resp_matched[indptr[[prop_prefs[i][order[i]]+1]-1]])
                                
                                order[i] += 1
                                
                            else
                                
                                prop_accepted[resp_matched[indptr[[prop_prefs[i][order[i]]+1]-1]]] = 0
                                prop_accepted[i] = 1
                                prop_matched[resp_matched[indptr[[prop_prefs[i][order[i]]+1]-1]]] = 0
                                prop_matched[i] = prop_prefs[i][order[i]]
                                order[resp_matched[indptr[[prop_prefs[i][order[i]]+1]-1]]] += 1
                                resp_matched[indptr[[prop_prefs[i][order[i]]+1]-1]] = i
                                
                            end
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
                                
    return prop_matched, resp_matched
    
end                                         

export matching3

end
