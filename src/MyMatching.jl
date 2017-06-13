module MyMatching 

function matching(m_prefs,f_prefs)

    Z = zeros(m,n) 
    matched_m = zeros(Any,m) 
    matched_f = zeros(Any,n)
    
    
    for i in 1:m        #男性m人について
     
        if m_prefs[i][1] == 0.0　　#男性iが独身を第一志望するとき
            
            matched_m[i] = 0.0                    
        end
            
        if m_prefs[i][1] !== 0.0  #男性iが第一志望する女性がいるとき

                    
            if sum(Z[:,m_prefs[i][1]]) == 0.0　#男性iが第一志望する女性の列に誰もいないとき
                
                matched_m[i] = m_prefs[i][1]
                matched_f[m_prefs[i][1]] = i
                Z[i,m_prefs[i][1]] = 1.0   
            end
                
            if sum(Z[:,m_prefs[i][1]]) == 1.0 #男性iが第一志望する女性の列に誰かいるとき
                    
                if findfirst(f_prefs[m_prefs[i][1]],i) < findfirst(f_prefs[m_prefs[i][1]],size(Z[:,m_prefs[i][1]],1.0))
                #男性iが受け入れ保留されていた男性よりも女性に好まれているとき
                        
                    matched_m[i] = m_prefs[i][1]
                    matched_f[m_prefs[i][1]] = i
                    Z[i,m_prefs[i][1]] = 1.0
                    Z[size(Z[:,m_prefs[i][1]],1.0),m_prefs[i][1]] = 0.0
                    shift!(m_prefs[size(Z[:,m_prefs[i][1]],1.0)]) #受け入れ保留されていた男性の志望から第一志望を除く
                    
                end                    
                
                else #受け入れ保留されていた男性のほうが女性に好まれているとき
                    
                    shift!(m_prefs[i]) #男性iの志望から第一志望を除く
                    
                end
                
            end
        
    end

    return matched_m, matched_f

end


end
