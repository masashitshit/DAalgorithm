module MyMatching 

function matching3(prop_prefs,resp_prefs,caps)
    
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
    
end 

export matching3

end
