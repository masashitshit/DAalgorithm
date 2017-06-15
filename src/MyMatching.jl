module MyMatching 

function matching(m_prefs,f_prefs)
    
    for o in 1:m
        push!(m_prefs[o],0)
    end

    for k in 1:n
        push!(f_prefs[k],0)
    end
    matched_m = zeros(Int64,m)
    matched_f = zeros(Int64,n)
    accepted_m = zeros(Int64,m)         #男性iの受け入れ先が決まったらaccepted_m[1]=1
    
    while sum(accepted_m) !== m       #男性が全員受け入れ先が決まるまで
        
        for i in 1:m
            
            if m_prefs[i][1] == 0       #男性iの第一志望が独身のとき
                
                accepted_m[i] = 1       #男性iは受け入れ済みに
                
            end
            
            if m_prefs[i][1] !== 0      #男性gに第一志望の女性がいるとき
                
                if findfirst(f_prefs[m_prefs[i][1]],i) == 0       #男性iが第一志望の女性の眼中にないとき
                    
                    shift!(m_prefs[i]) #男性iの志望から第一志望を除く
                    
                end
                
                if findfirst(f_prefs[m_prefs[i][1]],i) == 0      #男性gが第一志望の女性の選択肢に入っているとき
                    
                    if matched_f[m_prefs[i][1]] == 0        #第一志望の女性が誰も受け入れていないとき
                        
                        matched_m[i] = m_prefs[i][1]
                        matched_f[m_prefs[i][1]] = i
                        accepted_m[i] = 1　　　　　　　　　#男性iは受け入れ済みに
                        
                    end
                    
                    if matched_f[m_prefs[i][1]] !== 0        #第一志望の女性が誰かを受け入れているとき
                        
                        if findfirst(f_prefs[m_prefs[i][1]],i) < findfirst(f_prefs[m_prefs[i][1]],matched_f[m_prefs[i][1]])
                                 #男性iが保留されていた男性よりも女性の好ましい選択であるとき
                            
                                accepted_m[matched_f[m_prefs[i][1]]] = 0      #保留されていた男性を受け入れ済みから除く
                                shift!(m_prefs[matched_f[m_prefs[i][1]]]) 　　#保留されていた男性の志望から第一志望を除く
                                matched_m[matched_f[m_prefs[i][1]]] =　0 
                            
                                matched_m[i] = m_prefs[i][1]
                                matched_f[m_prefs[i][1]] = i
                                accepted_m[i] = 1               #男性iは受け入れ済みに
                            
                        end
                         
                        if findfirst(f_prefs[m_prefs[i][1]],i) > findfirst(f_prefs[m_prefs[i][1]],matched_f[m_prefs[i][1]]) 
                                #保留されていた男性が男性iよりも女性の好ましい選択であるとき
                                
                                shift!(m_prefs[i])       #男性iの志望から第一志望を除く
                                
                        end
                            
                    end
                        
                end
                    
             end
                
        end
            
    end
        
    return matched_m,matched_f
        
end

export matching

end
                                
                                
                                
                    
                    
                        
                    
                        
