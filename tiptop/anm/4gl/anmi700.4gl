# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi700.4gl
# Descriptions...: 融資/長貸類別維護作業
# Date & Author..: 98/11/16    BY BILLY
# Modify.........: No.7997 03/10/15 By Kitty 加上Help說明功能
# Modify.........: No.8935 03/12/17 By Kitty 加上nni07,nni03的不可輸入2
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/29 By flowld 兩套帳ANM追加規格部分
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0072 06/11/23 By Smapmin 計暫估利息於報表顯示時應顯示中文
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/16 By hongmei 會計科目加帳套
# Modify.........: No.MOD-740305 07/04/23 By Carrier OUTER時,加TABLE NAME
# Modify.........: No.FUN-790050 07/09/06 By Carrier _out()轉p_query實現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nnn           DYNAMIC ARRAY OF RECORD 
        nnn01       LIKE nnn_file.nnn01,
        nnn02       LIKE nnn_file.nnn02,
        nnn06       LIKE nnn_file.nnn06,
        nnn03       LIKE nnn_file.nnn03,
        nnn07       LIKE nnn_file.nnn07,    #No:8935
        nnn04       LIKE nnn_file.nnn04,
        aag02       LIKE aag_file.aag02,
        nnn041      LIKE nnn_file.nnn041,   # No.FUN-680088
        aag021      LIKE aag_file.aag02,    # No.FUN-680088
        nnn05       LIKE nnn_file.nnn05,
        nnnacti     LIKE nnn_file.nnnacti   # NO.FUN-680107 VARCHAR(1) 
                    END RECORD,
    g_nnn_t         RECORD 
        nnn01       LIKE nnn_file.nnn01,
        nnn02       LIKE nnn_file.nnn02,
        nnn06       LIKE nnn_file.nnn06,
        nnn03       LIKE nnn_file.nnn03,
        nnn07       LIKE nnn_file.nnn07,    #No:8935
        nnn04       LIKE nnn_file.nnn04,
        aag02       LIKE aag_file.aag02,
        nnn041      LIKE nnn_file.nnn041,   # No.FUN-680088
        aag021      LIKE aag_file.aag02,    # No.FUN-680088                                     
        nnn05       LIKE nnn_file.nnn05,
        nnnacti     LIKE nnn_file.nnnacti   # NO.FUN-680107 VARCHAR(1) 
                    END RECORD,       
    g_dbs_gl        LIKE type_file.chr21,   #NO.FUN-680107 VARCHAR(21)
    g_plant_gl      LIKE type_file.chr10,   #NO.FUN-980025 VARCHAR(10)
    g_wc2,g_sql     STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680107       VARCHAR(80)
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL    
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000            #No.FUN-790050
DEFINE g_before_input_done   LIKE type_file.num5      #FUN-570108         #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-680107  SMALLINT 
 
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
   LET p_row = 4 LET p_col = 4
    OPEN WINDOW i700_w AT p_row,p_col WITH FORM "anm/42f/anmi700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("nnn041,aag021",g_aza.aza63='Y')   # No.FUN-680088 
 
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl =  g_nmz.nmz02p  #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
    LET g_wc2 = '1=1' CALL i700_b_fill(g_wc2)
    CALL i700_menu()
    CLOSE WINDOW i700_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i700_menu()
 
   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i700_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i700_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "anmi700" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"          #No.7997
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i700_q()
   CALL i700_b_askkey()
END FUNCTION
 
FUNCTION i700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-680107 VARCHAR(1)                 
    l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-680107 VARCHAR(1)                 
 
    LET g_action_choice = ""                                                    
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nnn01,nnn02,nnn06,nnn03,nnn07,nnn04,'',nnn041,'',nnn05,nnnacti ", #No:8935 add nnn07    # No.FUN-6800088  add nnn041
                       " FROM nnn_file WHERE nnn01= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nnn WITHOUT DEFAULTS FROM s_nnn.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)                                           
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_nnn_t.* = g_nnn[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
            IF g_rec_b >=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_nnn_t.* = g_nnn[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
               LET g_before_input_done = FALSE                                 
               CALL i700_set_entry(p_cmd)                                      
               CALL i700_set_no_entry(p_cmd)                                   
               LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end             
 
               OPEN i700_bcl USING g_nnn_t.nnn01
               IF STATUS THEN
                  CALL cl_err("OPEN i700_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i700_bcl INTO g_nnn[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_nnn_t.nnn01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT aag02 INTO g_nnn[l_ac].aag02 FROM aag_file
                   WHERE g_nnn[l_ac].nnn04 = aag01
                     AND aag00 = g_aza.aza81       #No.FUN-740028
# No.FUN-680088 --start--
                  SELECT aag02 INTO g_nnn[l_ac].aag021 FROM aag_file
                   WHERE g_nnn[l_ac].nnn041 = aag01 
                     AND aag00 = g_aza.aza82       #No.FUN-740028
# No.FUN-680088 ---end---             
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD nnn01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i700_set_entry(p_cmd)                                          
            CALL i700_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end            
            INITIALIZE g_nnn[l_ac].* TO NULL      #900423
            LET g_nnn[l_ac].nnnacti = 'Y'       #Body default
            LET g_nnn[l_ac].nnn05 = 'Y'         #Body default
            LET g_nnn[l_ac].nnn07 = 'Y'         #Body default #No:8935
            LET g_nnn_t.* = g_nnn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD nnn01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
              #CLOSE i700_bcl                                                   
              #CALL g_nnn.deleteElement(l_ac)                                   
              #IF g_rec_b != 0 THEN                                             
              #   LET g_action_choice = "detail"                                
              #   LET l_ac = l_ac_t                                             
              #END IF                                                           
              #EXIT INPUT
            END IF
            INSERT INTO nnn_file(nnn01,nnn02,nnn03,nnn04,nnn041,nnn05,   # No.FUN-680088  add  nnn041
                                 nnn06,nnn07,nnnacti,nnnuser,nnndate,nnnoriu,nnnorig) #No:8935 add nnn07
            VALUES(g_nnn[l_ac].nnn01,g_nnn[l_ac].nnn02,
                   g_nnn[l_ac].nnn03, g_nnn[l_ac].nnn04,g_nnn[l_ac].nnn041,     # No.FUN-680088  add g_nnn[l_ac].nnn041
                   g_nnn[l_ac].nnn05,g_nnn[l_ac].nnn06,g_nnn[l_ac].nnn07, #No:8935 add nnn07
                   g_nnn[l_ac].nnnacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnn[l_ac].nnn01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","nnn_file",g_nnn[l_ac].nnn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_nnn[l_ac].* = g_nnn_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
                   
        AFTER FIELD nnn01                        #check 編號是否重複
            IF g_nnn[l_ac].nnn01 != g_nnn_t.nnn01 OR
               (g_nnn[l_ac].nnn01 IS NOT NULL AND g_nnn_t.nnn01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM nnn_file
                    WHERE nnn01 = g_nnn[l_ac].nnn01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nnn[l_ac].nnn01 = g_nnn_t.nnn01
                    NEXT FIELD nnn01
                END IF
            END IF
 
        AFTER FIELD nnn06
            IF cl_null(g_nnn[l_ac].nnn06) OR 
               g_nnn[l_ac].nnn06 NOT MATCHES '[1-5]' THEN
               NEXT FIELD nnn06
            END IF
 
        AFTER FIELD nnn03
            IF g_nnn[l_ac].nnn03 NOT MATCHES '[01]' THEN #No:8935 2不要
               NEXT FIELD nnn03 
            END IF

        AFTER FIELD nnn04
            IF NOT cl_null(g_nnn[l_ac].nnn04) THEN  
               CALL i700_nnn04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0) 
#FUN-B20073 --begin--
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nnn[l_ac].nnn04,'23',g_aza.aza81) 
                     RETURNING g_nnn[l_ac].nnn04
                  DISPLAY g_nnn[l_ac].nnn04 TO nnn04                     
                  CALL i700_nnn04('d')                  
#FUN-B20073 --end--                  
                  NEXT FIELD nnn04
               END IF
            END IF
# No.FUN-680088 --start--
        AFTER FIELD nnn041
            IF NOT cl_null(g_nnn[l_ac].nnn041) THEN  
               CALL i700_nnn041('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0) 
#FUN-B20073 --begin--
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nnn[l_ac].nnn041,'23',g_aza.aza82) 
                      RETURNING g_nnn[l_ac].nnn041
                  DISPLAY g_nnn[l_ac].nnn041 TO nnn041
                  CALL i700_nnn041('d')
#FUN-B20073 --end--                  
                  NEXT FIELD nnn041
               END IF
            END IF
# No.FUN-680088 ---end---
        #No:8935
        AFTER FIELD nnn07
            IF g_nnn[l_ac].nnn07   NOT MATCHES '[YN]' OR
               cl_null(g_nnn[l_ac].nnn07  ) THEN
                LET g_nnn[l_ac].nnn07   = g_nnn_t.nnn07
                NEXT FIELD nnn07
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_nnn_t.nnn01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM nnn_file WHERE nnn01 = g_nnn_t.nnn01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nnn_t.nnn01,SQLCA.sqlcode,0)   #No.FUN-660148
                   CALL cl_err3("del","nnn_file",g_nnn_t.nnn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i700_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nnn[l_ac].* = g_nnn_t.*
               CLOSE i700_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nnn[l_ac].nnn01,-263,1)                            
             LET g_nnn[l_ac].* = g_nnn_t.*                                      
          ELSE                                      
             UPDATE nnn_file SET nnn01 = g_nnn[l_ac].nnn01,
                                 nnn02 = g_nnn[l_ac].nnn02,
                                 nnn03 = g_nnn[l_ac].nnn03,
                                 nnn04 = g_nnn[l_ac].nnn04,
                                 nnn041= g_nnn[l_ac].nnn041,     # No.FUN-680088
                                 nnn05 = g_nnn[l_ac].nnn05,
                                 nnn06 = g_nnn[l_ac].nnn06,
                                 nnn07 = g_nnn[l_ac].nnn07, #No:8935
                                 nnnacti = g_nnn[l_ac].nnnacti,
                                 nnnmodu = g_user,
                                 nnndate = g_today
                         WHERE nnn01= g_nnn_t.nnn01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nnn[l_ac].nnn01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nnn_file",g_nnn_t.nnn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nnn[l_ac].* = g_nnn_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i700_bcl         
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nnn[l_ac].* = g_nnn_t.*
           #FUN-D30032--add--str--
             ELSE
                CALL g_nnn.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
           #FUN-D30032--add--end--
             END IF
             CLOSE i700_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
           END IF
          #LET g_nnn_t.* = g_nnn[l_ac].*          # 900423
           LET l_ac_t = l_ac        
           CLOSE i700_bcl          
           COMMIT WORK  
 
        ON ACTION CONTROLN
            CALL i700_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nnn01) AND l_ac > 1 THEN
                LET g_nnn[l_ac].* = g_nnn[l_ac-1].*
                NEXT FIELD nnn01
            END IF
 
       ON ACTION controlp
           CASE 
                WHEN INFIELD(nnn04)
#               CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nnn[l_ac].nnn04,'23',g_aza.aza81)    #No.FUN-740028  #No.FUN-980025
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnn[l_ac].nnn04,'23',g_aza.aza81)  #No.FUN-980025 
                     RETURNING g_nnn[l_ac].nnn04
                DISPLAY g_nnn[l_ac].nnn04 TO nnn04
#               CALL FGL_DIALOG_SETBUFFER(g_nnn[l_ac].nnn04)
                CALL i700_nnn04('d')
# No.FUN-680088 --start--
                WHEN INFIELD(nnn041)
#               CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nnn[l_ac].nnn041,'23',g_aza.aza82)   #No.FUN-740028  #No.FUN-980025
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnn[l_ac].nnn041,'23',g_aza.aza82) #No.FUN-980025
                     RETURNING g_nnn[l_ac].nnn041
                DISPLAY g_nnn[l_ac].nnn041 TO nnn041
                CALL i700_nnn041('d')
# No.FUN-680088 ---end---           
                OTHERWISE
                   EXIT CASE
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
 
    CLOSE i700_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION  i700_nnn04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti
        INTO g_nnn[l_ac].aag02,l_aag03,l_aag07,l_aagacti
        FROM aag_file
        WHERE aag01 = g_nnn[l_ac].nnn04
          AND aag00 = g_aza.aza81    #No.FUN-740028
    CASE WHEN STATUS = 100        LET g_errno = 'agl-001' 
         WHEN l_aagacti = 'N'     LET g_errno = '9028' 
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201' 
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE 
    IF cl_null(g_errno) OR  p_cmd = 'a' THEN
    END IF
END FUNCTION

# No.FUN-680088 --start--
FUNCTION  i700_nnn041(p_cmd1)
DEFINE
    p_cmd1           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
    l_aag021         LIKE aag_file.aag02,
    l_aag031         LIKE aag_file.aag03,
    l_aag071         LIKE aag_file.aag07,
    l_aagacti1       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti
        INTO g_nnn[l_ac].aag021,l_aag031,l_aag071,l_aagacti1
        FROM aag_file
        WHERE aag01 = g_nnn[l_ac].nnn041
          AND aag00 = g_aza.aza82    #No.FUN-740028
    CASE WHEN STATUS = 100        LET g_errno = 'agl-001' 
         WHEN l_aagacti1 = 'N'     LET g_errno = '9028' 
         WHEN l_aag071  = '1'      LET g_errno = 'agl-015' 
         WHEN l_aag031 != '2'      LET g_errno = 'agl-201' 
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE 
    IF cl_null(g_errno) OR  p_cmd1 = 'a' THEN
    END IF
END FUNCTION
# No.FUN-680088 ---end---
   
FUNCTION i700_b_askkey()
    CLEAR FORM
   CALL g_nnn.clear()
    CONSTRUCT g_wc2 ON nnn01,nnn02,nnn03,nnn05,nnn06,nnnacti
            FROM s_nnn[1].nnn01,s_nnn[1].nnn02,s_nnn[1].nnn03,
                 s_nnn[1].nnn05,s_nnn[1].nnn06,s_nnn[1].nnnacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION controlp
           CASE 
                WHEN INFIELD(nnn04)
#               CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nnn[1].nnn04,'23',g_aza.aza81)   #No.FUN-740028   #No.FUN-980025
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnn[1].nnn04,'23',g_aza.aza81) #No.FUN-980025 
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO nnn04
# No.FUN-680088 --start--
                WHEN INFIELD(nnn041)
#               CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nnn[1].nnn041,'23',g_aza.aza82)  #No.FUN-740028  #No.FUN-980025
                CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnn[1].nnn041,'23',g_aza.aza82)#No.FUN-980025 
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO nnn041 
# No.FUN-680088 ---end---          
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('nnnuser', 'nnngrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i700_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680107  VARCHAR(200)
 
    LET g_sql =
        "SELECT nnn01,nnn02,nnn06,nnn03,nnn07,nnn04,aag02,nnn041,'',nnn05,nnnacti", #No:8935 add nnn07     # No.FUN-680088  add nnn041
        " FROM nnn_file LEFT OUTER JOIN aag_file",
        " ON nnn04 = aag01 AND aag00 = '",g_aza.aza81,"'",             #No.MOD-740305
        " WHERE ",p_wc2 clipped,
   #    " AND aag00 = '",g_aza.aza81,"'",    #No.FUN-740028
        " ORDER BY nnn01"                    #No.MOD-740305
    PREPARE i700_pb FROM g_sql
    DECLARE nnn_curs CURSOR FOR i700_pb
    CALL g_nnn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH nnn_curs INTO g_nnn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
# No.FUN-680088 --start--
     SELECT aag02 INTO g_nnn[g_cnt].aag021 FROM aag_file  
       WHERE g_nnn[g_cnt].nnn041 = aag01
         AND aag00 = g_aza.aza82      #No.FUN-740028
# No.FUN-680088 ---end---        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nnn.deleteElement(g_cnt)                                   
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnn TO s_nnn.* ATTRIBUTE(COUNT=g_rec_b) 
 
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
      ON ACTION help   #No.7997
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
#FUNCTION i700_out()
#    DEFINE
#        l_nnn           RECORD LIKE nnn_file.*,
#        l_i             LIKE type_file.num5,     #No.FUN-680107 SMALLINT
#        l_name          LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#        l_za05          LIKE za_file.za05       
#   
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#      RETURN
#    END IF
#    CALL cl_wait()
#    LET l_name = 'anmi700.out'
#    CALL cl_outnam('anmi700') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM nnn_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i700_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i700_co CURSOR FOR i700_p1
#    START REPORT i700_rep TO l_name
#
#    FOREACH i700_co INTO l_nnn.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i700_rep(l_nnn.*)
#    END FOREACH
#
#    FINISH REPORT i700_rep
#
#    CLOSE i700_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#   
#REPORT i700_rep(sr)
#    DEFINE
#        l_trailer_sw  LIKE type_file.chr1,    #NO.FUN-680107 VARCHAR(1)
#        sr            RECORD LIKE nnn_file.*
#    DEFINE l_nnn03 LIKE type_file.chr4   #FUN-6B0072
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.nnn01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#          #-----FUN-6B0072---------
#          LET l_nnn03 = ''
#          IF sr.nnn03 = 0 THEN LET l_nnn03 = g_x[9] END IF
#          IF sr.nnn03 = 1 THEN LET l_nnn03 = g_x[10] END IF
#          #-----END FUN-6B0072-----
#          IF sr.nnnacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#          PRINT COLUMN g_c[32],sr.nnn01,
#                COLUMN g_c[33],sr.nnn02,
#                #COLUMN g_c[34],sr.nnn03   #FUN-6B0072
#                COLUMN g_c[34],l_nnn03   #FUN-6B0072
#          {CASE 
#            WHEN sr.nnn03='0'  PRINT COLUMN 39,g_x[12] CLIPPED
#            WHEN sr.nnn03='1'  PRINT COLUMN 39,g_x[13] CLIPPED
#           #WHEN sr.nnn03='2'  PRINT COLUMN 39,g_x[14] CLIPPED #No:8935
#            OTHERWISE          PRINT '    '
#          END CASE}
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
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
FUNCTION i700_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nnn01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i700_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nnn01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end                                                            
