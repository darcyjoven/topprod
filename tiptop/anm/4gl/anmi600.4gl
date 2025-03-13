# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: anmi600.4gl
# Descriptions...: 投資種類維護作業
# Date & Author..: 99/07/06 by Mandy
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制     
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-590111 05/10/04 By Nicola 新增欄位gsa05,gsa06
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/29 By douzh 兩套帳修改新增gsa041,gsa051,gsa061欄位
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740049 07/04/12 By hongmei 會計科目加帳套 
# Modify.........: No.TQC-740093 07/04/17 By bnlent 會計科目加帳套BUG修改 
# Modify.........: No.FUN-7C0043 07/12/28 By Cockroach 報表改為p_query實現
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/24 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-D30032 13/04/03 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_gsa           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        gsa01       LIKE gsa_file.gsa01,    #投資種類
        gsa02       LIKE gsa_file.gsa02,   
        gsa04       LIkE gsa_file.gsa04,
        aag02       LIKE aag_file.aag02,  
        gsa041      LIkE gsa_file.gsa041,  #No.FUN-680088 
        aag02_3     LIKE aag_file.aag02,   #No.FUN-680088
        gsa05       LIkE gsa_file.gsa05,   #No.FUN-590111
        aag02_1     LIKE aag_file.aag02,   #No.FUN-590111
        gsa051      LIkE gsa_file.gsa051,  #No.FUN-680088
        aag02_4     LIKE aag_file.aag02,   #No.FUN-680088
        gsa06       LIkE gsa_file.gsa06,   #No.FUN-590111
        aag02_2     LIKE aag_file.aag02,   #No.FUN-590111
        gsa061      LIkE gsa_file.gsa061,  #No.FUN-680088
        aag02_5     LIKE aag_file.aag02,   #No.FUN-680088
        gsaacti     LIKE gsa_file.gsaacti  #NO.FUN-680107 VARCHAR(1) 
                    END RECORD,
    g_gsa_t         RECORD                 #程式變數 (舊值)
        gsa01       LIKE gsa_file.gsa01,   #投資種類
        gsa02       LIKE gsa_file.gsa02,   #投資種類名稱
        gsa04       LIKE gsa_file.gsa04,   #會計科目
        aag02       LIKE aag_file.aag02, 
        gsa041      LIkE gsa_file.gsa041,  #No.FUN-680088 
        aag02_3     LIKE aag_file.aag02,   #No.FUN-680088
        gsa05       LIkE gsa_file.gsa05,   #No.FUN-590111
        aag02_1     LIKE aag_file.aag02,   #No.FUN-590111
        gsa051      LIkE gsa_file.gsa051,  #No.FUN-680088
        aag02_4     LIKE aag_file.aag02,   #No.FUN-680088
        gsa06       LIkE gsa_file.gsa06,   #No.FUN-590111
        aag02_2     LIKE aag_file.aag02,   #No.FUN-590111
        gsa061      LIkE gsa_file.gsa061,  #No.FUN-680088
        aag02_5     LIKE aag_file.aag02,   #No.FUN-680088
        gsaacti     LIKE gsa_file.gsaacti  #NO.FUN-680107 VARCHAR(1) 
                    END RECORD,
    g_wc,g_sql      STRING,
    g_rec_b         LIKE type_file.num5,   #單身筆數            #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5   #FUN-570108           #No.FUN-680107 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107  SMALLINT 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 4 LET p_col = 5
    OPEN WINDOW i600_w AT p_row,p_col WITH FORM "anm/42f/anmi600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("gsa041,gsa051,gsa061",g_aza.aza63='Y') #FUN-680088
    CALL cl_set_comp_visible("aag02_3,aag02_4,aag02_5",g_aza.aza63='Y') #FUN-680088 
 
    LET g_wc = '1=1' CALL i600_b_fill(g_wc)
    CALL i600_menu()
    CLOSE WINDOW i600_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i600_menu()
   WHILE TRUE
 
      CALL i600_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i600_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gsa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_q()
   CALL i600_b_askkey()
END FUNCTION
 
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否          #NO.FUN-680107 VARCHAR(1)                  
    l_allow_delete  LIKE type_file.num5    #可刪除否          #NO.FUN-680107 VARCHAR(1)
                      
    LET g_action_choice = ""                                                    
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gsa01,gsa02,gsa04,'',gsa041,'',gsa05,'',gsa051,'',gsa06,'',gsa061,'',gsaacti",   #No.FUN-590111  #FUN-680088
                       "  FROM gsa_file WHERE gsa01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gsa WITHOUT DEFAULTS FROM s_gsa.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)                                           
         END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3  #MOD-960067
           #LET g_gsa_t.* = g_gsa[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_gsa_t.* = g_gsa[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i600_set_entry(p_cmd)                                      
                CALL i600_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end     
 
                BEGIN WORK
                OPEN i600_bcl USING g_gsa_t.gsa01
                IF STATUS THEN
                   CALL cl_err("OPEN i600_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                   FETCH i600_bcl INTO g_gsa[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_gsa_t.gsa01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   SELECT aag02 INTO g_gsa[l_ac].aag02 FROM aag_file
                    WHERE aag01=g_gsa[l_ac].gsa04
                      AND aag00=g_aza.aza81  #No.FUN-740029 add aag00
#FUN-680088-begin
                   SELECT aag02 INTO g_gsa[l_ac].aag02_3 FROM aag_file                                                                
                    WHERE aag01=g_gsa[l_ac].gsa041
                      AND aag00=g_aza.aza82  #No.FUN-740029 add aag00
                   #-----No.FUN-590111-----
                   SELECT aag02 INTO g_gsa[l_ac].aag02_1 FROM aag_file
                    WHERE aag01=g_gsa[l_ac].gsa05
                      AND aag00=g_aza.aza81  #No.FUN-740029 add aag00
                   SELECT aag02 INTO g_gsa[l_ac].aag02_4 FROM aag_file                                                                
                    WHERE aag01=g_gsa[l_ac].gsa051
                      AND aag00=g_aza.aza82  #No.FUN-740029 add aag00 
                   SELECT aag02 INTO g_gsa[l_ac].aag02_2 FROM aag_file
                    WHERE aag01=g_gsa[l_ac].gsa06
                      AND aag00=g_aza.aza81  #No.FUN-740029 add aag00
                   SELECT aag02 INTO g_gsa[l_ac].aag02_5 FROM aag_file                                                                
                    WHERE aag01=g_gsa[l_ac].gsa061
                      AND aag00=g_aza.aza82  #No.FUN-740029 add aag00
                   #-----No.FUN-590111 END-----
#FUN-680088-end
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i600_set_entry(p_cmd)                                          
            CALL i600_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end     
            INITIALIZE g_gsa[l_ac].* TO NULL      #900423
            LET g_gsa[l_ac].gsaacti = 'Y'       #Body default
            LET g_gsa_t.* = g_gsa[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gsa01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
              #CLOSE i600_bcl                                                   
              #CALL g_gsa.deleteElement(l_ac)                                   
              #IF g_rec_b != 0 THEN                                             
              #   LET g_action_choice = "detail"                                
              #   LET l_ac = l_ac_t                                             
              #END IF                                                           
              #EXIT INPUT
            END IF
            INSERT INTO gsa_file(gsa01,gsa02,gsa04,gsa041,gsa05,gsa051,gsa06,gsa061,               #No.FUN-590111 #FUN-680088
                                 gsaacti,gsauser,gsadate,gsaoriu,gsaorig)
            VALUES(g_gsa[l_ac].gsa01,g_gsa[l_ac].gsa02,g_gsa[l_ac].gsa04,g_gsa[l_ac].gsa041,                 #FUN-680088
                   g_gsa[l_ac].gsa05,g_gsa[l_ac].gsa051,g_gsa[l_ac].gsa06,g_gsa[l_ac].gsa061,      #No.FUN-590111 #FUN-680088
                   g_gsa[l_ac].gsaacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gsa[l_ac].gsa01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","gsa_file",g_gsa[l_ac].gsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_gsa[l_ac].* = g_gsa_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD gsa01                        #check 編號是否重複
            IF g_gsa[l_ac].gsa01 != g_gsa_t.gsa01 OR
               (g_gsa[l_ac].gsa01 IS NOT NULL AND g_gsa_t.gsa01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM gsa_file
                    WHERE gsa01 = g_gsa[l_ac].gsa01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gsa[l_ac].gsa01 = g_gsa_t.gsa01
                    NEXT FIELD gsa01
                END IF
            END IF

        AFTER FIELD gsa04
           IF NOT cl_null(g_gsa[l_ac].gsa04) THEN   #No.FUN-590111
              SELECT COUNT(*) INTO l_n FROM aag_file
               WHERE aag01=g_gsa[l_ac].gsa04
                 AND aag00=g_aza.aza81  #No.FUN-740029 add aag00     
              IF l_n >0 THEN             
                 SELECT aag02 INTO g_gsa[l_ac].aag02 FROM aag_file
                  WHERE aag01=g_gsa[l_ac].gsa04 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza81  #No.FUN-740029 add aag00  #FUN-680088
#FUN-680088--begin
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gsa[l_ac].gsa04,"agl-015",0)  #No.FUN-590111
                    NEXT FIELD gsa04
                 END IF
#FUN-680088--end
              ELSE
                 CALL cl_err(g_gsa[l_ac].gsa04,"mfg0018",0)  #No.FUN-590111
#FUN-B10052 --begin--
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' AND aag03 = '2' " 
                   ," AND aag01 LIKE '",g_gsa[l_ac].gsa04 CLIPPED,"%'"
                    LET g_qryparam.construct = 'N'                                               
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa04
                    LET g_qryparam.arg1 = g_aza.aza81   
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa04
                    SELECT aag02 INTO g_gsa[l_ac].aag02
                      FROM aag_file
                     WHERE aag01=g_gsa[l_ac].gsa04
                       AND aag00=g_aza.aza81   
                     DISPLAY BY NAME g_gsa[l_ac].gsa04         
                     DISPLAY BY NAME g_gsa[l_ac].aag02         
#FUN-B10052 --end--                 
                  NEXT FIELD gsa04
              END IF
           END IF
#FUN-680088--begin
        AFTER FIELD gsa041                                                                                                           
           IF NOT cl_null(g_gsa[l_ac].gsa041) THEN                                                                  
              SELECT COUNT(*) INTO l_n FROM aag_file                                                                                
               WHERE aag01=g_gsa[l_ac].gsa041 
                 AND aag00=g_aza.aza82  #No.FUN-740029 add aag00                                                                                       
              IF l_n >0 THEN                                                     
                 SELECT aag02 INTO g_gsa[l_ac].aag02_3 FROM aag_file                                                                  
                  WHERE aag01=g_gsa[l_ac].gsa041 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza82  #No.FUN-740029 add aag00
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err(g_gsa[l_ac].gsa041,"agl-015",0)  #No.FUN-590111                                                      
                    NEXT FIELD gsa041                                                                                                
                 END IF                                         
              ELSE                                                                                                                  
                 CALL cl_err(g_gsa[l_ac].gsa041,"mfg0018",0)                                                       
#FUN-B10052 --begin--                                                                                   
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' AND aag03 ='2'"
                   ," AND aag01 LIKE '",g_gsa[l_ac].gsa041 CLIPPED,"%'"  
                    LET g_qryparam.construct = 'N'
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa041
                    LET g_qryparam.arg1 = g_aza.aza82   
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa041                                                                
                    SELECT aag02 INTO g_gsa[l_ac].aag02_3                                                                                 
                      FROM aag_file                                                                                                   
                     WHERE aag01=g_gsa[l_ac].gsa041 
                       AND aag00=g_aza.aza82      
                     DISPLAY BY NAME g_gsa[l_ac].gsa041     
                     DISPLAY BY NAME g_gsa[l_ac].aag02_3                      
#FUN-B10052 --end--                 
                 NEXT FIELD gsa041                                                                                                   
              END IF                                                                                                                
           END IF        
#FUN-680088--end
 
        #-----No.FUN-590111-----
        AFTER FIELD gsa05
           IF NOT cl_null(g_gsa[l_ac].gsa05) THEN
              SELECT COUNT(*) INTO l_n FROM aag_file
               WHERE aag01=g_gsa[l_ac].gsa05
                 AND aag00=g_aza.aza81  #No.FUN-740029 add aag00 
              IF l_n >0 THEN
                 SELECT aag02 INTO g_gsa[l_ac].aag02_1 FROM aag_file
                  WHERE aag01=g_gsa[l_ac].gsa05 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza81  #No.FUN-740029 add aag00  #FUN-680088
#FUN-680088--begin                             
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err(g_gsa[l_ac].gsa05,"agl-015",0)  #No.FUN-590111                                                      
                    NEXT FIELD gsa05                                                                                                
                 END IF 
#FUN-680088--end                                                                                      
              ELSE
                 CALL cl_err(g_gsa[l_ac].gsa05,"mfg0018",0)
#FUN-B10052 --begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = " aag07 MATCHES '[23]' "  
                 ," AND aag03 = '2' AND aag01 LIKE '",g_gsa[l_ac].gsa05 CLIPPED,"%'"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_gsa[l_ac].gsa05
                 LET g_qryparam.arg1 = g_aza.aza81    
                 CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa05
                 SELECT aag02 INTO g_gsa[l_ac].aag02_1
                   FROM aag_file
                  WHERE aag01=g_gsa[l_ac].gsa05
                    AND aag00=g_aza.aza81   
                  DISPLAY BY NAME g_gsa[l_ac].gsa05,g_gsa[l_ac].aag02_1
#FUN-B10052 --end--                 
                 NEXT FIELD gsa05
              END IF
           END IF
           
#FUN-680088--begin
        AFTER FIELD gsa051                                                                                                           
           IF NOT cl_null(g_gsa[l_ac].gsa051) THEN   #No.FUN-590111                                                                  
              SELECT COUNT(*) INTO l_n FROM aag_file                                                                                
               WHERE aag01=g_gsa[l_ac].gsa051 
                 AND aag00=g_aza.aza82  #No.FUN-740029 add aag00                                                                              
              IF l_n >0 THEN                                                                             
                 SELECT aag02 INTO g_gsa[l_ac].aag02_4 FROM aag_file                                                                  
                  WHERE aag01=g_gsa[l_ac].gsa051 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza82  #No.FUN-740029 add aag00                         
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err(g_gsa[l_ac].gsa051,"agl-015",0)  #No.FUN-590111                                                      
                    NEXT FIELD gsa051                                                                                                
                 END IF                                                                                                 
              ELSE                 	                                                                                                               
                 CALL cl_err(g_gsa[l_ac].gsa051,"mfg0018",0)  #No.FUN-590111                                                         
#FUN-B10052 --begin--
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag" 
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "     
                   ," AND aag03 = '2' AND aag01 LIKE '",g_gsa[l_ac].gsa051 CLIPPED,"%' "
                    LET g_qryparam.construct = 'N'                                 
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa051    
                    LET g_qryparam.arg1 = g_aza.aza82   
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa051                                                                
                    SELECT aag02 INTO g_gsa[l_ac].aag02_4                                                                           
                      FROM aag_file                                                                                                 
                     WHERE aag01=g_gsa[l_ac].gsa051   
                       AND aag00=g_aza.aza82          
                    DISPLAY BY NAME g_gsa[l_ac].gsa051,g_gsa[l_ac].aag02_4                 
#FUN-B10052 --end--                 
                 NEXT FIELD gsa051                                                                                                   
              END IF                                                                                                                
           END IF     
#FUN-680088--end

        AFTER FIELD gsa06
           IF NOT cl_null(g_gsa[l_ac].gsa06) THEN
              SELECT COUNT(*) INTO l_n FROM aag_file
               WHERE aag01=g_gsa[l_ac].gsa06 
                 AND aag00=g_aza.aza81  #No.FUN-740029 add aag00  
              IF l_n >0 THEN
                 SELECT aag02 INTO g_gsa[l_ac].aag02_2 FROM aag_file
                  WHERE aag01=g_gsa[l_ac].gsa06 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza81  #No.FUN-740029 add aag00 #FUN-680088                             
#FUN-680088--begin                                                                                                                  
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err(g_gsa[l_ac].gsa06,"agl-015",0)  #No.FUN-590111                                                      
                    NEXT FIELD gsa06                                                                                                
                 END IF                                                                                                             
#FUN-680088--end       
              ELSE
                 CALL cl_err(g_gsa[l_ac].gsa06,"mfg0018",0)
#FUN-B10052 --begin--
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "  
                   ," AND aag03 = '2' AND aag01 LIKE '",g_gsa[l_ac].gsa06 CLIPPED,"%' "
                    LET g_qryparam.construct = 'N'                          
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa06
                    LET g_qryparam.arg1 = g_aza.aza81   
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa06
                    SELECT aag02 INTO g_gsa[l_ac].aag02_2
                      FROM aag_file
                     WHERE aag01=g_gsa[l_ac].gsa06
                       AND aag00=g_aza.aza81   
                    DISPLAY BY NAME g_gsa[l_ac].gsa06,g_gsa[l_ac].aag02_2
#FUN-B10052 --end--                 
                 NEXT FIELD gsa06
              END IF
           END IF
#FUN-680088--begin
        AFTER FIELD gsa061                                                                                                           
           IF NOT cl_null(g_gsa[l_ac].gsa061) THEN   #No.FUN-590111                                                                  
              SELECT COUNT(*) INTO l_n FROM aag_file                                                                                
               WHERE aag01=g_gsa[l_ac].gsa061 
                 AND aag00=g_aza.aza82  #No.FUN-740029 add aag00                                                                                    
              IF l_n >0 THEN                                               
                 SELECT aag02 INTO g_gsa[l_ac].aag02_5 FROM aag_file                                                                  
                  WHERE aag01=g_gsa[l_ac].gsa061 AND aag03='2' AND (aag07='2' OR aag07='3') AND aag00=g_aza.aza81  #No.FUN-740029 add aag00                        
                 IF SQLCA.sqlcode THEN                                                                                              
                    CALL cl_err(g_gsa[l_ac].gsa061,"agl-015",0)  #No.FUN-590111                                                      
                    NEXT FIELD gsa061                                                                                                
                 END IF                                                                                                  
              ELSE                                                                                                                  
                 CALL cl_err(g_gsa[l_ac].gsa061,"mfg0018",0)  #No.FUN-590111                                                         
#FUN-B10052 --begin--                                                                                             
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "                            
                   ," AND aag03 = '2' AND aag01 LIKE '",g_gsa[l_ac].gsa061 CLIPPED,"%' "
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa061    
                    LET g_qryparam.arg1 = g_aza.aza82                                                           
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa061                                                                
                    SELECT aag02 INTO g_gsa[l_ac].aag02_5  
                      FROM aag_file       
                     WHERE aag01=g_gsa[l_ac].gsa061
                       AND aag00=g_aza.aza82    
                    DISPLAY BY NAME g_gsa[l_ac].gsa061,g_gsa[l_ac].aag02_5 
#FUN-B10052 --end--                 
                 NEXT FIELD gsa061                                                                                                   
              END IF                                                                                                                
           END IF     
#FUN-680088--end
        #-----No.FUN-590111 END-----
 
        BEFORE DELETE                            #是否取消單身
            IF g_gsa_t.gsa01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM gsa_file WHERE gsa01 = g_gsa_t.gsa01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_gsa_t.gsa01,SQLCA.sqlcode,0)   #No.FUN-660148
                   CALL cl_err3("del","gsa_file",g_gsa_t.gsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i600_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gsa[l_ac].* = g_gsa_t.*
               CLOSE i600_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_gsa[l_ac].gsa01,-263,1)                            
             LET g_gsa[l_ac].* = g_gsa_t.*                                      
          ELSE                                      
             UPDATE gsa_file SET gsa01  = g_gsa[l_ac].gsa01,
                                 gsa02  = g_gsa[l_ac].gsa02,
                                 gsa04  = g_gsa[l_ac].gsa04,
                                 gsa041 = g_gsa[l_ac].gsa041,    #FUN-680088
                                 gsa05  = g_gsa[l_ac].gsa05,     #No.FUN-590111
                                 gsa051 = g_gsa[l_ac].gsa051,    #FUN-680088
                                 gsa06  = g_gsa[l_ac].gsa06,     #No.FUN-590111
                                 gsa061 = g_gsa[l_ac].gsa061,    #FUN-680088
                                 gsaacti = g_gsa[l_ac].gsaacti,  
                                 gsamodu = g_user,
                                 gsadate = g_today
                        WHERE gsa01=g_gsa_t.gsa01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gsa[l_ac].gsa01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","gsa_file",g_gsa_t.gsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_gsa[l_ac].* = g_gsa_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i600_bcl         
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gsa[l_ac].* = g_gsa_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_gsa.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE i600_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
           END IF
          #LET g_gsa_t.* = g_gsa[l_ac].*          # 900423
           LET l_ac_t = l_ac        
           CLOSE i600_bcl          
           COMMIT WORK  
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(gsa04)
#               CALL q_aag(10,3,g_gsa[l_ac].gsa04,'','','') 
#                   RETURNING g_gsa[l_ac].gsa04
#               CALL FGL_DIALOG_SETBUFFER( g_gsa[l_ac].gsa04 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "                      
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa04
                    LET g_qryparam.arg1 = g_aza.aza81    #No.FUN-740049           
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa04
#                   CALL FGL_DIALOG_SETBUFFER( g_gsa[l_ac].gsa04 )
                SELECT aag02 INTO g_gsa[l_ac].aag02
                    FROM aag_file
                    WHERE aag01=g_gsa[l_ac].gsa04
                      AND aag00=g_aza.aza81   #	No.FUN-740049
                     DISPLAY BY NAME g_gsa[l_ac].gsa04         #No.MOD-490344
                     DISPLAY BY NAME g_gsa[l_ac].aag02         #No.MOD-490344
                    NEXT FIELD gsa04
#FUN-680088--begin
                WHEN INFIELD(gsa041)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "                                                                                                     
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa041
                    LET g_qryparam.arg1 = g_aza.aza82    #No.FUN-740049                                                                     
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa041                                                                
                SELECT aag02 INTO g_gsa[l_ac].aag02_3                                                                                 
                    FROM aag_file                                                                                                   
                    WHERE aag01=g_gsa[l_ac].gsa041 
                      AND aag00=g_aza.aza82   # No.FUN-740049                                                                                   
                     DISPLAY BY NAME g_gsa[l_ac].gsa041         #No.MOD-490344                                                       
                     DISPLAY BY NAME g_gsa[l_ac].aag02_3        #No.MOD-490344                                                       
                    NEXT FIELD gsa041                      
#FUN-680088--end
                #-----No.FUN-590111-----
                WHEN INFIELD(gsa05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "  #FUN-680088
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa05
                    LET g_qryparam.arg1 = g_aza.aza81    #No.FUN-740049
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa05
                    SELECT aag02 INTO g_gsa[l_ac].aag02_1
                      FROM aag_file
                     WHERE aag01=g_gsa[l_ac].gsa05
                       AND aag00=g_aza.aza81   # No.FUN-740049
                    DISPLAY BY NAME g_gsa[l_ac].gsa05,g_gsa[l_ac].aag02_1
                    NEXT FIELD gsa05
#FUN-680088--begin
                WHEN INFIELD(gsa051)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag" 
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "                                                                                                   
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa051    
                    LET g_qryparam.arg1 = g_aza.aza82    #No.FUN-740049                                                                 
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa051                                                                
                    SELECT aag02 INTO g_gsa[l_ac].aag02_4                                                                           
                      FROM aag_file                                                                                                 
                     WHERE aag01=g_gsa[l_ac].gsa051   
                       AND aag00=g_aza.aza82   # No.FUN-740049                                                                               
                    DISPLAY BY NAME g_gsa[l_ac].gsa051,g_gsa[l_ac].aag02_4                                                           
                    NEXT FIELD gsa051 
#FUN-680088--end--
                WHEN INFIELD(gsa06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "    #FUN-680088                
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa06
                    LET g_qryparam.arg1 = g_aza.aza81    #No.FUN-740049
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa06
                    SELECT aag02 INTO g_gsa[l_ac].aag02_2
                      FROM aag_file
                     WHERE aag01=g_gsa[l_ac].gsa06
                       AND aag00=g_aza.aza81   # No.FUN-740049     
                    DISPLAY BY NAME g_gsa[l_ac].gsa06,g_gsa[l_ac].aag02_2
                    NEXT FIELD gsa06
                #-----No.FUN-590111 END-----
#FUN-680088--begin
                WHEN INFIELD(gsa061)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.where = " aag07 MATCHES '[23]' "                                                                  
                    LET g_qryparam.default1 = g_gsa[l_ac].gsa061    
                    LET g_qryparam.arg1 = g_aza.aza82    #No.FUN-740049                                                                 
                    CALL cl_create_qry() RETURNING g_gsa[l_ac].gsa061                                                                
                    SELECT aag02 INTO g_gsa[l_ac].aag02_5                                                                           
                      FROM aag_file                                                                                                 
                     WHERE aag01=g_gsa[l_ac].gsa061
                       AND aag00=g_aza.aza82   # No.FUN-740049                                                                                  
                    DISPLAY BY NAME g_gsa[l_ac].gsa061,g_gsa[l_ac].aag02_5                                                           
                    NEXT FIELD gsa061 
#FUN-680088--end
            END CASE
                
        ON ACTION CONTROLN
            CALL i600_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gsa01) AND l_ac > 1 THEN
                LET g_gsa[l_ac].* = g_gsa[l_ac-1].*
                NEXT FIELD gsa01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
    END INPUT
 
    CLOSE i600_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_b_askkey()
 
   CLEAR FORM
   CALL g_gsa.clear()
 
   CONSTRUCT g_wc ON gsa01,gsa02,gsa04,gsa041,gsa05,gsa051,gsa06,gsa061,gsaacti   #No.FUN-590111 #FUN-680088
            FROM s_gsa[1].gsa01,s_gsa[1].gsa02,s_gsa[1].gsa04,s_gsa[1].gsa041,    #FUN-680088
                 s_gsa[1].gsa05,s_gsa[1].gsa051, s_gsa[1].gsa06,s_gsa[1].gsa061,  #No.FUN-590111 #FUN-680088
                 s_gsa[1].gsaacti  #No.FUN-590111
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
                WHEN INFIELD(gsa04)
#               CALL q_aag(10,3,g_gsa[1].gsa04,'','','') 
#                   RETURNING g_gsa[1].gsa04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_gsa[1].gsa04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa04
                    NEXT FIELD gsa04
#FUN-680088--begin
                WHEN INFIELD(gsa041)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.default1 = g_gsa[1].gsa041                                                                        
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa041                                                                   
                    NEXT FIELD gsa041    
#FUN-680088--end 
                #-----No.FUN-590111-----
                WHEN INFIELD(gsa05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_gsa[1].gsa05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa05
                    NEXT FIELD gsa05
#FUN-680088--begin
                WHEN INFIELD(gsa051)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.default1 = g_gsa[1].gsa051                                                                        
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa051                                                                   
                    NEXT FIELD gsa051 
#FUN-680088--end
                   
                WHEN INFIELD(gsa06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_gsa[1].gsa06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa06
                    NEXT FIELD gsa06
                #-----No.FUN-590111 END-----
#FUN-680088--begin
                WHEN INFIELD(gsa061)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_aag"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.default1 = g_gsa[1].gsa061                                                                        
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO s_gsa[1].gsa061                                                                   
                    NEXT FIELD gsa061     
#FUN-680088--end
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gsauser', 'gsagrup') #FUN-980030
                
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i600_b_fill(g_wc)
END FUNCTION
 
FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2  LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(200)
 
    LET g_sql = "SELECT gsa01,gsa02,gsa04,'',gsa041,'',gsa05,'',gsa051,'',gsa06,'',gsa061,'',gsaacti ",   #No:590111 #FUN-680088
                " FROM gsa_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    PREPARE i600_pb FROM g_sql
    DECLARE gsa_curs CURSOR FOR i600_pb
 
    CALL g_gsa.clear()   #No.FUN-590111
    LET g_cnt = 1
    MESSAGE "Searching!" 
 
    FOREACH gsa_curs INTO g_gsa[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
 
       SELECT aag02 INTO g_gsa[g_cnt].aag02 FROM aag_file 
        WHERE aag01=g_gsa[g_cnt].gsa04
          AND aag00=g_aza.aza81   # No.FUN-740049
       SELECT aag02 INTO g_gsa[g_cnt].aag02_3 FROM aag_file      #FUN-680088                                                                   
        WHERE aag01=g_gsa[g_cnt].gsa041                          #FUN-680088 
          AND aag00=g_aza.aza82   #No.FUN-740049         
       #-----No.FUN-590111-----
       SELECT aag02 INTO g_gsa[g_cnt].aag02_1 FROM aag_file
        WHERE aag01=g_gsa[g_cnt].gsa05
          AND aag00=g_aza.aza81   # No.FUN-740049
       SELECT aag02 INTO g_gsa[g_cnt].aag02_4 FROM aag_file      #FUN-680088                                                                   
        WHERE aag01=g_gsa[g_cnt].gsa051                          #FUN-680088
          AND aag00=g_aza.aza82    #No.FUN-740049   #No.TQC-740093
       SELECT aag02 INTO g_gsa[g_cnt].aag02_2 FROM aag_file
        WHERE aag01=g_gsa[g_cnt].gsa06
          AND aag00=g_aza.aza81   # No.FUN-740049
       #-----No.FUN-590111 END-----
       SELECT aag02 INTO g_gsa[g_cnt].aag02_5 FROM aag_file      #FUN-680088                                                                   
        WHERE aag01=g_gsa[g_cnt].gsa061                          #FUN-680088
         AND aag00=g_aza.aza82   # No.FUN-740049
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gsa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gsa TO s_gsa.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
                                                                                
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#NO.FUN-7C0043 --BEGIN MARK--
FUNCTION i600_out()
#    DEFINE
#        l_gsa           RECORD LIKE gsa_file.*,
#
#        l_i             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
#        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#        l_za05          LIKE za_file.za05       #No.FUN-680107 VARCHAR(40)
     DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-7C0043                                                           
     IF cl_null(g_wc) AND NOT cl_null(g_gsa[l_ac].gsa01) THEN                                                                       
        LET g_wc= " gsa01 ='",g_gsa[l_ac].gsa01,"'"                                                                                 
     END IF                                                                                                                         
     IF cl_null(g_wc) THEN                                                                                                          
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
     END IF                                                                                                                         
     LET l_cmd = 'p_query "anmi600" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN                                                                                                                         
                                                           
#   
#    IF g_wc IS NULL THEN 
#       CALL cl_err('','9057',0) RETURN END IF
##      CALL cl_err('',-400,0) RETURN END IF
#   CALL cl_wait()
#   LET l_name = 'anmi600.out'
#   CALL cl_outnam('anmi600') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM gsa_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED
#   PREPARE i600_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i600_co CURSOR FOR i600_p1
 
#   START REPORT i600_rep TO l_name
 
#   FOREACH i600_co INTO l_gsa.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i600_rep(l_gsa.*)
#   END FOREACH
 
#   FINISH REPORT i600_rep
 
#   CLOSE i600_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i600_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,   #NO.FUN-680107 VARCHAR(1)
#       sr RECORD       LIKE gsa_file.*,
#       l_chr           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#       l_p_aag02       LIKE aag_file.aag02,
#       l_p_aag02_1     LIKE aag_file.aag02,   #No.FUN-590111
#       l_p_aag02_2     LIKE aag_file.aag02    #No.FUN-590111
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   #No.MOD-580242
 
#   ORDER BY sr.gsa01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED   #No.FUN-590111
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.gsaacti = 'N' THEN PRINT '*'; END IF
#           SELECT aag02 INTO l_p_aag02 FROM aag_file
#            WHERE aag01=sr.gsa04      
#              AND aag00=g_aza.aza81    # No.FUN-740049  
#          #-----No.FUN-590111-----
#          SELECT aag02 INTO l_p_aag02_1 FROM aag_file
#           WHERE aag01=sr.gsa05
#             AND aag00=g_aza.aza81    # No.FUN-740049
#          SELECT aag02 INTO l_p_aag02_2 FROM aag_file
#           WHERE aag01=sr.gsa06
#             AND aag00=g_aza.aza81    # No.FUN-740049
#          #-----No.FUN-590111-----
#          PRINT COLUMN g_c[31],sr.gsa01,
#                COLUMN g_c[32],sr.gsa02,
#                COLUMN g_c[33],sr.gsa04,
#                COLUMN g_c[34],l_p_aag02,
#                COLUMN g_c[35],sr.gsa05,   #No.FUN-590111
#                COLUMN g_c[36],l_p_aag02_1,#No.FUN-590111
#                COLUMN g_c[37],sr.gsa06,   #No.FUN-590111
#                COLUMN g_c[38],l_p_aag02_2 #No.FUN-590111
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#           END IF
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043 --END MARK--
 
#No.FUN-570108 --start                                                          
FUNCTION i600_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("gsa01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i600_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("gsa01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end                 
