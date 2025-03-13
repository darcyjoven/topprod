# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_gr_grw_f.4gl
# Descriptions...: Genero Report 複製報表相關資訊
# Date & Author..: 12/03/01 JanetHuang 
# Modify.........: No.FUN-C30005 12/03/01 By janet  Genero Report 複製報表相關資訊
# Modify.........: No.FUN-C30290 12/03/29 By janet  從s_gr_grw傳過來的gdw_file複製
# Modify.........: No.TQC-C60041 12/06/05 By janet  修改s_gr_gdwcopy_gdw08裡gdw09直接存傳過來的gdw09_new
# Modify.........: No.FUN-C60012 12/06/06 By janet  修改抓最大序號gdw07來存相同自定義樣板
# Modify.........: No.FUN-C90038 12/10/09 By janet 修改來源4rp目錄權限，改成511
# Modify.........: No.FUN-D20068 13/02/20 By janet 複製4rp檔案時，以gay_file內的語系為主
# Modify.........: No.FUN-D20087 13/02/26 By odyliao 增加複製樣板說明(gfs_file)

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"


#FUN-C30290 MARK----START
#FUNCTION s_gr_gdwcopy(g_prog_old,g_prog_new,g_simtab,g_cust)
     #DEFINE  g_prog_old LIKE  gdw_file.gdw01 #來源檔名
     #DEFINE  g_prog_new LIKE  gdw_file.gdw01 #目的檔名
     #DEFINE  g_simtab   LIKE  gdw_file.gdw02  #樣板id
     #DEFINE  g_cust     LIKE  gdw_file.gdw03  #客製否
     #DEFINE  g_gdw08    LIKE  gdw_file.gdw08     
     #DEFINE  l_cnt                 LIKE type_file.num10    #每次計算筆數 
     #DEFINE  l_old_cnt             LIKE type_file.num10    #來源筆數 
#
    # DEFINE  l_gdw01       LIKE gdw_file.gdw01     #程式名稱
     #DEFINE  l_gdw02       LIKE gdw_file.gdw02     #報表樣版
     #DEFINE  l_gdw03       LIKE gdw_file.gdw03     #客製否
     #DEFINE  l_gdw05       LIKE gdw_file.gdw05     #使用者
     #DEFINE  l_gdw04       LIKE gdw_file.gdw04     #權限
     #DEFINE  l_gdw06       LIKE gdw_file.gdw06     #行業別
     #DEFINE  l_gdw08       LIKE gdw_file.gdw08     #樣版ID
    # DEFINE  l_name        STRING 
     #DEFINE  i             INTEGER
#
     #DEFINE  g_gdw_o  DYNAMIC ARRAY OF RECORD 
           #gdw07           LIKE gdw_file.gdw07,    # 序號
           #gdw09           LIKE gdw_file.gdw09,    # 樣板名稱(4rp)
           #gdw10           LIKE gdw_file.gdw10,    # 樣板說明
           #gdw11           LIKE gdw_file.gdw11,    # 標籤列印否
           #gdw12           LIKE gdw_file.gdw12,    # 標籤X
           #gdw13           LIKE gdw_file.gdw13,    # 標籤Y
           #gdwdate         LIKE gdw_file.gdwdate,  # 最近修改日(上傳日期)
           #gdwgrup         LIKE gdw_file.gdwgrup,  # 資料所有部門
           #gdwmodu         LIKE gdw_file.gdwmodu,  # 資料修改者
           #gdwuser         LIKE gdw_file.gdwuser,  # 資料所有者
           #gdworig         LIKE gdw_file.gdworig,  # 資料修改者
           #gdworiu         LIKE gdw_file.gdworiu,   # 資料所有者 
           #gdw14           LIKE gdw_file.gdw14,    # 列印簽核
           #gdw15           LIKE gdw_file.gdw15    # 列印簽核位置           
        #END RECORD     
     #DEFINE l_sql,l_gdw09_str          STRING 
     #DEFINE l_gdw08_r,l_gdw_08_tmp     STRING 
     #DEFINE l_gdw02_n       LIKE gdw_file.gdw02
#
     #
     #LET g_prog_old=g_prog_old
     #LET g_prog_new=g_prog_new    
     #LET l_gdw02=g_simtab
     #LET l_gdw02_n=cl_replace_str( l_gdw02, g_prog_old, g_prog_new)
     #LET l_gdw03="Y"# g_cust
     #原始
     #LET l_gdw04=g_clas
     #LET l_gdw05=g_user
      #測試
     #LET l_gdw04='default'
     #LET l_gdw05='default' 
     #測試
     #LET l_gdw06=g_sma.sma124
    # LET l_gdw08=g_gdw08  
    #
            #
      #IF l_gdw06 IS  NULL THEN 
        #LET l_gdw06="std" 
      #END IF ##若行業別是空，設為std
      ##重新計算gdw_file筆數
#
      #
      #LET l_cnt=0
#
      #SELECT COUNT(*) INTO l_cnt FROM gdw_file 
           #WHERE gdw01 = g_prog_old
             #AND gdw02 = l_gdw02
             #AND gdw03 = l_gdw03
             #AND gdw04 = l_gdw04
             #AND gdw05 = l_gdw05          
             #AND gdw06 = l_gdw06  
     #
       #IF l_cnt=0 THEN #沒有資料 顯示訊息
          #
          #CALL cl_err(g_prog_old,'axr-334',0) 
          #
       #END IF
       #LET l_old_cnt=l_cnt #將來源筆數存入
 #
        #LET l_cnt=0
        #SELECT COUNT(*) INTO l_cnt FROM gdw_file 
             #WHERE gdw01 = g_prog_new
               #AND gdw02 = l_gdw02_n
               #AND gdw03 = l_gdw03
               #AND gdw04 = l_gdw04
               #AND gdw05 = l_gdw05            
               #AND gdw06 = l_gdw06  
#
#
#
         #LET l_gdw08_r=0      
         #IF l_cnt>0 THEN #有資料 跳出訊息
            #IF  cl_confirm('agl-197')= 1 THEN #確定  覆蓋
                 #IF NOT cl_null(g_prog_new) THEN #目的程式不是空
                      #IF l_gdw04 <> 'default' OR l_gdw05 <> 'default'THEN
                         #LET l_cnt = 0
                         #SELECT COUNT(*) INTO l_cnt FROM gdw_file
                          #WHERE gdw01 = g_prog_new
                            #AND gdw02 = l_gdw02_n
                            #AND gdw03 = 'N'
                            #AND gdw04 = 'default'
                            #AND gdw05 = 'default'
                            #AND gdw06 = 'std'
                            #
                         #IF  l_cnt = 0 THEN
                             #CALL cl_err(g_prog_new,'azz-086',0)
                         #END IF 
                      #END IF                
#
                        #目的程式，有資料先刪
                        #DELETE FROM gdw_file
                        #WHERE gdw01 = g_prog_new AND gdw02 = g_prog_new
                        #AND gdw03 = l_gdw02_n AND gdw04 = l_gdw04
                        #AND gdw05 = l_gdw05 AND gdw06 = l_gdw06
                 #END IF  #IF NOT cl_null(g_prog_new) THEN #目的程式不是空
            #END IF #IF  cl_confirm('!','agl-197',1) THEN #確定   
         #END IF #IF l_cnt>0 THEN #有資料 跳出訊息   
         #
           #將來源程式的gdw_file寫入record
           #LET l_sql=" SELECT gdw07,gdw09,gdw10,gdw11,gdw12,gdw13,",
                     #" gdwdate,gdwgrup,gdwmodu,gdwuser,gdworig,gdworiu ,gdw14,gdw15 FROM gdw_file ",
                     #" WHERE gdw01 = ? AND gdw02 = ?",
                     #"  AND gdw03 = ? AND gdw04 = ? ",
                     #"  AND gdw05 = ? AND gdw06 =?  "
                     #
             #DECLARE s_grw_curs1 CURSOR FROM l_sql
             #OPEN s_grw_curs1 USING g_prog_old,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06
             #CALL g_gdw_o.clear() 
             #
             #LET i = 1
            #
             #FOREACH s_grw_curs1 INTO g_gdw_o[i].*
             #
                #IF SQLCA.SQLCODE THEN
                   #EXIT FOREACH
                #END IF
                #LET g_gdw_o[i].gdwuser = g_user
                #LET g_gdw_o[i].gdwgrup = g_grup
                #LET g_gdw_o[i].gdwdate = g_today
                #LET g_gdw_o[i].gdworiu = g_user
                #LET g_gdw_o[i].gdworig = g_grup
                #LET g_gdw_o[i].gdw11 = "N" 
                #
                #LET i = i + 1
             #END FOREACH                     
           #將來源程式複製成目的程式寫入gdw_file
           #FOR i= 1 TO l_old_cnt
               #LET l_gdw09_str=g_gdw_o[i].gdw09
               #LET l_gdw09_str = cl_replace_str(l_gdw09_str, g_prog_old, g_prog_new)  #取代檔名
               #LET g_gdw_o[i].gdw09=l_gdw09_str
               #SELECT MAX(gdw08) + 1 INTO l_gdw08 FROM gdw_file
               #LET l_gdw_08_tmp=l_gdw08 #轉成文字
               #IF i=1 THEN
                  #LET l_gdw08_r = l_gdw_08_tmp   #回傳值
               #ELSE
                  #LET l_gdw08_r = l_gdw08_r,"|",l_gdw_08_tmp   
               #END IF #回傳值
               #
               #INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                     #gdw06,gdw07,gdw08,gdw09,gdw10,
                                     #gdw11,gdw12,gdw13,
                                     #gdwdate,gdwgrup,gdwmodu,gdwuser,
                                     #gdworig,gdworiu,gdw14,gdw15)
#
                                      #
               #VALUES (g_prog_new,l_gdw02_n,l_gdw03,l_gdw04,
                        #l_gdw05,l_gdw06,g_gdw_o[i].gdw07,l_gdw08,
                        #g_gdw_o[i].gdw09,g_gdw_o[i].gdw10,g_gdw_o[i].gdw11,
                        #g_gdw_o[i].gdw12,g_gdw_o[i].gdw13,
                        #g_gdw_o[i].gdwdate,g_gdw_o[i].gdwgrup,
                        #g_gdw_o[i].gdwmodu,g_gdw_o[i].gdwuser,
                        #g_gdw_o[i].gdworig,g_gdw_o[i].gdworiu,g_gdw_o[i].gdw14, 
                        #g_gdw_o[i].gdw15) 
                        #
           #END FOR 
           #RETURN l_gdw08_r
 #
#END FUNCTION
#FUN-C30290 MARK----END

#FUN-C30290 ---ADD STRART----
FUNCTION s_gr_gdwcopy(g_chk05,g_gdw08_o,g_gdw01_n,g_gdw02_n,g_gdw03_n,g_gdw04_n,g_gdw05_n,g_gdw06_n)
     DEFINE  g_gdw08_o       LIKE  gdw_file.gdw08  #樣板ID 來源gdw08 
     DEFINE  g_chk05         LIKE  type_file.chr1  #判斷是否覆寫 
     DEFINE  g_gdw01_n       LIKE  gdw_file.gdw01  #檔名(目的)
     DEFINE  g_gdw02_n       LIKE  gdw_file.gdw02  #樣板id
     DEFINE  g_gdw03_n       LIKE  gdw_file.gdw03  #客製否
     DEFINE  g_gdw04_n       LIKE  gdw_file.gdw04  #權限
     DEFINE  g_gdw05_n       LIKE  gdw_file.gdw05  #使用者
     DEFINE  g_gdw06_n       LIKE  gdw_file.gdw06  #行業別    
     DEFINE  l_cnt                 LIKE type_file.num10    #每次計算筆數 
     DEFINE  l_old_cnt             LIKE type_file.num10    #來源筆數 

     DEFINE  l_gdw01_n       LIKE gdw_file.gdw01     #程式名稱 (目的)
     DEFINE  l_gdw02_n       LIKE gdw_file.gdw02     #報表樣板
     DEFINE  l_gdw03_n       LIKE gdw_file.gdw03     #客製否
     DEFINE  l_gdw05_n       LIKE gdw_file.gdw05     #使用者
     DEFINE  l_gdw04_n       LIKE gdw_file.gdw04     #權限
     DEFINE  l_gdw06_n       LIKE gdw_file.gdw06     #行業別
     DEFINE  l_gdw08_n       LIKE gdw_file.gdw08     #樣板ID
     DEFINE  l_gdw01_o       LIKE gdw_file.gdw01     #程式名稱 (來源)
     DEFINE  l_gdw02_o       LIKE gdw_file.gdw02     #報表樣板
     DEFINE  l_gdw03_o       LIKE gdw_file.gdw03     #客製否
     DEFINE  l_gdw05_o       LIKE gdw_file.gdw05     #使用者
     DEFINE  l_gdw04_o       LIKE gdw_file.gdw04     #權限
     DEFINE  l_gdw06_o       LIKE gdw_file.gdw06     #行業別     
     DEFINE  l_gdw08_o       LIKE gdw_file.gdw08     #樣板ID
     
     DEFINE  i             INTEGER

     DEFINE  g_gdw_o  DYNAMIC ARRAY OF RECORD 
           gdw07           LIKE gdw_file.gdw07,    # 序號
           gdw09           LIKE gdw_file.gdw09,    # 樣板名稱(4rp)
           gdw10           LIKE gdw_file.gdw10,    # 樣板說明
           gdw11           LIKE gdw_file.gdw11,    # 標籤列印否
           gdw12           LIKE gdw_file.gdw12,    # 標籤X
           gdw13           LIKE gdw_file.gdw13,    # 標籤Y
           gdwdate         LIKE gdw_file.gdwdate,  # 最近修改日(上傳日期)
           gdwgrup         LIKE gdw_file.gdwgrup,  # 資料所有部門
           gdwmodu         LIKE gdw_file.gdwmodu,  # 資料修改者
           gdwuser         LIKE gdw_file.gdwuser,  # 資料所有者
           gdworig         LIKE gdw_file.gdworig,  # 資料修改者
           gdworiu         LIKE gdw_file.gdworiu,   # 資料所有者 
           gdw14           LIKE gdw_file.gdw14,    # 列印簽核
           gdw15           LIKE gdw_file.gdw15    # 列印簽核位置           
        END RECORD     
     DEFINE l_sql,l_gdw09_str          STRING 
     DEFINE l_gdw08_r,l_gdw_08_tmp     STRING 
     DEFINE l_gfs    RECORD LIKE gfs_file.*  #FUN-D20087


     

     LET l_gdw01_n=g_gdw01_n    
     LET l_gdw02_n=g_gdw02_n
     LET l_gdw03_n=g_gdw03_n
     LET l_gdw04_n=g_gdw04_n
     LET l_gdw05_n=g_gdw05_n
     LET l_gdw06_n=g_gdw06_n

    
            
      IF l_gdw06_n IS  NULL THEN 
        LET l_gdw06_n="std" 
      END IF ##若行業別是空，設為std
      ##重新計算gdw_file筆數

      
      LET l_cnt=0
      #舊值
      SELECT gdw01,gdw02,gdw03,gdw04,gdw05,gdw06 INTO  
             l_gdw01_o,l_gdw02_o,l_gdw03_o,l_gdw04_o,l_gdw05_o,l_gdw06_o FROM gdw_file 
             WHERE gdw08 = g_gdw08_o
      SELECT COUNT(*) INTO l_cnt FROM gdw_file 
               WHERE gdw01 = l_gdw01_o 
               AND gdw02 = l_gdw02_o
               AND gdw03 = l_gdw03_o
               AND gdw04 = l_gdw04_o
               AND gdw05 = l_gdw05_o           
               AND gdw06 = l_gdw06_o 

           
       LET l_old_cnt=l_cnt #將來源筆數存入
 
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt FROM gdw_file 
             WHERE gdw01 = l_gdw01_n
               AND gdw02 = l_gdw02_n
               AND gdw03 = l_gdw03_n
               AND gdw04 = l_gdw04_n
               AND gdw05 = l_gdw05_n            
               AND gdw06 = l_gdw06_n  

       #FUN-D20087 add ---(S)
        DECLARE s_gr_grw_selgfs_cs CURSOR FOR
         SELECT * FROM gfs_file WHERE gfs01 = ?
       #FUN-D20087 add ---(E)

         LET l_gdw08_r=0      
         IF l_cnt > 0 THEN #有資料 跳出訊息
           # IF  cl_confirm('agl-197')= 1 THEN #確定  覆蓋 #FUN-C30290 MARK
            IF  g_chk05= "Y" THEN #確定  覆蓋  #FUN-C30290 add
                 IF NOT cl_null(l_gdw01_n) THEN #目的程式不是空
                      IF l_gdw04_n <> 'default' OR l_gdw05_n <> 'default'THEN
                         LET l_cnt = 0
                         SELECT COUNT(*) INTO l_cnt FROM gdw_file
                          WHERE gdw01 = l_gdw01_n
                            AND gdw02 = l_gdw02_n
                            AND gdw03 = 'Y'
                            AND gdw04 = 'default'
                            AND gdw05 = 'default'
                            AND gdw06 = 'std'
                            
                         IF  l_cnt = 0 THEN
                             CALL cl_err(l_gdw01_n,'azz-086',0)
                         END IF 
                      END IF                

                        #目的程式，有資料先刪
                        DELETE FROM gdw_file
                        WHERE gdw01 = l_gdw01_n AND gdw02 = l_gdw02_n
                        AND gdw03 = l_gdw03_n AND gdw04 = l_gdw04_n
                        AND gdw05 = l_gdw05_n AND gdw06 = l_gdw06_n

                        #FUN-C30290 ADD----START---
                           #將來源程式的gdw_file寫入record
                           LET l_sql=" SELECT gdw07,gdw09,gdw10,gdw11,gdw12,gdw13,",
                                     " gdwdate,gdwgrup,gdwmodu,gdwuser,gdworig,gdworiu ,gdw14,gdw15 FROM gdw_file ",
                                     " WHERE gdw01 = ? AND gdw02 = ?",
                                     "  AND gdw03 = ? AND gdw04 = ? ",
                                     "  AND gdw05 = ? AND gdw06 =?  "       
                                     
                             DECLARE s_grw_curs1 CURSOR FROM l_sql
                             OPEN s_grw_curs1 USING l_gdw01_o,l_gdw02_o,l_gdw03_o,l_gdw04_o,l_gdw05_o,l_gdw06_o
                             CALL g_gdw_o.clear() 
                             
                             LET i = 1
                            
                             FOREACH s_grw_curs1 INTO g_gdw_o[i].*
                             
                                IF SQLCA.SQLCODE THEN
                                   EXIT FOREACH
                                END IF
                                LET g_gdw_o[i].gdwuser = g_user
                                LET g_gdw_o[i].gdwgrup = g_grup
                                LET g_gdw_o[i].gdwdate = g_today
                                LET g_gdw_o[i].gdworiu = g_user
                                LET g_gdw_o[i].gdworig = g_grup
                                LET g_gdw_o[i].gdw11 = "N" 
                                
                                LET i = i + 1
                             END FOREACH                     
                           #將來源程式複製成目的程式寫入gdw_file
                           FOR i= 1 TO l_old_cnt
                               LET l_gdw09_str=g_gdw_o[i].gdw09
                               LET l_gdw09_str = cl_replace_str(l_gdw09_str, l_gdw01_o, l_gdw01_n)  #取代檔名
                               LET g_gdw_o[i].gdw09=l_gdw09_str
                               SELECT MAX(gdw08) + 1 INTO l_gdw08_n FROM gdw_file
                               
                               LET l_gdw_08_tmp=l_gdw08_n #轉成文字
                               IF i=1 THEN
                                  LET l_gdw08_r = l_gdw_08_tmp   #回傳值
                               ELSE
                                  LET l_gdw08_r = l_gdw08_r,"|",l_gdw_08_tmp   
                               END IF #回傳值
                               
                               INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                                     gdw06,gdw07,gdw08,gdw09,gdw10,
                                                     gdw11,gdw12,gdw13,
                                                     gdwdate,gdwgrup,gdwmodu,gdwuser,
                                                     gdworig,gdworiu,gdw14,gdw15)

                                                      
                               VALUES (g_gdw01_n,l_gdw02_n,l_gdw03_n,l_gdw04_n,
                                        l_gdw05_n,l_gdw06_n,g_gdw_o[i].gdw07,l_gdw08_n,
                                        g_gdw_o[i].gdw09,g_gdw_o[i].gdw10,g_gdw_o[i].gdw11,
                                        g_gdw_o[i].gdw12,g_gdw_o[i].gdw13,
                                        g_gdw_o[i].gdwdate,g_gdw_o[i].gdwgrup,
                                        g_gdw_o[i].gdwmodu,g_gdw_o[i].gdwuser,
                                        g_gdw_o[i].gdworig,g_gdw_o[i].gdworiu,g_gdw_o[i].gdw14, 
                                        g_gdw_o[i].gdw15) 
                              #FUN-D20087 add----(S)
                               FOREACH s_gr_grw_selgfs_cs USING g_gdw08_o INTO l_gfs.*
                                   LET l_gfs.gfs01 = l_gdw08_n
                                   INSERT INTO gfs_file VALUES(l_gfs.*) 
                               END FOREACH
                              #FUN-D20087 add----(E)
                           END FOR 
                           RETURN l_gdw08_r

                        #FUN-C30290 ADD----END 
                 END IF  #IF NOT cl_null(g_prog_new) THEN #目的程式不是空

               
            #END IF #IF  cl_confirm('!','agl-197',1) THEN #確定  FUN-C30290 MARK 
            ELSE 
                RETURN l_gdw08_r                   
                  CALL cl_err(l_gdw01_n,'-17',0)   #FUN-C30290 add (120406) 目的程式已存在，資料不覆蓋，顯示訊息
            END IF #IF  g_chk05= "Y" THEN #確定  FUN-C30290 ADD  
         #END IF #IF l_cnt>0 THEN #有資料 跳出訊息   
          ELSE 
                   #將來源程式的gdw_file寫入record
                   LET l_sql=" SELECT gdw07,gdw09,gdw10,gdw11,gdw12,gdw13,",
                             " gdwdate,gdwgrup,gdwmodu,gdwuser,gdworig,gdworiu ,gdw14,gdw15 FROM gdw_file ",
                             " WHERE gdw01 = ? AND gdw02 = ?",
                             "  AND gdw03 = ? AND gdw04 = ? ",
                             "  AND gdw05 = ? AND gdw06 =?  "       
                             
                     DECLARE s_grw_curs2 CURSOR FROM l_sql
                     OPEN s_grw_curs2 USING l_gdw01_o,l_gdw02_o,l_gdw03_o,l_gdw04_o,l_gdw05_o,l_gdw06_o
                     CALL g_gdw_o.clear() 
                     
                     LET i = 1
                    
                     FOREACH s_grw_curs2 INTO g_gdw_o[i].*
                     
                        IF SQLCA.SQLCODE THEN
                           EXIT FOREACH
                        END IF
                        LET g_gdw_o[i].gdwuser = g_user
                        LET g_gdw_o[i].gdwgrup = g_grup
                        LET g_gdw_o[i].gdwdate = g_today
                        LET g_gdw_o[i].gdworiu = g_user
                        LET g_gdw_o[i].gdworig = g_grup
                        LET g_gdw_o[i].gdw11 = "N" 
                        
                        LET i = i + 1
                     END FOREACH                     
                   #將來源程式複製成目的程式寫入gdw_file
                   FOR i= 1 TO l_old_cnt
                       LET l_gdw09_str=g_gdw_o[i].gdw09
                       LET l_gdw09_str = cl_replace_str(l_gdw09_str, l_gdw01_o, l_gdw01_n)  #取代檔名
                       LET g_gdw_o[i].gdw09=l_gdw09_str
                       SELECT MAX(gdw08) + 1 INTO l_gdw08_n FROM gdw_file
                       LET l_gdw_08_tmp=l_gdw08_n #轉成文字
                       IF i=1 THEN
                          LET l_gdw08_r = l_gdw_08_tmp   #回傳值
                       ELSE
                          LET l_gdw08_r = l_gdw08_r,"|",l_gdw_08_tmp   
                       END IF #回傳值
                       
                       INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                             gdw06,gdw07,gdw08,gdw09,gdw10,
                                             gdw11,gdw12,gdw13,
                                             gdwdate,gdwgrup,gdwmodu,gdwuser,
                                             gdworig,gdworiu,gdw14,gdw15)

                                              
                       VALUES (g_gdw01_n,l_gdw02_n,l_gdw03_n,l_gdw04_n,
                                l_gdw05_n,l_gdw06_n,g_gdw_o[i].gdw07,l_gdw08_n,
                                g_gdw_o[i].gdw09,g_gdw_o[i].gdw10,g_gdw_o[i].gdw11,
                                g_gdw_o[i].gdw12,g_gdw_o[i].gdw13,
                                g_gdw_o[i].gdwdate,g_gdw_o[i].gdwgrup,
                                g_gdw_o[i].gdwmodu,g_gdw_o[i].gdwuser,
                                g_gdw_o[i].gdworig,g_gdw_o[i].gdworiu,g_gdw_o[i].gdw14, 
                                g_gdw_o[i].gdw15) 
                      #FUN-D20087 add----(S)
                       FOREACH s_gr_grw_selgfs_cs USING g_gdw08_o INTO l_gfs.*
                           LET l_gfs.gfs01 = l_gdw08_n
                           INSERT INTO gfs_file VALUES(l_gfs.*) 
                       END FOREACH
                      #FUN-D20087 add----(E)
                                
                   END FOR 
                   RETURN l_gdw08_r
          END IF #IF l_cnt>0 THEN #有資料 跳出訊息
END FUNCTION
#FUN-C30290 ---ADD END----
#FUN-C30005 add
FUNCTION s_gr_gdwcopy_gdw08(g_gdw09_new,g_gdw08_old,gr_user)

     DEFINE  g_gdw09_new LIKE  gdw_file.gdw09 #目的樣版名稱
     DEFINE  g_gdw08_old    LIKE  gdw_file.gdw08     
     DEFINE  gr_user        LIKE type_file.chr1   #判斷g_user是抓環境變數還是default
     DEFINE  l_gdw01_n      LIKE gdw_file.gdw01     #程式名稱
     DEFINE  l_gdw05_n       LIKE gdw_file.gdw05     #使用者
     DEFINE  l_gdw04_n       LIKE gdw_file.gdw04     #權限
     DEFINE  l_gdw08_o       LIKE gdw_file.gdw08     #樣版ID
     DEFINE  l_have_cnt,l_old_cnt            INTEGER 
     DEFINE  l_gdw_o_v     RECORD 
             l_gdw01     LIKE gdw_file.gdw01,     #存舊gdw08反推出來的01-06，要去抓筆數
             l_gdw02     LIKE gdw_file.gdw02,
             l_gdw03     LIKE gdw_file.gdw03,
             l_gdw04     LIKE gdw_file.gdw04,
             l_gdw05     LIKE gdw_file.gdw05,
             l_gdw06     LIKE gdw_file.gdw06,
             l_gdw09     LIKE gdw_file.gdw09   #FUN-C60012 add
             END RECORD 
      DEFINE  g_gdw_o    DYNAMIC ARRAY OF RECORD 
           #gdw01           LIKE gdw_file.gdw01,     #程式名稱
           #gdw02           LIKE gdw_file.gdw02,     #報表樣版
           #gdw03           LIKE gdw_file.gdw03,     #客製否
           #gdw06           LIKE gdw_file.gdw06,     #行業別
           gdw07           LIKE gdw_file.gdw07,    # 序號
           gdw09           LIKE gdw_file.gdw09,    # 樣板名稱(4rp)
           gdw10           LIKE gdw_file.gdw10,    # 樣板說明
           gdw11           LIKE gdw_file.gdw11,    # 標籤列印否
           gdw12           LIKE gdw_file.gdw12,    # 標籤X
           gdw13           LIKE gdw_file.gdw13,    # 標籤Y
           gdwdate         LIKE gdw_file.gdwdate,  # 最近修改日(上傳日期)
           gdwgrup         LIKE gdw_file.gdwgrup,  # 資料所有部門
           gdwmodu         LIKE gdw_file.gdwmodu,  # 資料修改者
           gdwuser         LIKE gdw_file.gdwuser,  # 資料所有者
           gdworig         LIKE gdw_file.gdworig,  # 資料修改者
           gdworiu         LIKE gdw_file.gdworiu,   # 資料所有者 
           gdw14           LIKE gdw_file.gdw14,    # 列印簽核
           gdw15           LIKE gdw_file.gdw15    # 列印簽核位置   
       END RECORD    
 
     DEFINE l_sql         STRING 
     DEFINE l_gdw08_n      LIKE gdw_file.gdw08
     DEFINE l_gdw08_r       STRING 
     DEFINE l_gdw09_str     LIKE gdw_file.gdw09
     DEFINE l_str,l_gdw_08_tmp         STRING 
     DEFINE i             INTEGER 
     DEFINE l_gdw03_n     LIKE gdw_file.gdw03  #存新的客製否
     DEFINE l_gdw02_n     LIKE gdw_file.gdw02
     DEFINE l_gdw06_n     LIKE gdw_file.gdw06
     DEFINE l_gdw07_n     LIKE gdw_file.gdw07   #FUN-C60012 add
     
     LET l_gdw09_str=g_gdw09_new
     LET l_str=l_gdw09_str
     LET l_gdw01_n = l_str.substring(1,7) 
     IF gr_user="Y" THEN
        LET l_gdw04_n= "default"
        lET l_gdw05_n="default"
     ELSE
        LET l_gdw04_n= "default"
        lET l_gdw05_n=g_user
     END IF
     LET l_gdw08_o =g_gdw08_old
     LET l_gdw03_n ="Y"  #皆為客製
     LET l_gdw06_n=g_sma.sma124
     #先用舊的gdw08抓出七個值
     SELECT gdw01,gdw02,gdw03,gdw04,gdw05,gdw06,gdw09 INTO l_gdw_o_v.*  ##FUN-C60012 add gdw09
     FROM gdw_file WHERE gdw08=l_gdw08_o
     IF l_gdw09_str CLIPPED  <> l_gdw_o_v.l_gdw09 CLIPPED  THEN #4rp檔名一樣 則不用存 #FUN-C60012 add
         LET l_gdw02_n = cl_replace_str(l_gdw_o_v.l_gdw02, l_gdw_o_v.l_gdw01, l_gdw01_n) #FUN-C30290 MARK #FUN-C60012add
         #計算舊的筆數
         LET l_old_cnt=0
         SELECT COUNT(*) INTO l_old_cnt FROM gdw_file 
                WHERE gdw01 =l_gdw_o_v.l_gdw01
                 AND gdw02 = l_gdw_o_v.l_gdw02
                 AND gdw03 = l_gdw_o_v.l_gdw03
                 AND gdw04 = l_gdw_o_v.l_gdw04
                 AND gdw05 = l_gdw_o_v.l_gdw05          
                 AND gdw06 = l_gdw_o_v.l_gdw06  
                 AND gdw09 = l_gdw_o_v.l_gdw09   ##FUN-C60012 
         
         LET l_have_cnt=0 
         #先判斷此user要新增的樣版名稱是否存在，有即不做，沒有才要存
         #FUN-C60012 此user已有存樣版，則序號重抓，否則不用
         SELECT count(*) INTO l_have_cnt FROM gdw_file 
                WHERE gdw01 =l_gdw01_n
                 AND gdw02 = l_gdw02_n
                 AND gdw03 = l_gdw03_n
                 AND gdw04 = l_gdw04_n
                 AND gdw05 = l_gdw05_n       
                 AND gdw06 = l_gdw06_n         

                
        # IF l_have_cnt =0 THEN #樣板未存在  #FUN-C60012 mark

               LET l_sql=" SELECT gdw07,gdw09,gdw10,gdw11,gdw12,gdw13,",
                         " gdwdate,gdwgrup,gdwmodu,gdwuser,gdworig,gdworiu ,gdw14,gdw15 FROM gdw_file ",
                         " WHERE gdw01 = ? AND gdw02 = ?",
                         "  AND gdw03 = ? AND gdw04 = ? ",
                         "  AND gdw05 = ? AND gdw06 =?  "
                        
                         
                 DECLARE s_grw_curs4 CURSOR FROM l_sql
                 #OPEN s_grw_curs4 USING l_gdw_o_v.* #l_gdw_o_v.l_gdw01,l_gdw_o_v.l_gdw02,l_gdw_o_v.l_gdw03,l_gdw_o_v.l_gdw04,l_gdw_o_v.l_gdw05,l_gdw_o_v.l_gdw06 #FUN-C60012 mark
                 OPEN s_grw_curs4 USING l_gdw_o_v.l_gdw01,l_gdw_o_v.l_gdw02,l_gdw_o_v.l_gdw03,l_gdw_o_v.l_gdw04,l_gdw_o_v.l_gdw05,l_gdw_o_v.l_gdw06 #FUN-C60012 add
                 CALL g_gdw_o.clear() 
                 
                 LET i = 1
                
                 FOREACH s_grw_curs4 INTO g_gdw_o[i].*
                 
                    IF SQLCA.SQLCODE THEN
                       EXIT FOREACH
                    END IF
                    LET g_gdw_o[i].gdwuser = g_user
                    LET g_gdw_o[i].gdwgrup = g_grup
                    LET g_gdw_o[i].gdwdate = g_today
                    LET g_gdw_o[i].gdworiu = g_user
                    LET g_gdw_o[i].gdworig = g_grup
                    LET g_gdw_o[i].gdw11 = "N" 
                    
                    LET i = i + 1
                 END FOREACH                     
               #將來源程式複製成目的程式寫入gdw_file
               
               FOR i= 1 TO l_old_cnt
                  #IF gr_user="Y" THEN  #直接copy檔案時，沒有傳gdw09的樣版 
                   #TQC-C60041 mark-start 
                   #LET l_gdw09_str = g_gdw_o[i].gdw09
                   #LET l_gdw09_str = cl_replace_str(l_gdw09_str, l_gdw_o_v.l_gdw01, l_gdw01_n)  #取代檔名
                   #TQC-C60041 mark-end
                  #END IF 
                   LET g_gdw_o[i].gdw09=l_gdw09_str
                   SELECT MAX(gdw08) + 1 INTO l_gdw08_n FROM gdw_file
                   LET l_gdw_08_tmp=l_gdw08_n #轉成文字
                   IF i=1 THEN
                      LET l_gdw08_r = l_gdw_08_tmp   #回傳值
                   ELSE
                      LET l_gdw08_r = l_gdw08_r,"|",l_gdw_08_tmp   
                   END IF #回傳值

                   #FUN-C60012 add-start------------
                   IF  l_have_cnt >0 THEN 
                     SELECT max(gdw07)+1 INTO g_gdw_o[i].gdw07 FROM gdw_file 
                            WHERE gdw01 =l_gdw01_n
                             AND gdw02 = l_gdw02_n
                             AND gdw03 = l_gdw03_n
                             AND gdw04 = l_gdw04_n
                             AND gdw05 = l_gdw05_n          
                             AND gdw06 = l_gdw06_n  

                             
                     DISPLAY "gdw07:",g_gdw_o[i].gdw07
                   END IF   
                   #FUN-C60012 add-end--------------
                   
                   INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                         gdw06,gdw07,gdw08,gdw09,gdw10,
                                         gdw11,gdw12,gdw13,
                                         gdwdate,gdwgrup,gdwmodu,gdwuser,
                                         gdworig,gdworiu,gdw14,gdw15)

                                          
                   #VALUES (l_gdw01_n,l_gdw02_n,l_gdw03_n,l_gdw04_n, #FUN-C30290 gdw01' gdw02要用舊值
                   VALUES (l_gdw_o_v.l_gdw01,l_gdw_o_v.l_gdw02,l_gdw03_n,l_gdw04_n,
                            l_gdw05_n,l_gdw06_n,g_gdw_o[i].gdw07,l_gdw08_n, #FUN-C60012                         
                            g_gdw_o[i].gdw09,g_gdw_o[i].gdw10,g_gdw_o[i].gdw11,
                            g_gdw_o[i].gdw12,g_gdw_o[i].gdw13,
                            g_gdw_o[i].gdwdate,g_gdw_o[i].gdwgrup,
                            g_gdw_o[i].gdwmodu,g_gdw_o[i].gdwuser,
                            g_gdw_o[i].gdworig,g_gdw_o[i].gdworiu,g_gdw_o[i].gdw14, 
                            g_gdw_o[i].gdw15) 
                            
               END FOR 
               RETURN l_gdw08_r
         
            #舊的只存一筆的寫法
             #LET l_gdw08_r=0   
            #
              #將來源程式的gdw_file寫入record
                 #LET l_sql=" SELECT gdw01,gdw02,gdw03,gdw06,gdw07,gdw09,gdw10,gdw11,gdw12,gdw13,",
                           #" gdwdate,gdwgrup,gdwmodu,gdwuser,gdworig,gdworiu ,gdw14,gdw15 FROM gdw_file ",
                           #" WHERE gdw08 = ? "
                 #DECLARE s_grw_curs2 CURSOR FROM l_sql
                 #OPEN s_grw_curs2 USING l_gdw08
                 #FOREACH s_grw_curs2 INTO g_gdw_o.*
                 #
                    #IF SQLCA.SQLCODE THEN
                       #EXIT FOREACH
                    #END IF
                    #LET g_gdw_o.gdw02 = cl_replace_str(g_gdw_o.gdw02, g_gdw_o.gdw01, l_gdw01)
                    #LET g_gdw_o.gdwgrup = g_grup
                    #LET g_gdw_o.gdwdate = g_today
                    #LET g_gdw_o.gdworiu = g_user
                    #LET g_gdw_o.gdworig = g_grup
                    #LET g_gdw_o.gdw11 = "N"                 
                    #LET g_gdw_o.gdw03 = "Y" #皆為客製
                    #LET i = i + 1
                 #END FOREACH                     
               #將來源程式複製成目的程式寫入gdw_file
                   #
                  #
                   #SELECT MAX(gdw08) + 1 INTO l_gdw08 FROM gdw_file
                   #
                   #
                   #INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                         #gdw06,gdw07,gdw08,gdw09,gdw10,
                                         #gdw11,gdw12,gdw13,
                                         #gdwdate,gdwgrup,gdwmodu,gdwuser,
                                         #gdworig,gdworiu,gdw14,gdw15)
    #
                  #
                   #VALUES (l_gdw01,g_gdw_o.gdw02,g_gdw_o.gdw03,l_gdw04,l_gdw05,
                           #g_gdw_o.gdw06,g_gdw_o.gdw07,l_gdw08,l_gdw09_str,g_gdw_o.gdw10,
                           #g_gdw_o.gdw11,g_gdw_o.gdw12,g_gdw_o.gdw13,
                            #g_gdw_o.gdwdate,g_gdw_o.gdwgrup,g_gdw_o.gdwmodu,g_gdw_o.gdwuser,
                            #g_gdw_o.gdworig,g_gdw_o.gdworiu,g_gdw_o.gdw14, g_gdw_o.gdw15) 
    #
               #RETURN l_gdw08
          
          ELSE  #資料已存在 回傳原先傳入的gdw08
                RETURN g_gdw08_old 
          #END IF  #IF l_have_cnt =0 then  #FUN-C60012 mark-end----
          

      END IF  #FUN-C60012 add
END FUNCTION



#FUNCTION s_gr_4rpcopy(l_prog_o,l_prog_n,l_ny,g_gdw08_o,l_gdw08_r) #FUN-C30290 MARK
FUNCTION s_gr_4rpcopy(g_chk06,g_chk07,l_gdw03_n,l_prog_o,l_prog_n,l_ny,g_gdw08_o,l_gdw08_r)   #FUN-C30290 ADD

   DEFINE l_prog_o                         LIKE   gdw_file.gdw01 #來源檔案
   DEFINE l_prog_n                         LIKE   gdw_file.gdw01 #目的檔案
   DEFINE g_chk07                          LIKE   type_file.chr1 #是否覆蓋  #FUN-C30290 ADD
   DEFINE g_chk06                          LIKE   type_file.chr1 #是否覆蓋  #FUN-C30290 ADD
   DEFINE l_ny                             STRING                #是否做呼叫s_replang_scan
   DEFINE l_path_o                         STRING                #來源檔路徑
   DEFINE l_path_src_o                     STRING                #來源src路徑 #FUN-C30290 add(120406)
   DEFINE l_path_n ,l_path_new             STRING                #目的檔路徑
   DEFINE l_path_src_n                     STRING                #目的檔src路徑 #FUN-C30290 add(120406)
   DEFINE l_module_o                       LIKE zz_file.zz011  #模組
   DEFINE l_module_n                       LIKE zz_file.zz011  #模組
   DEFINE l_mod_str,l_str_l,l_path_o_s     STRING    #模組轉換成字串\
   DEFINE l_path_n_s                       STRING 
   DEFINE l_path_src_n_s,l_path_src_o_s    STRING 
   DEFINE l_i,l_l ,l_rpt_cnt               LIKE type_file.num5
   DEFINE l_prog_new                       STRING   #存複製新檔名的陣列
   DEFINE l_i_str ,l_path_str              STRING   #存語系的字串
   DEFINE file_path_o,file_path_n          STRING 
   DEFINE file_path_src_o,file_path_src_n  STRING  #src路徑  #FUN-C30290  ADD(120406)
   DEFINE l_gdw02 ,l_gdw02_n               LIKE gdw_file.gdw02
   DEFINE l_gdw03 ,l_gdw03_n               LIKE gdw_file.gdw03  #FUN-C30290  ADD
   DEFINE g_gdw08_o                        LIKE gdw_file.gdw08  #來源gdw08
   DEFINE l_gdw08_o                        LIKE gdw_file.gdw08  #來源gdw08  
   DEFINE l_lang                           LIKE gdw_file.gdw03
   DEFINE l_gdm01                          LIKE gdm_file.gdm01
   DEFINE  l_gdw08_r     DYNAMIC ARRAY OF INTEGER     #樣版ID
   DEFINE l_gay01                           LIKE gay_file.gay01  #FUN-D20068 add
   DEFINE l_langs        DYNAMIC ARRAY OF STRING     #FUN-D20068 add

   
   LET l_prog_o = l_prog_o
   LET l_prog_n = l_prog_n
   #LET l_module_o = l_module_o
   #LET l_module_n = l_module_n
   SELECT zz011 INTO l_module_o FROM zz_file WHERE zz01= l_prog_o
   SELECT zz011 INTO l_module_n FROM zz_file WHERE zz01= l_prog_n
   LET l_gdw08_o=g_gdw08_o
   LET l_gdm01=l_gdw08_o
 
   
  # SELECT gdw02 INTO l_gdw02 FROM gdw_file #FUN-C30290 MARK
   SELECT gdw02,gdw03 INTO l_gdw02,l_gdw03 FROM gdw_file  #FUN-C30290 ADD
          WHERE gdw08= l_gdw08_o

   LET l_gdw02_n =cl_replace_str( l_gdw02, l_prog_o, l_prog_n)
   LET l_mod_str=l_module_o
   LET l_mod_str=l_mod_str.toLowerCase()
   IF l_mod_str.subString(1,1)="c"  THEN #模組字串第一位
         LET l_path_o=fgl_getenv("CUST")#抓路徑
         LET l_path_src_o=fgl_getenv("CUST")#抓路徑
   ELSE
      IF l_gdw03="Y" THEN 
      ELSE 
         LET l_path_o=fgl_getenv("TOP")#抓路徑
         LET l_path_src_o=fgl_getenv("TOP")#抓路徑
      END IF 
   END IF
   LET l_path_o =l_path_o CLIPPED,"/" ,l_mod_str,"/" ,"4rp/"  #來源路徑
   LET l_path_src_o =l_path_src_o CLIPPED,"/" ,l_mod_str,"/" ,"4rp/src/"  #來源的src路徑 #FUN-C30290 ADD (120406)

   
   LET l_mod_str=l_module_n
   LET l_mod_str=l_mod_str.toLowerCase()
   IF l_mod_str.subString(1,1)="c" THEN #模組字串第一位
         LET l_path_n=fgl_getenv("CUST")#抓路徑
         LET l_path_src_n=fgl_getenv("CUST")#抓路徑        
         
   ELSE
        IF l_gdw03_n="Y" THEN  #FUN-C30290 ADD
          LET l_path_n=fgl_getenv("CUST")#抓路徑  #FUN-C30290 ADD
          LET l_path_src_n=fgl_getenv("CUST")#抓路徑     #FUN-C30290 ADD   
          LET l_mod_str = 'c',l_mod_str.subString(2,l_mod_str.getLength()) CLIPPED #FUN-C30290 add 
        ELSE                                             #FUN-C30290 ADD
         LET l_path_n=fgl_getenv("TOP")#抓路徑
         LET l_path_src_n=fgl_getenv("TOP")#抓路徑
        END IF    #FUN-C30290 ADD
   END IF

   LET l_path_n =l_path_n CLIPPED,"/" ,l_mod_str,"/" ,"4rp/" #目的路徑
   LET l_path_src_n =l_path_src_n CLIPPED,"/" ,l_mod_str,"/" ,"4rp/src/" #目的src路徑  #FUN-C30290 ADD (120406)


   DISPLAY "l_path_n:",l_path_n

  
   #IF os.path.exists(l_path_n) THEN
      #IF os.path.delete(l_path_n) THEN END IF 
   #END if
  # IF os.path.exists(l_path_o) THEN #來源資料夾是否存在  #FUN-C30290 MARK (120406)
        #IF os.path.chrwx(l_path_o,777) THEN END IF #開來源資料夾權限  #FUN-C90038 mark
        IF os.path.chrwx(l_path_o,511) THEN END IF #開來源資料夾權限   #FUN-C90038 add
        SELECT COUNT(gdw09) INTO l_rpt_cnt FROM gdw_file  #計算總報表數(含子報表)
               WHERE gdw01 = l_prog_o AND gdw02 =l_gdw02
        LET l_rpt_cnt=l_rpt_cnt-1 #計算子報表數      

        #FUN-D20068 add -(s)
        CALL l_langs.clear()
        DECLARE s_gr_grw_f_cur1 CURSOR FROM "SELECT gay01 FROM gay_file ORDER BY gay01"
        LET l_i = 1
        FOREACH s_gr_grw_f_cur1 INTO l_gay01
            LET l_langs[l_i] = l_gay01
            LET l_i = l_i + 1
        END FOREACH
        CALL l_langs.deleteElement(l_i)
        
        FOR l_i= 1 TO l_langs.getLength() # 依語系，複製檔案
        #FUN-D20068 add -(e)        
        
        #FOR l_i= 0 TO 5            # 五種語系，複製檔案  #FUN-D20068 mark
          #LET l_i_str=l_i                              #FUN-D20068 mark
          LET l_i_str=l_langs[l_i]                      #FUN-D20068 add
          LET l_path_str =""
          #LET  l_lang = l_i_str #轉語系                  #FUN-D20068 mark
          LET l_lang=l_langs[l_i]                       #FUN-D20068 add
          LET l_path_str =l_path_o CLIPPED ,l_i_str CLIPPED ,"/" 
          IF os.path.exists(l_path_str) THEN #來源資料夾的語系是否存在

            #主報表複製
            LET l_path_o_s=l_path_o CLIPPED,l_i_str CLIPPED,"/",l_gdw02,".4rp"
            LET l_path_n_s=l_path_n CLIPPED,l_i_str CLIPPED,"/",l_gdw02_n,".4rp"
            #FUN-C30290 add start  (120406)
           #主報表src複製
            LET l_path_src_o_s=l_path_src_o CLIPPED,l_gdw02,".4rp"
            LET l_path_src_n_s=l_path_src_n CLIPPED,l_gdw02_n,".4rp"
            #FUN-C30290 add end   (120406)
            #FUN-C30290 ADD-START
              IF os.Path.exists(l_path_n_s) AND g_chk07 ="Y" THEN  #FUN-C30290 ADD 檔案存在且要覆寫
                   IF l_path_n_s CLIPPED  <> l_path_o_s then
                    IF os.Path.delete(l_path_n_s) THEN END IF
                   END IF 
              END IF
            #FUN-C30290 ADD-END
            
            IF NOT os.Path.exists(l_path_n_s) THEN  #FUN-C30290 ADD
                    IF  os.Path.copy(l_path_o_s,l_path_n_s) THEN END IF 
                    
                    #做p_replang_rescan4rp的動作
                    #IF l_ny ="Y" THEN CALL p_replang_rescan4rp(l_path_n_s,l_prog_n,l_lang) END IF 
                    #IF l_ny ="Y" THEN CALL p_replang_rescan4rp(l_path_n_s,l_gdw08_r[1],l_lang) END IF #FUN-30290 MARK 
                    
                    
                    LET l_prog_new = l_gdw02_n,".4rp" #存新的主報表
                    #改程式碼內檔名部分 
                    CALL s_gr_grw_write(l_path_n_s,l_gdw02_n,l_gdw02)

                    IF  os.Path.copy(l_path_src_o_s,l_path_src_n_s) THEN END IF  #FUN-C30290 ADD 複製SRC資料
                    CALL s_gr_grw_write(l_path_src_n_s,l_gdw02_n,l_gdw02)  #FUN-C30290 ADD 複製SRC資料
                    #子報表的複製
                    IF l_rpt_cnt>0 THEN #有才需要複製
                        FOR l_l=1 TO l_rpt_cnt
                           LET l_str_l =l_l USING "&&"  #子報表的01表現
                           LET file_path_o=l_path_str CLIPPED,l_gdw02,"_subrep",l_str_l,".4rp" 
                           LET file_path_src_o=l_path_src_o CLIPPED,l_gdw02,"_subrep",l_str_l,".4rp"  #FUN-C30290 add (120406)
                           IF os.Path.exists(file_path_o) THEN   #判斷檔案是否存在
                              LET l_path_new=l_path_n
                              LET file_path_n=l_path_n CLIPPED,l_i_str CLIPPED ,"/",l_gdw02_n,"_subrep",l_str_l,".4rp"
                              LET file_path_src_n=l_path_src_n CLIPPED ,l_gdw02_n,"_subrep",l_str_l,".4rp"  #FUN-C30290 add (120406)

                                #FUN-C30290 ADD-START
                                  IF os.Path.exists(file_path_n) AND g_chk07 ="Y" THEN  #FUN-C30290 ADD 檔案存在且要覆寫
                                    IF file_path_n CLIPPED  <> file_path_o then
                                     IF os.Path.delete(file_path_n) THEN END IF
                                    END IF  
                                  END IF
                                 
                                  IF os.Path.exists(file_path_src_n) AND g_chk07 ="Y" THEN   #FUN-C30290 ADD (120406)  
                                    IF file_path_src_n CLIPPED  <> file_path_src_o THEN       #FUN-C30290 ADD (120406)
                                     IF os.Path.delete(file_path_src_n) THEN END IF           #FUN-C30290 ADD (120406)
                                    END IF  
                                  END IF                                  
                                #FUN-C30290 ADD-END
                              
                              IF NOT os.Path.exists(file_path_n) THEN #FUN-C30290 ADD
                                  IF  os.Path.copy(file_path_o,file_path_n) THEN END IF
                                  
                                  #做p_replang_rescan4rp的動作                                 
                                  #IF l_ny ="Y" THEN CALL p_replang_rescan4rp(file_path_n,l_prog_n,l_lang) END IF
                                  #IF l_ny ="Y" THEN CALL p_replang_rescan4rp(l_path_n_s,l_gdw08_r[l_l],l_lang) END IF  #FUN-C30290 MARK
                                   LET l_prog_new=file_path_n #存新的子報表
                              
                                  #改程式碼內檔名部分                    
                                   CALL s_gr_grw_write(file_path_n,l_gdw02_n,l_gdw02)

             
                              END IF #IF NOT os.Path.exists(file_path_n) THEN  #FUN-C30290 ADD


                              #FUN-C30290 ADD--start (120406)
                              IF NOT os.Path.exists(file_path_src_n) THEN 
                                  
                                   IF  os.Path.copy(file_path_src_o,file_path_src_n) THEN END IF
                                  #做p_replang_rescan4rp的動作
                                   LET l_prog_new=file_path_src_n #存新的子報表                               
                                  #改程式碼內檔名部分                    
                                   CALL s_gr_grw_write(file_path_src_n,l_gdw02_n,l_gdw02)
                              END IF 
                               #FUN-C30290 ADD--end  (120406)
                              
                           ELSE
                              CALL cl_err('path','ain-176',0)
                           END IF
                        END FOR 
                    END IF

            END IF #IF NOT os.Path.exists(l_path_n_s) THEN #FUN-C30290 ADD
            
          ELSE 
              CALL cl_err('path','ain-176',0)
          END IF  #IF os.path.exists(l_path_o) THEN #來源資料夾的語系是否存在
        END FOR # 五種語系，複製檔案
  # ELSE   #FUN-C30290 MARK (120406)
  #     CALL cl_err('path','ain-176',0)  #FUN-C30290 MARK (120406)
  # END IF     #os.path.exists(l_path_o) THEN #來源資料夾是否存在    #FUN-C30290 MARK (120406)
  

   
END FUNCTION


FUNCTION s_gr_grw_write(l_path_new,l_prog_n,l_prog_o)
   DEFINE l_path_new       STRING   #目的檔案路徑
   DEFINE l_prog_n         LIKE gdw_file.gdw01   #目的檔  
   DEFINE l_prog_o         LIKE gdw_file.gdw01   #來源檔
   DEFINE l_cmd,l_read_str STRING
   DEFINE lc_chin       base.Channel
   DEFINE lc_chout         base.Channel
   DEFINE lr_prog          DYNAMIC ARRAY OF STRING  
   DEFINE l_i ,i             LIKE type_file.num5 
   DEFINE l_prog_file_n    STRING 
      #FUN-C30290 ADD
      #LET l_prog_file_n=l_prog_n,".4rp"
      #IF os.path.chrwx(l_prog_file_n,777) THEN END IF #開來源資料夾權限 

      #FUN-C30290 ADD     
      #讀檔
      #FUN-D20068 add-(s)
      IF os.path.chrwx(l_path_new,511) THEN END IF #開來源資料夾權限 
      #FUN-D20068 add-(e)
      LET l_cmd = l_path_new      
      DISPLAY l_cmd
      LET lc_chin = base.Channel.create() #create new 物件
      CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
      LET l_i=1

      WHILE TRUE   
             LET l_read_str =lc_chin.readLine() #整行讀入
             LET l_read_str = cl_replace_str(l_read_str, l_prog_o, l_prog_n)  #取代檔名
             LET lr_prog[l_i] =l_read_str #讀取資料後存入tmp中
             IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
             LET l_i = l_i + 1
      END WHILE
      CALL lc_chin.close()  

      #寫檔	 

      LET lc_chout = base.Channel.create()
      CALL lc_chout.openFile(l_cmd,"w")
      
      FOR i = 1 TO lr_prog.getLength()
	    	 CALL lc_chout.writeLine(lr_prog[i])
      END FOR	 
      CALL lc_chout.close()
     

END FUNCTION 




#FUNCTION s_gr_grw_name(c_prog) #傳回程式名稱
    #DEFINE c_prog       LIKE  gdw_file.gdw01
    #DEFINE l_gdw01        LIKE  gdw_file.gdw01
    #DEFINE l_name       LIKE  gaz_file.gaz03
#
    #LET l_gdw01=c_prog
    #LET l_name=""
    #SELECT gaz03 INTO l_name FROM gaz_file
    #WHERE gaz01 = l_gdw01 AND gaz02 = g_lang
     #IF SQLCA.SQLCODE THEN
        #LET l_name = ""
     #END IF
     #RETURN l_name                
                     #
#END FUNCTION

