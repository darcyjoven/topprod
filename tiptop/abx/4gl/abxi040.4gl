# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: abxi040.4gl
# Descriptions...: 銷售預測資料維護作業
# Date & Author..: 96/08/26 By Star  
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-530025 05/03/17 By kim 報表轉XML功能
# Modify.........: No.FUN-570109 05/07/13 By day   修正建檔程式key值是否可更改
# Modify.........: NO.TQC-5A0064 05/11/25 By yiting zz13設y,按單身不會跳到key的>
#                  新增一筆資料enter跳到下一行時才會到key的第一個欄位
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/07/06 By ve 報表改為使用crystal report
# Modify.........: No.TQC-920062 09/02/20 By destiny bnh03值修改后重查值會變回原來的值的bug
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980269 09/08/27 By lilingyu "數量"欄位對負數沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bnh           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        bnh01       LIKE bnh_file.bnh01,  
        bnh02       LIKE bnh_file.bnh02, 
        bnh03       LIKE bnh_file.bnh03, 
        ima02       LIKE ima_file.ima02, 
        bnh04       LIKE bnh_file.bnh04
                    END RECORD,
    g_bnh_t         RECORD                    #程式變數 (舊值)
        bnh01       LIKE bnh_file.bnh01,  
        bnh02       LIKE bnh_file.bnh02, 
        bnh03       LIKE bnh_file.bnh03, 
        ima02       LIKE ima_file.ima02, 
        bnh04       LIKE bnh_file.bnh04
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN   
     g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680062 SMALLINT
     l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680062 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5      #No.FUN-570109        #No.FUN-680062  SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680062  INTEGER
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0062
 
    OPEN WINDOW i040_w WITH FORM "abx/42f/abxi040"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i040_b_fill(g_wc2)
    CALL i040_menu()
    CLOSE WINDOW i040_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0062
END MAIN
 
FUNCTION i040_menu()
DEFINE l_cmd     STRING                    #FUN-780037
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
               #No.FUN-780037---Begin
               #CALL i040_out()                              
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
               LET l_cmd = 'p_query "abxi040" "',g_wc2 CLIPPED,'"'              
               CALL cl_cmdrun(l_cmd)   
               #No.FUN-780037---End  
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bnh),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i040_q()
   CALL i040_b_askkey()
END FUNCTION
 
FUNCTION i040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT        #No.FUN-680062 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用               #No.FUN-680062 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否               #No.FUN-680062 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態                 #No.FUN-680062 VARCHAR(1)   
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-680062  VARCHAR(01),                                                    #No.FUN-680062 VARCHAR(1)   
    l_allow_delete  LIKE type_file.chr1    #No.FUN-680062  VARCHAR(01)                                                     #No.FUN-680062 VARCHAR(1)   
 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bnh01,bnh02,bnh03,' ',bnh04 FROM bnh_file WHERE bnh01= ? AND bnh02=?  AND bnh03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_bnh WITHOUT DEFAULTS FROM s_bnh.* 
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_bnh_t.bnh01 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bnh_t.* = g_bnh[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
                LET g_before_input_done = FALSE                                                                                     
                CALL i040_set_entry(p_cmd)                                                                                          
                CALL i040_set_no_entry(p_cmd)                                                                                       
                LET g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--       
               BEGIN WORK
               OPEN i040_bcl USING g_bnh_t.bnh01,g_bnh_t.bnh02,g_bnh_t.bnh03
               IF STATUS THEN
                  CALL cl_err("OPEN i040_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i040_bcl INTO g_bnh[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bnh_t.bnh01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT ima02 INTO g_bnh[l_ac].ima02 FROM ima_file 
                   WHERE ima01 = g_bnh[l_ac].bnh03
                  IF cl_null(g_bnh[l_ac].ima02) THEN 
                     LET g_bnh[l_ac].ima02 = '  ' 
                  END IF 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD bnh01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                         
            CALL i040_set_entry(p_cmd)                                                                                              
            CALL i040_set_no_entry(p_cmd)                                                                                           
            LET g_before_input_done = TRUE                                                                                          
#No.FUN-570109 --end--                     
            INITIALIZE g_bnh[l_ac].* TO NULL      #900423
            LET g_bnh_t.* = g_bnh[l_ac].*         #新輸入資料
            LET g_bnh[l_ac].bnh01='1'
            LET g_bnh[l_ac].bnh02=TODAY 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bnh01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO bnh_file(bnh01,bnh02,bnh03,bnh04,
                              bnhplant,bnhlegal) #FUN-980001 add
         VALUES(g_bnh[l_ac].bnh01,g_bnh[l_ac].bnh02,
                g_bnh[l_ac].bnh03,g_bnh[l_ac].bnh04,
                g_plant,g_legal) #FUN-980001 add
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_bnh[l_ac].bnh01,SQLCA.sqlcode,0)  #No.FUN-660052
             CALL cl_err3("ins","bnh_file",g_bnh[l_ac].bnh02,g_bnh[l_ac].bnh03,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD bnh01
            IF NOT cl_null(g_bnh[l_ac].bnh01) THEN
               IF g_bnh[l_ac].bnh01 <>'1' THEN
                  NEXT FIELD bnh01
               END IF 
            END IF 
 
        AFTER FIELD bnh03                        #check 編號是否重複
            IF NOT cl_null(g_bnh[l_ac].bnh03) THEN 
               #FUN-AA0059 ------------------------------add start--------------------------
               IF NOT s_chk_item_no(g_bnh[l_ac].bnh03,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_bnh[l_ac].bnh03 = g_bnh_t.bnh03
                  LET g_bnh[l_ac].ima02 = g_bnh_t.ima02
                  DISPLAY BY NAME g_bnh[l_ac].bnh03
                  NEXT FIELD bnh03
               END IF 
               #FUN-AA0059 ----------------------------add end---------------------------

               IF g_bnh_t.bnh03 IS NULL OR 
                    (g_bnh[l_ac].bnh03 != g_bnh_t.bnh03 ) THEN
                       CALL i040_bnh03('a')
                       IF NOT cl_null(g_errno) THEN
#                         CALL cl_err(g_bnh[l_ac].bnh03,g_errno,0)   #No.FUN-660052
                          CALL cl_err3("sel","ima_file",g_bnh[l_ac].bnh03,"",SQLCA.sqlcode,"","",1)
                          LET g_bnh[l_ac].bnh03 = g_bnh_t.bnh03
                          LET g_bnh[l_ac].ima02 = g_bnh_t.ima02
                          DISPLAY BY NAME g_bnh[l_ac].bnh03
                          NEXT FIELD bnh03
                       END IF
                   END IF
 
           #LET g_bnh_t.bnh03 = g_bnh[l_ac].bnh03       #NO.TQC-920062   by destiny
            IF g_bnh[l_ac].bnh01 != g_bnh_t.bnh01 OR
               g_bnh[l_ac].bnh02 != g_bnh_t.bnh02 OR
               g_bnh[l_ac].bnh03 != g_bnh_t.bnh03 OR
               (g_bnh[l_ac].bnh01 IS NOT NULL AND g_bnh_t.bnh01 IS NULL) OR   
               (g_bnh[l_ac].bnh02 IS NOT NULL AND g_bnh_t.bnh02 IS NULL) OR   
               (g_bnh[l_ac].bnh03 IS NOT NULL AND g_bnh_t.bnh03 IS NULL) THEN
                SELECT count(*) INTO l_n FROM bnh_file
                    WHERE bnh01 = g_bnh[l_ac].bnh01
                      AND bnh02 = g_bnh[l_ac].bnh02
                      AND bnh03 = g_bnh[l_ac].bnh03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bnh[l_ac].bnh01 = g_bnh_t.bnh01
                    LET g_bnh[l_ac].bnh02 = g_bnh_t.bnh02
                    LET g_bnh[l_ac].bnh03 = g_bnh_t.bnh03
                    NEXT FIELD bnh01
                END IF
            END IF
            END IF
 
        AFTER FIELD bnh04
            IF NOT cl_null(g_bnh[l_ac].bnh03) AND 
               cl_null(g_bnh[l_ac].bnh04) THEN
               NEXT FIELD bnh04
            END IF 
#TQC-980269 --begin--
            IF NOT cl_null(g_bnh[l_ac].bnh04) THEN
               IF g_bnh[l_ac].bnh04 < 0 THEN 
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD bnh04
               END IF  
            END IF 
#TQC-980269 --end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_bnh_t.bnh01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM bnh_file 
                 WHERE bnh01 = g_bnh_t.bnh01
                   AND bnh02 = g_bnh_t.bnh02
                   AND bnh03 = g_bnh_t.bnh03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bnh_t.bnh01,SQLCA.sqlcode,0)   #No.FUN-660052
                   CALL cl_err3("del","bnh_file",g_bnh_t.bnh02,g_bnh_t.bnh03,SQLCA.sqlcode,"","",1)
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
              LET g_bnh[l_ac].* = g_bnh_t.*
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bnh[l_ac].bnh01,-263,1)
              LET g_bnh[l_ac].* = g_bnh_t.*
           ELSE
              UPDATE bnh_file SET bnh01=g_bnh[l_ac].bnh01,
                                  bnh02=g_bnh[l_ac].bnh02,
                                  bnh03=g_bnh[l_ac].bnh03,
                                  bnh04=g_bnh[l_ac].bnh04
               WHERE bnh01=g_bnh_t.bnh01
                 AND bnh02=g_bnh_t.bnh02
                 AND bnh03=g_bnh_t.bnh03
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bnh[l_ac].bnh01,SQLCA.sqlcode,0)    #No.FUN-660052
                  CALL cl_err3("upd","bnh_file",g_bnh_t.bnh02,g_bnh_t.bnh03,SQLCA.sqlcode,"","",1)
                  LET g_bnh[l_ac].* = g_bnh_t.*
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
                   LET g_bnh[l_ac].* = g_bnh_t.*                                    
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_bnh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i040_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT  
 #TQC-980269 --begin--
             ELSE
               IF NOT cl_null(g_bnh[l_ac].bnh04) THEN
                  IF g_bnh[l_ac].bnh04 < 0 THEN
                     CALL cl_err('','aim-223',0)
                     NEXT FIELD bnh04
                  END IF
               END IF 
#TQC-980269 --end--                                                                    
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i040_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i040_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bnh01) AND l_ac > 1 THEN
                LET g_bnh[l_ac].* = g_bnh[l_ac-1].*
                NEXT FIELD bnh01
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(bnh03) #料件編號
#                CALL q_ima(10,3,g_bnh[l_ac].bnh03) RETURNING g_bnh[l_ac].bnh03
#                CALL FGL_DIALOG_SETBUFFER( g_bnh[l_ac].bnh03 )
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form ="q_ima"
               #  LET g_qryparam.default1 = g_bnh[l_ac].bnh03
               #  CALL cl_create_qry() RETURNING g_bnh[l_ac].bnh03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_bnh[l_ac].bnh03, "", "", "", "" ,"",'' )  RETURNING g_bnh[l_ac].bnh03
#FUN-AA0059 --End--
#                 CALL FGL_DIALOG_SETBUFFER( g_bnh[l_ac].bnh03 )
                 DISPLAY BY NAME g_bnh[l_ac].bnh03
                 CALL i040_bnh03('d')
                 NEXT FIELD bnh03
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
 
FUNCTION i040_b_askkey()
    CLEAR FORM
    CALL g_bnh.clear()
    CONSTRUCT g_wc2 ON bnh01,bnh02,bnh03,bnh04
            FROM s_bnh[1].bnh01,s_bnh[1].bnh02,
                 s_bnh[1].bnh03,s_bnh[1].bnh04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(bnh03) #料件編號
#                CALL q_ima(10,3,g_bnh[1].bnh03) RETURNING g_bnh[1].bnh03
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.state ="c"
               #  LET g_qryparam.form ="q_ima"
               #  LET g_qryparam.default1 = g_bnh[1].bnh03
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","",g_bnh[1].bnh03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO s_bnh[1].bnh03
                 CALL i040_bnh03('d')
                 NEXT FIELD bnh03
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
    p_wc2     LIKE type_file.chr1000  #No.FUN-680062 VARCHAR(200)
 
    LET g_sql =
        "SELECT bnh01,bnh02,bnh03,ima02,bnh04 ",     
        " FROM bnh_file,OUTER ima_file ",            
        " WHERE ", p_wc2 CLIPPED,                      #單身
        "   AND bnh_file.bnh03 = ima_file.ima01 AND bnh01='1' ",       
        " ORDER BY bnh01"                                
    PREPARE i040_pb FROM g_sql
    DECLARE bnh_curs CURSOR FOR i040_pb
 
    CALL g_bnh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bnh_curs INTO g_bnh[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bnh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bnh TO s_bnh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i040_out()
    DEFINE
    l_bnh           RECORD                 #程式變數 (舊值)
        bnh01       LIKE bnh_file.bnh01,  
        bnh02       LIKE bnh_file.bnh02, 
        bnh03       LIKE bnh_file.bnh03, 
        ima02       LIKE ima_file.ima02, 
        ima021       LIKE ima_file.ima021, 
        bnh04       LIKE bnh_file.bnh04
                    END RECORD,
         l_i        LIKE type_file.num5,     #No.FUN-680062 SMALLINT
         l_name     LIKE type_file.chr20,    #No.FUN-680062 VARCHAR(20)
         l_za05     LIKE za_file.za05        #No.FUN-680062 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
   
    CALL cl_wait()
    CALL cl_outnam('abxi040') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    # 組合出 SQL 指令
    LET g_sql="SELECT bnh01,bnh02,bnh03,ima02,ima021,bnh04 ",
              "  FROM bnh_file,OUTER ima_file ",
         #    " WHERE ",g_wc2 CLIPPED,
              " WHERE bnh01='1' ",
              "   AND bnh_file.bnh03 = ima_file.ima01 "
 
    PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i040_co                         # SCROLL CURSOR
         CURSOR FOR i040_p1
 
    START REPORT i040_rep TO l_name
 
    FOREACH i040_co INTO l_bnh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i040_rep(l_bnh.*)
    END FOREACH
 
    FINISH REPORT i040_rep
 
    CLOSE i040_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680062 VARCHAR(1)
    sr              RECORD                 #程式變數 (舊值)
        bnh01       LIKE bnh_file.bnh01,  
        bnh02       LIKE bnh_file.bnh02, 
        bnh03       LIKE bnh_file.bnh03, 
        ima02       LIKE ima_file.ima02, 
        ima021      LIKE ima_file.ima021, 
        bnh04       LIKE bnh_file.bnh04
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bnh01,sr.bnh02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED,pageno_total
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1
 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.bnh01,
                  COLUMN g_c[32],sr.bnh02,
                  COLUMN g_c[33],sr.bnh03,
                  COLUMN g_c[34],sr.ima02,
                  COLUMN g_c[35],sr.ima021,
                  COLUMN g_c[36],cl_numfor(sr.bnh04,36,0)
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i040_bnh03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,   #---品名規格---
           l_ima05    LIKE ima_file.ima05,   #---版本---
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680062 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima05,imaacti  
      INTO l_ima02,l_ima05,l_imaacti
      FROM ima_file WHERE ima01 = g_bnh[l_ac].bnh03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL
                            LET l_ima05 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' 
    THEN 
       LET g_bnh[l_ac].ima02 = l_ima02
    END IF
END FUNCTION
#No.FUN-570109 --begin                                                                                                              
FUNCTION i040_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680062     VARCHAR(1)                                                                                                   #No.FUN-680062
               
   #NO.TQC-5A0064 start---
   IF (p_cmd = 'a' AND ( NOT g_before_input_done ) OR
       p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y') THEN
   #NO.TQC-5A0064 end---
   #IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("bnh01,bnh02,bnh03",TRUE)                                                                               
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i040_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680062    VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("bnh01,bnh02,bnh03",FALSE)                                                                              
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end              
