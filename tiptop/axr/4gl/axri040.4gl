# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axri040.4gl
# Descriptions...: 應收科目類別維護
# Date & Author..: 96/01/26 By Apple 
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0100 05/01/05 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/08/15 By zhuying 多套帳修改                                                                                                                                                                    
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-710066 07/01/18 By wujie 改正兩套帳錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730073 07/03/30 By dxfwo  會計科目加帳套 
# Modify.........: No.TQC-740093 07/04/17 By mike   會計科目加帳套
# Modify.........: No.TQC-740135 07/04/24 By arman 不能打印，點“打印”，顯示無資料
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.TQC-810074 08/01/23 By chenl   將查詢sql語句改寫成sql92標准。
# Modify.........: No.FUN-810099 08/04/10 By destiny p_query新增功能修改
# Modify.........: No.FUN-960141 09/06/22 By dongbg GP5.2修改:ooc01不能輸入[ABCDFQ]
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50186 10/05/28 By sabrina 科目輸入時應不輸入統制科目
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-C90092 12/09/19 By minpp Z类型不可维护
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ooc           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ooc01       LIKE ooc_file.ooc01,    
        ooc02       LIKE ooc_file.ooc02,    
        ooc03       LIKE ooc_file.ooc03,
#No.TQC-710066--begin
#       ooc04       LIKE ooc_file.ooc04,     #FUN-670047      
#       aag02       LIKE aag_file.aag02,
#       aag021      LIKE aag_file.aag02      #FUN-670047
        aag02       LIKE aag_file.aag02,
        ooc04       LIKE ooc_file.ooc04,     
        aag021      LIKE aag_file.aag02 
#No.TQC-710066--end
                    END RECORD,
    g_ooc_t         RECORD                 #程式變數 (舊值)
        ooc01       LIKE ooc_file.ooc01,    
        ooc02       LIKE ooc_file.ooc02,    
        ooc03       LIKE ooc_file.ooc03,
#No.TQC-710066--begin
#       ooc04       LIKE ooc_file.ooc04,     #FUN-670047      
#       aag02       LIKE aag_file.aag02,
#       aag021      LIKE aag_file.aag02      #FUN-670047
        aag02       LIKE aag_file.aag02,
        ooc04       LIKE ooc_file.ooc04,     
        aag021      LIKE aag_file.aag02 
#No.TQC-710066--end
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680123 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680123 SMALLINT               #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680123 INTEGER   
DEFINE   g_i             LIKE type_file.num5     #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   g_before_input_done  LIKE type_file.num5     #No.FUN-680123  SMALLINT   #No.FUN-570108  
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0095
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680123 SMALLINT
    
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i040_w AT p_row,p_col WITH FORM "axr/42f/axri040"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    #No.FUN-670047--begin
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("ooc04,aag021",TRUE)
    ELSE
       CALL cl_set_comp_visible("ooc04,aag021",FALSE)
    END IF
    #No.FUN-670047--end  
 
    LET g_wc2 = '1=1' CALL i040_b_fill(g_wc2)
    CALL i040_menu()
    CLOSE WINDOW i040_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
FUNCTION i040_menu()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043
 
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i040_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
#No.FUN-810099-begin--mark--
#No.FUN-7C0043--start-- 
#               CALL i040_out()
#               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF      
#               IF g_aza.aza63 = 'Y' THEN
#                  LET l_cmd = 'p_query "axri040" "',g_wc2 CLIPPED,'" "',g_aza.aza81,'"'
#               ELSE 
#                  LET l_cmd = 'p_query "axri040_1" "',g_aza.aza81,'" "',g_wc2 CLIPPED,'" "',g_aza.aza82,'"'   
#               END IF
#               CALL cl_cmdrun(l_cmd)                                 
                CALL i040_out()
#No.FUN-7C0043--end--         
#No.FUN-810099--end--
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ooc),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i040_q()
   CALL i040_b_askkey()
END FUNCTION
 
FUNCTION i040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #No.FUN-680123 SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,     #No.FUN-680123 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(01), 
    l_allow_delete  LIKE type_file.chr1      #No.FUN-680123 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ooc01, ooc02, ooc03, ooc04 FROM ooc_file ",       #FUN-670047
                       " WHERE ooc01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_ooc WITHOUT DEFAULTS FROM s_ooc.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac) 
          END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3   #FUN-670047 
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEn
               LET g_ooc_t.* = g_ooc[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570108 --start--                                                        
               LET g_before_input_done = FALSE                                  
               CALL i040_set_entry(p_cmd)                                       
               CALL i040_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570108 --end--           
              BEGIN WORK
               OPEN i040_bcl USING g_ooc_t.ooc01
               IF STATUS THEN
                  CALL cl_err("OPEN i040_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i040_bcl INTO g_ooc[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ooc_t.ooc01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i040_ooc03('d')
                  CALL i040_ooc04('d') #No.FUN-670047
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                     
            CALL i040_set_entry(p_cmd)                                          
            CALL i040_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end--      
            INITIALIZE g_ooc[l_ac].* TO NULL      #900423
            LET g_ooc_t.* = g_ooc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ooc01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ooc_file(ooc01,ooc02,ooc03,ooc04)      #FUN-670047
         VALUES(g_ooc[l_ac].ooc01,g_ooc[l_ac].ooc02,
                g_ooc[l_ac].ooc03,g_ooc[l_ac].ooc04)        #FUN-670047     
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_ooc[l_ac].ooc01,SQLCA.sqlcode,0)   #No.FUN-660116
             CALL cl_err3("ins","ooc_file",g_ooc[l_ac].ooc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD ooc01                     #check 編號是否重複
           IF g_ooc[l_ac].ooc01 IS NOT NULL THEN 
              IF g_ooc[l_ac].ooc01 != g_ooc_t.ooc01 OR
                (NOT cl_null(g_ooc[l_ac].ooc01)
                 AND cl_null(g_ooc_t.ooc01)) THEN
                 SELECT count(*) INTO l_n FROM ooc_file
                  WHERE ooc01 = g_ooc[l_ac].ooc01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ooc[l_ac].ooc01 = g_ooc_t.ooc01
                    NEXT FIELD ooc01
                 END IF
                #No.+314 010629 by linda add
                 IF g_ooc[l_ac].ooc01 MATCHES '[0-9]' THEN
                    LET g_ooc[l_ac].ooc01=g_ooc_t.ooc01
                    CALL cl_err(g_ooc[l_ac].ooc01,'axr-062',0)
                    NEXT FIELD ooc01 
                 END IF
                #No.+314 ..end
                #FUN-960141 add begin
                 IF g_ooc[l_ac].ooc01 MATCHES '[ABCDEFQZ]' THEN   #FUN-C90092 add--Z
                    LET g_ooc[l_ac].ooc01=g_ooc_t.ooc01
                    CALL cl_err(g_ooc[l_ac].ooc01,'axr-511',0)
                    NEXT FIELD ooc01
                 END IF
                #FUN-960141 add end
              END IF
           END IF
 
        AFTER FIELD ooc03  #科目編號
            IF NOT cl_null(g_ooc[l_ac].ooc01) THEN
               IF NOT cl_null(g_ooc[l_ac].ooc03) THEN  #No.FUN-670047
                  CALL i040_ooc03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                    #Mod No.FUN-B10048
                    #LET g_ooc[l_ac].ooc03 = g_ooc_t.ooc03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ='q_aag'
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073
                     LET g_qryparam.default1 = g_ooc[l_ac].ooc03
                     LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' AND aag01 LIKE '",g_ooc[l_ac].ooc03 CLIPPED,"%'"
                     CALL cl_create_qry() RETURNING g_ooc[l_ac].ooc03
                     DISPLAY BY NAME g_ooc[l_ac].ooc03
                    #End Mod No.FUN-B10048
                     NEXT FIELD ooc03
                  END IF
               END IF  #No.FUN-670047
            END IF
 
        #No.FUN-670047--begin
        AFTER FIELD ooc04
            IF NOT cl_null(g_ooc[l_ac].ooc01) THEN
               IF NOT cl_null(g_ooc[l_ac].ooc04) THEN 
                  CALL i040_ooc04('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                    #Mod No.FUN-B10048
                    #LET g_ooc[l_ac].ooc04 = g_ooc_t.ooc04
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_aag'
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.arg1 = g_aza.aza82    #No.FUN-730073
                     LET g_qryparam.default1 = g_ooc[l_ac].ooc04
                     LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' AND aag01 LIKE '",g_ooc[l_ac].ooc04 CLIPPED,"%'"
                     CALL cl_create_qry() RETURNING g_ooc[l_ac].ooc04
                     DISPLAY BY NAME g_ooc[l_ac].ooc04
                    #End Mod No.FUN-B10048
                     NEXT FIELD ooc04
                  END IF
               END IF 
            END IF
        #No.FUN-670047--end  
 
        BEFORE DELETE                            #是否取消單身
            IF g_ooc_t.ooc01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ooc_file WHERE ooc01 = g_ooc_t.ooc01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ooc_t.ooc01,SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("del","ooc_file",g_ooc_t.ooc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i040_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ooc[l_ac].* = g_ooc_t.*
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ooc[l_ac].ooc01,-263,1)
              LET g_ooc[l_ac].* = g_ooc_t.*
           ELSE
              UPDATE ooc_file
              SET ooc01=g_ooc[l_ac].ooc01,ooc02=g_ooc[l_ac].ooc02,
                  ooc03=g_ooc[l_ac].ooc03,ooc04=g_ooc[l_ac].ooc04   #FUN-670047
              WHERE ooc01=g_ooc_t.ooc01 
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ooc[l_ac].ooc01,SQLCA.sqlcode,0)   #No.FUN-660116
                  CALL cl_err3("upd","ooc_file",g_ooc_t.ooc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                  LET g_ooc[l_ac].* = g_ooc_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_ooc[l_ac].* = g_ooc_t.*                                    
               #FUN-D30032--add--str--
               ELSE
                  CALL g_ooc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i040_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i040_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i040_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ooc01) AND l_ac > 1 THEN
                LET g_ooc[l_ac].* = g_ooc[l_ac-1].*
                NEXT FIELD ooc01
            END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ooc03)      #查詢科目代號不為統制帳戶'1'
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_aag'
                    LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073
                    LET g_qryparam.default1 = g_ooc[l_ac].ooc03
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                    CALL cl_create_qry() RETURNING g_ooc[l_ac].ooc03
#                    CALL FGL_DIALOG_SETBUFFER(g_ooc[l_ac].ooc03 )
                    DISPLAY BY NAME g_ooc[l_ac].ooc03
                    CALL i040_ooc03('d')
                    NEXT FIELD ooc03
          #FUn-670047----------------begin
               WHEN INFIELD(ooc04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_aag'
                    LET g_qryparam.arg1 = g_aza.aza82    #No.FUN-730073
                    LET g_qryparam.default1 = g_ooc[l_ac].ooc04   
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                    CALL cl_create_qry() RETURNING g_ooc[l_ac].ooc04
                    DISPLAY BY NAME g_ooc[l_ac].ooc04
                    CALL i040_ooc04('d')
                    NEXT FIELD ooc04
          #FUN-670047----------------end
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
 
    CLOSE i040_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i040_ooc03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1),
    l_aagacti       LIKE aag_file.aagacti,
    l_aag07         LIKE aag_file.aag07      #MOD-A50186 add
 
    LET g_errno = ' '
    LET l_aag07 = NULL                               #MOD-A50186 add
    SELECT aag02,aagacti,aag07                      #MOD-A50186 add aag07
        INTO g_ooc[l_ac].aag02,l_aagacti,l_aag07    #MOD-A50186 add l_aag07
        FROM aag_file  
        WHERE aag01 = g_ooc[l_ac].ooc03
          AND aag00 = g_aza.aza81        #No.FUN-730073 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-001'
                            LET g_ooc[l_ac].aag02 = NULL
         WHEN l_aagacti='N' LET g_errno = '9028'
         WHEN l_aag07='1'   LET g_errno = 'agl-131'             #MOD-A50186 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#FUN-670047------------------begin
FUNCTION i040_ooc04(p_cmd)
DEFINE
    p_cmd         LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1),
    l_aagacti     LIKE aag_file.aagacti,
    l_aag07       LIKE aag_file.aag07      #MOD-A50186 add
 
    LET g_errno = ' '
    LET l_aag07 = NULL                               #MOD-A50186 add
    SELECT aag02,aagacti,aag07                      #MOD-A50186 add aag07
      INTO g_ooc[l_ac].aag021,l_aagacti,l_aag07    #MOD-A50186 add l_aag07
      FROM aag_file
     WHERE aag01 = g_ooc[l_ac].ooc04
       AND aag00 = g_aza.aza82        #No.FUN-730073 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-001'
                                   LET g_ooc[l_ac].aag021 = NULL
         WHEN l_aagacti='N'        LET g_errno = '9028'
         WHEN l_aag07='1'   LET g_errno = 'agl-131'             #MOD-A50186 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#FUN-670047------------------end
 
FUNCTION i040_b_askkey()
    CLEAR FORM
    CALL g_ooc.clear()
    CONSTRUCT g_wc2 ON ooc01,ooc02,ooc03,ooc04                 #FUN-670047
            FROM s_ooc[1].ooc01,s_ooc[1].ooc02,s_ooc[1].ooc03,s_ooc[1].ooc04     #FUN-670047     
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(ooc03)      #查詢科目代號不為統制帳戶'1'
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_aag'
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_ooc[1].ooc03
                    NEXT FIELD ooc03
                    CALL i040_ooc03('d')
      #FUN-670047-----------------------begin
              WHEN INFIELD(ooc04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_aag'
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_ooc[1].ooc04
                    NEXT FIELD ooc04
                    CALL i040_ooc04('d')
      #FUN-670047-----------------------end
 
              OTHERWISE
                 EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i040_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000  #No.FUN-680123  VARCHAR(200)
 
    LET g_sql =
#No.TQC-710066--begin
#       "SELECT ooc01,ooc02,ooc03,ooc04,aag02,'' ",    #FUN-670047
        "SELECT ooc01,ooc02,ooc03,aag02,ooc04,'' ", 
#No.TQC-710066--end
       #No.TQC-810074--begin-- modify
       #" FROM ooc_file,OUTER aag_file",
       #" WHERE ooc03 = aag_file.aag01 AND aag00 = '",g_aza.aza81,"' AND ", p_wc2 CLIPPED,   #FUN-670047    #No.FUN-730073 #TQC-740093
       #" ORDER BY 1 "
       
        " FROM ooc_file LEFT OUTER JOIN aag_file",
        " ON ooc03 = aag_file.aag01 AND aag00 = '",g_aza.aza81,"' WHERE ", p_wc2 CLIPPED,   #FUN-670047    #No.FUN-730073 #TQC-740093
        " ORDER BY ooc01 "
       #No.TQC-810074---end--- modify
        
    PREPARE i040_pb FROM g_sql
    DECLARE ooc_curs CURSOR FOR i040_pb
 
    CALL g_ooc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ooc_curs INTO g_ooc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        #No.FUN-670047 --begin
        SELECT aag02 INTO g_ooc[g_cnt].aag021 
        FROM aag_file WHERE aag01 = g_ooc[g_cnt].ooc04  
                        AND aag00 = g_aza.aza82          #No.FUN-730073            
        DISPLAY g_ooc[g_cnt].aag021 TO FORMONLY.aag021
        #No.FUN-670047 --end
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_ooc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1     #No.FUN-680123 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooc TO s_ooc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-810099-begin--
#No.FUN-7C0043--start--
FUNCTION i040_out()
#    DEFINE
#       l_ooc           RECORD LIKE ooc_file.*,
#       l_aag02         LIKE aag_file.aag02,
#       l_i             LIKE type_file.num5,     #No.FUN-680123 SMALLINT,
#       l_name          LIKE type_file.chr20,    #No.FUN-680123 VARCHAR(20),                # External(Disk) file name
#       l_za05          LIKE za_file.za05        #No.FUN-680123 VARCHAR(40)                 #
     DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-810099  
   IF g_wc2 IS NULL THEN 
#   #   CALL cl_err('',-400,0)
      CALL cl_err('','9057',0)
   RETURN END IF
   LET l_cmd = 'p_query "axri040" "',g_aza.aza81,'" "',g_wc2 CLIPPED,'" "',g_aza.aza82,'"'
   CALL cl_cmdrun(l_cmd)                                                                                                           
   RETURN 
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT ooc_file.*,aag02 ",       
#             " FROM ooc_file,OUTER aag_file ",          # 組合出 SQL 指令
#              " WHERE ooc03 = aag_file.aag01 AND aag00 = '",g_aza.aza81,"'AND", g_wc2 CLIPPED      #No.FUN-730073 #No.TQC-740135
#              " WHERE ooc03 = aag_file.aag01 AND aag00 = '",g_aza.aza81,"'AND ", g_wc2 CLIPPED      #No.TQC-740135
#   PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i040_co                         # SCROLL CURSOR
#        CURSOR FOR i040_p1
#   ALL cl_outnam('axri040') RETURNING l_name
 
#   #No.FUN-670047--begin
#   IF g_aza.aza63 = 'Y' THEN
#      LET g_zaa[35].zaa06 = "N"
#      LET g_zaa[36].zaa06 = "N"
#   ELSE
#      LET g_zaa[35].zaa06 = "Y"
#      LET g_zaa[36].zaa06 = "Y"
#   END IF
#   CALL cl_prt_pos_len()
#   #No.FUN-670047--end  
 
#   START REPORT i040_rep TO l_name
 
#   FOREACH i040_co INTO l_ooc.*,l_aag02
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i040_rep(l_ooc.*,l_aag02)
#   END FOREACH
 
#   FINISH REPORT i040_rep
 
#   CLOSE i040_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-810099--end--
#REPORT i040_rep(sr,l_aag02)
#   DEFINE
#       l_trailer_sw  LIKE type_file.chr1,     #No.FUN-680123  VARCHAR(1),
#       g_head1       STRING,
#       sr RECORD     LIKE ooc_file.*,
#       l_aag021      LIKE aag_file.aag02,     #No.FUN-670047
#       l_aag02       LIKE aag_file.aag02
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ooc01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#         # PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]  #FUN-670047 #No.TQC-6A0087
#           PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]  #No.TQC-6A0087
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           #No.FUN-670046--begin
#           SELECT aag02 INTO l_aag021 FROM aag_file
#            WHERE aag01 = sr.ooc04
#              AND aag00 = g_aza.aza82  #No.FUN-730073 
#           #No.FUN-670046--end  
#          #PRINT D1 COLUMN g_c[31],sr.ooc01,  #No.TQC-6A0087
#           PRINTX name = D1 COLUMN g_c[31],sr.ooc01,#No.TQC-6A0087
#                 COLUMN g_c[32],sr.ooc02 CLIPPED,#No.TQC-6A0087 add CLIPPED
#                 COLUMN g_c[33],sr.ooc03 CLIPPED,#No.TQC-6A0087 add CLIPPED
#                 COLUMN g_c[34],l_aag02  CLIPPED,#No.TQC-6A0087 add CLIPPED
#                 #No.FUN-670046--begin
#                 COLUMN g_c[35],sr.ooc04 CLIPPED,
#                 COLUMN g_c[36],l_aag021 CLIPPED
#                 LET l_aag021 = ''
#                 #No.FUN-670046--end  
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
#No.FUN-570108 --start--                                                        
FUNCTION i040_set_entry(p_cmd)                                                  
  DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680123  VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ooc01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i040_set_no_entry(p_cmd)                                               
  DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680123  VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ooc01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--                
