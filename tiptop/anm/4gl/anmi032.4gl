# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi032.4gl
# Descriptions...: 銀行存提異動碼(FM)
# Date & Author..: 
# Modify         : Nick 94/12/1 modified to Muti-Line 
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制   
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/15 By ice 兩套帳功能修改 
# Modify.........: No.FUN-680107 06/09/07 By Hellen欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740028 07/04/12 By arman 會計科目加帳套
# Modify.........: No.FUN-790050 07/09/05 By Carrier _out()轉p_query實現
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:TQC-9C0070 09/12/10 By Carrier 科目二检查错误
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-C30875 12/03/28 By Polly 增加檢核若nmc01存在nme03時，不可異動nmc03
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nmc         DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        nmc01       LIKE nmc_file.nmc01,   #銀行存提異動碼
        nmc02       LIKE nmc_file.nmc02,   #異動碼名稱
        nmc03       LIKE nmc_file.nmc03,   #存提別
        nmc04       LIKE nmc_file.nmc04,   #預設對方科目
        nmc041      LIKE nmc_file.nmc041,  #預設對方科目二   #No.FUN-680034
        nmc05       LIKE nmc_file.nmc05,   #預設現金變動碼
        nmcacti     LIKE nmc_file.nmcacti  #No.FUN-680107 VARCHAR(1) 
                    END RECORD,
    g_nmc_t         RECORD                 #程式變數 (舊值)
        nmc01       LIKE nmc_file.nmc01,   #銀行存提異動碼
        nmc02       LIKE nmc_file.nmc02,   #異動碼名稱
        nmc03       LIKE nmc_file.nmc03,   #存提別
        nmc04       LIKE nmc_file.nmc04,   #預設對方科目
        nmc041      LIKE nmc_file.nmc041,  #預設對方科目二   #No.FUN-680034
        nmc05       LIKE nmc_file.nmc05,   #預設現金變動碼
        nmcacti     LIKE nmc_file.nmcacti  #No.FUN-680107 VARCHAR(1) 
                    END RECORD,
    g_dbs_gl        LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl      LIKE type_file.chr10,  #No.FUN-980025 VARCHAR(10)
    g_wc,g_sql      STRING,                #TQC-630166
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #FUN-570108 #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
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
    OPEN WINDOW i032_w AT p_row,p_col 
         WITH FORM "anm/42f/anmi032"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #No.FUN-680034 --Begin
    CALL cl_set_comp_visible("nmc041",g_aza.aza63='Y')
    #No.FUN-680034 --End
 
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl  = g_nmz.nmz02p #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new 
    LET g_wc = '1=1' CALL i032_b_fill(g_wc)
    CALL i032_menu()
    CLOSE WINDOW i032_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i032_menu()
 
   WHILE TRUE
      CALL i032_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i032_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i032_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i032_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi032" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i032_q()
   CALL i032_b_askkey()
END FUNCTION
 
FUNCTION i032_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否    #No.FUN-680107 VARCHAR(1)                        
    l_allow_delete  LIKE type_file.num5    #可刪除否    #No.FUN-680107 VARCHAR(1)                        
DEFINE l_cnt           LIKE type_file.num10   #MOD-C30875
                                                                                
    LET g_action_choice = ""                                                    
    IF s_anmshut(0) THEN RETURN END IF                                          
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT nmc01,nmc02,nmc03,nmc04,nmc041,nmc05,nmcacti ",   #No.FUN-680034
                       "  FROM nmc_file ",
                       " WHERE nmc01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i032_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nmc WITHOUT DEFAULTS FROM s_nmc.*
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
           #LET g_nmc_t.* = g_nmc[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_nmc_t.nmc01 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_nmc_t.* = g_nmc[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i032_set_entry(p_cmd)                                      
                CALL i032_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end               
                BEGIN WORK
                OPEN i032_bcl USING g_nmc_t.nmc01
                IF STATUS THEN
                   CALL cl_err("OPEN i032_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i032_bcl INTO g_nmc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_nmc_t.nmc01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD nmc01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i032_set_entry(p_cmd)                                          
            CALL i032_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end         
            INITIALIZE g_nmc[l_ac].* TO NULL      #900423
            LET g_nmc_t.* = g_nmc[l_ac].*         #新輸入資料
            LET g_nmc[l_ac].nmcacti = 'Y'       #Body default
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD nmc01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT
             # CLOSE i032_bcl                                                   
             # CALL g_nmc.deleteElement(l_ac)                                   
             # IF g_rec_b != 0 THEN                                             
             #    LET g_action_choice = "detail"                                
             #    LET l_ac = l_ac_t                                             
             # END IF                                                           
             # EXIT INPUT                                                       
            END IF                 
            INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmc04,nmc041,nmc05,    #No.FUN-680034
                                 nmcacti,nmcuser,nmcdate,nmcoriu,nmcorig)
                          VALUES(g_nmc[l_ac].nmc01,g_nmc[l_ac].nmc02,
                                 g_nmc[l_ac].nmc03,g_nmc[l_ac].nmc04,g_nmc[l_ac].nmc041,   #No.FUN-680034
                                 g_nmc[l_ac].nmc05,g_nmc[l_ac].nmcacti, 
                                 g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nmc[l_ac].nmc01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","nmc_file",g_nmc[l_ac].nmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_nmc[l_ac].* = g_nmc_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD nmc01                        #check 編號是否重複
            IF NOT cl_null(g_nmc[l_ac].nmc01) THEN
               IF g_nmc[l_ac].nmc01 != g_nmc_t.nmc01 OR
                 (g_nmc[l_ac].nmc01 IS NOT NULL AND g_nmc_t.nmc01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM nmc_file
                   WHERE nmc01 = g_nmc[l_ac].nmc01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_nmc[l_ac].nmc01 = g_nmc_t.nmc01
                     NEXT FIELD nmc01
                  END IF
               END IF
            END IF
 
        AFTER FIELD nmc03
	    IF g_nmc[l_ac].nmc03 NOT MATCHES '[12]' THEN
               LET g_nmc[l_ac].nmc03 = g_nmc_t.nmc03
               NEXT FIELD nmc03
            END IF
           #--------------------MOD-C30875-----------------(S)
            IF g_nmc[l_ac].nmc03 <> g_nmc_t.nmc03 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM nme_file
                WHERE nme03 = g_nmc[l_ac].nmc01
               IF l_cnt > 0 THEN
                  CALL cl_err('','anm-170',0)
                  LET g_nmc[l_ac].nmc03 = g_nmc_t.nmc03
                  NEXT FIELD nmc03
               END IF
            END IF
           #--------------------MOD-C30875-----------------(E)
 
       AFTER FIELD nmc04
           IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmc[l_ac].nmc04) THEN
       #       CALL s_m_aag(g_dbs_gl,g_nmc[l_ac].nmc04,g_aza.aza81) RETURNING g_msg   #FUN-990069                   #NO.FUN-740028
              CALL s_m_aag(g_nmz.nmz02p,g_nmc[l_ac].nmc04,g_aza.aza81) RETURNING g_msg   #FUN-990069 
              IF NOT cl_null(g_errno) THEN
                 CALL  cl_err(g_nmc[l_ac].nmc04,'anm-001',0)
#FUN-B20073 --begin--                 
#                 LET g_nmc[l_ac].nmc04 = g_nmc_t.nmc04
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmc[l_ac].nmc04,'23',g_aza.aza81)                     
                       RETURNING g_nmc[l_ac].nmc04
                  DISPLAY BY NAME g_nmc[l_ac].nmc04                     
#FUN-B20073 --end--
                 NEXT FIELD nmc04
              END IF
           END IF

       #No.FUN-680034 --Begin
       AFTER FIELD nmc041
           IF g_nmz.nmz02 = 'Y' AND NOT cl_null(g_nmc[l_ac].nmc041) THEN
  #            CALL s_m_aag(g_dbs_gl,g_nmc[l_ac].nmc041,g_aza.aza81) RETURNING g_msg  #FUN-990069                  #NO.FUN-740028
              CALL s_m_aag(g_nmz.nmz02p,g_nmc[l_ac].nmc041,g_aza.aza82) RETURNING g_msg  #FUN-990069   #No.TQC-9C0070
              IF NOT cl_null(g_errno) THEN
                 CALL  cl_err(g_nmc[l_ac].nmc041,'anm-001',0)
#FUN-B20073 --begin--                 
#                LET g_nmc[l_ac].nmc041 = g_nmc_t.nmc041
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmc[l_ac].nmc041,'23',g_aza.aza82)     
                      RETURNING g_nmc[l_ac].nmc041
                 DISPLAY BY NAME g_nmc[l_ac].nmc041  
#FUN-B20073 --end--                 
                 NEXT FIELD nmc041
              END IF
           END IF
       #No.FUN-680034 --End
 
       AFTER FIELD nmc05
           IF NOT cl_null(g_nmc[l_ac].nmc05) THEN 
              SELECT nml02 FROM nml_file WHERE nml01 =g_nmc[l_ac].nmc05
                                           AND nmlacti = 'Y'
              IF SQLCA.sqlcode THEN
#                CALL  cl_err(g_nmc[l_ac].nmc05,'anm-140',0) #No.FUN-660148
                 CALL cl_err3("sel","nml_file",g_nmc[l_ac].nmc05,"","anm-140","","",1)  #No.FUN-660148
                 LET g_nmc[l_ac].nmc05 = g_nmc_t.nmc05
                 NEXT FIELD nmc05
              END IF
           END IF
 
       AFTER FIELD nmcacti
          IF g_nmc[l_ac].nmcacti NOT MATCHES '[YN]' 
            OR cl_null(g_nmc[l_ac].nmcacti) THEN
            LET g_nmc[l_ac].nmcacti = g_nmc_t.nmcacti
            NEXT FIELD nmcacti
         END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_nmc_t.nmc01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM nmc_file WHERE nmc01 = g_nmc_t.nmc01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nmc_t.nmc01,SQLCA.sqlcode,0) #No.FUN-660148
                   CALL cl_err3("del","nmc_file",g_nmc_t.nmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i032_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                                                      
             CALL cl_err('',9001,0)                                             
             LET INT_FLAG = 0                                                   
             LET g_nmc[l_ac].* = g_nmc_t.*                                      
             CLOSE i032_bcl                                                     
             ROLLBACK WORK                                                      
             EXIT INPUT                                                         
          END IF                                                                
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nmc[l_ac].nmc01,-263,1)                            
             LET g_nmc[l_ac].* = g_nmc_t.*                                      
          ELSE                                      
             UPDATE nmc_file SET nmc01 = g_nmc[l_ac].nmc01,
                                 nmc02 = g_nmc[l_ac].nmc02,
                                 nmc03 = g_nmc[l_ac].nmc03,
                                 nmc04 = g_nmc[l_ac].nmc04,
                                 nmc041= g_nmc[l_ac].nmc041,   #No.FUN-680034
                                 nmc05 = g_nmc[l_ac].nmc05,
                                 nmcacti = g_nmc[l_ac].nmcacti,
                                 nmcmodu = g_user,
                                 nmcdate = g_today
                           WHERE nmc01= g_nmc_t.nmc01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nmc[l_ac].nmc01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nmc_file",g_nmc_t.nmc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nmc[l_ac].* = g_nmc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i032_bcl         
             END IF
          END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()  
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nmc[l_ac].* = g_nmc_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_nmc.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--  
             END IF
             CLOSE i032_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
          END IF
         #LET g_nmc_t.* = g_nmc[l_ac].*          # 900423
          LET l_ac_t = l_ac                                                     
          CLOSE i032_bcl                                                        
          COMMIT WORK   
 
       ON ACTION CONTROLN
           CALL i032_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nmc01) AND l_ac > 1 THEN
                LET g_nmc[l_ac].* = g_nmc[l_ac-1].*
                NEXT FIELD nmc01
            END IF
 
        ON ACTION controlp           
            CASE
                WHEN INFIELD(nmc04)  
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nmc[l_ac].nmc04,'23',g_aza.aza81)              #NO.FUN-740028
#                      RETURNING g_nmc[l_ac].nmc04
#                  CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc04 )
#                 CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmc[l_ac].nmc04,'23',g_aza.aza81)         #NO.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmc[l_ac].nmc04,'23',g_aza.aza81)       #No.FUN-980025
                       RETURNING g_nmc[l_ac].nmc04
#                  CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc04 )
                   DISPLAY BY NAME g_nmc[l_ac].nmc04              #No.MOD-490344
                  NEXT FIELD nmc04
                #No.FUN-680034 --Begin
                WHEN INFIELD(nmc041)  
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nmc[l_ac].nmc041,'23',g_aza.aza82)             #NO.FUN-740028
#                      RETURNING g_nmc[l_ac].nmc041
#                  CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc041 )
#                 CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nmc[l_ac].nmc041,'23',g_aza.aza82)        #NO.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmc[l_ac].nmc041,'23',g_aza.aza82)      #No.FUN-980025 
                       RETURNING g_nmc[l_ac].nmc041
#                  CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc041 )
                   DISPLAY BY NAME g_nmc[l_ac].nmc041              #No.MOD-490344
                  NEXT FIELD nmc041
                #No.FUN-680034 --End
                WHEN INFIELD(nmc05)  
#                 CALL q_nml(10,3,g_nmc[l_ac].nmc05) 
#                      RETURNING g_nmc[l_ac].nmc05
#                 CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc05 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nmc[l_ac].nmc05
                  CALL cl_create_qry() RETURNING g_nmc[l_ac].nmc05
                   DISPLAY BY NAME g_nmc[l_ac].nmc05              #No.MOD-490344
#                  CALL FGL_DIALOG_SETBUFFER( g_nmc[l_ac].nmc05 )
                  NEXT FIELD nmc05
                OTHERWISE EXIT CASE
            END CASE
 
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
 
    CLOSE i032_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i032_b_askkey()
    CLEAR FORM
    CALL g_nmc.clear()
    CONSTRUCT g_wc ON nmc01,nmc02,nmc03,nmc04,nmc041,nmc05,nmcacti    #No.FUN-680034
            FROM s_nmc[1].nmc01,s_nmc[1].nmc02,s_nmc[1].nmc03,
				s_nmc[1].nmc04,s_nmc[1].nmc041,       #No.FUN-680034
                                s_nmc[1].nmc05,s_nmc[1].nmcacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp           
            CASE
                WHEN INFIELD(nmc04)  
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nmc[1].nmc04,'23')
#                      RETURNING g_nmc[1].nmc04
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nmc[1].nmc04,'23',g_aza.aza81)          #NO.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmc[1].nmc04,'23',g_aza.aza81)        #No.FUN-980025 
                       RETURNING g_nmc[1].nmc04
                   DISPLAY g_nmc[1].nmc04 TO nmc04          #No.MOD-490344
                  NEXT FIELD nmc04
                #No.FUN-680034  --Begin
                WHEN INFIELD(nmc041)  
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nmc[1].nmc041,'23')
#                      RETURNING g_nmc[1].nmc041
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nmc[1].nmc041,'23',g_aza.aza82)         #NO.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmc[1].nmc041,'23',g_aza.aza82)       #No.FUN-980025 
                       RETURNING g_nmc[1].nmc041
                   DISPLAY g_nmc[1].nmc041 TO nmc041         #No.MOD-490344
                  NEXT FIELD nmc041
                #No.FUN-680034  --End
                WHEN INFIELD(nmc05)  
#                 CALL q_nml(10,3,g_nmc[1].nmc05) 
#                      RETURNING g_nmc[1].nmc05
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nmc[1].nmc05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_nmc[1].nmc05
                  NEXT FIELD nmc05
                OTHERWISE EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmcuser', 'nmcgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i032_b_fill(g_wc)
END FUNCTION
 
FUNCTION i032_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
        "SELECT nmc01,nmc02,nmc03,nmc04,nmc041,nmc05,nmcacti",   #No.FUN-680034
        " FROM nmc_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i032_pb FROM g_sql
    DECLARE nmc_curs CURSOR FOR i032_pb
 
    CALL g_nmc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH nmc_curs INTO g_nmc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nmc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i032_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmc TO s_nmc.*  ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
 
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
 
#No.FUN-790050  --Begin
#FUNCTION i032_out()
#    DEFINE
#        l_nmc           RECORD LIKE nmc_file.*,
#        l_i             LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#        l_name          LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#        l_za05          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(40)
#   
#    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('anmi032') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM nmc_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE i032_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i032_co CURSOR FOR i032_p1
#
#    START REPORT i032_rep TO l_name
#
#    FOREACH i032_co INTO l_nmc.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i032_rep(l_nmc.*)
#    END FOREACH
#
#    FINISH REPORT i032_rep
#
#    CLOSE i032_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i032_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#        sr             RECORD LIKE nmc_file.*,
#        l_chr          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.nmc01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.nmcacti = 'N' THEN PRINT '*'; END IF
##No.TQC-6A0110 -- begin --
##            PRINT COLUMN g_c[31],sr.nmc01,
##                  COLUMN g_c[32],sr.nmc02,
##                  COLUMN g_c[33],sr.nmc03,
##                  COLUMN g_c[34],sr.nmc04,
##                  COLUMN g_c[35],sr.nmc05,
##                  COLUMN g_c[36],sr.nmcacti
#           IF sr.nmc03 = '1' THEN                                               
#              PRINT COLUMN g_c[31],sr.nmc01,                                    
#                    COLUMN g_c[32],sr.nmc02,                                    
#                    COLUMN g_c[33],sr.nmc03,'.',g_x[9] CLIPPED,                 
#                    COLUMN g_c[34],sr.nmc04,                                    
#                    COLUMN g_c[35],sr.nmc05,                                    
#                    COLUMN g_c[36],sr.nmcacti                                   
#           ELSE                                                                 
#              IF sr.nmc03 = '2' THEN                                            
#                 PRINT COLUMN g_c[31],sr.nmc01,                                 
#                       COLUMN g_c[32],sr.nmc02,                                 
#                       COLUMN g_c[33],sr.nmc03,'.',g_x[10] CLIPPED,             
#                       COLUMN g_c[34],sr.nmc04,                                 
#                       COLUMN g_c[35],sr.nmc05,                                 
#                       COLUMN g_c[36],sr.nmcacti                                
#              END IF                                                            
#           END IF
##No.TQC-6A0110 -- end --
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End  
 
#No.FUN-570108 --start                                                          
FUNCTION i032_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nmc01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i032_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nmc01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end    
