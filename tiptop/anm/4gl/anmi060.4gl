# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi060.4gl
# Descriptions...: 現金變動碼(FM)
# Date & Author..: 
# Modify         : Nick 94/12/5 modified to Muti-Line 
# Modify         : No.A111 04/03/05 By Danny  for 大陸版
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制   
# Modify.........: No.MOD-590109 05/09/08 By kim 按"匯出Excel"無任何作用
# Modify.........: No.FUN-640004 06/04/04 By Ray 單身新加行序欄位 nml05
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0131 06/11/23 By Smapmin 變動分類於報表顯示時要有中文說明
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740058 07/04/12 By Judy 單身行序無控管
# Modify.........: No.FUN-830119 08/03/24 By lala 制作CR
# Modify.........: No.MOD-850174 08/05/20 By Sarah nml03依大陸版說明為主,改為不分地區別,選項有10,11,20,21,30,31,40
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40115 10/04/23 By Carrier 二次打印时,wc的问题
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nml           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nml01       LIKE nml_file.nml01,       #銀行調節碼
        nml02       LIKE nml_file.nml02,       #調節說明
        nml03       LIKE nml_file.nml03,       #銀行存款加減方式
        nml05       LIKE nml_file.nml05,       #行次 #FUN-640004
        nmlacti     LIKE nml_file.nmlacti      #No.FUN-680107 VARCHAR(1)
                    END RECORD,
    g_nml_t         RECORD                     #程式變數 (舊值)
        nml01       LIKE nml_file.nml01,       #銀行調節碼
        nml02       LIKE nml_file.nml02,       #調節說明
        nml03       LIKE nml_file.nml03,       #銀行存款加減方式
        nml05       LIKE nml_file.nml05,       #行次 #FUN-640004
        nmlacti     LIKE nml_file.nmlacti      #No.FUN-680107 VARCHAR(1)
                    END RECORD,
    g_wc,g_sql      STRING,                    #TQC-630166
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
DEFINE g_str   STRING
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5        #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5    #FUN-570108 #No.FUN-680107 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0082
DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
  #No.A111
  #IF g_aza.aza26 = '2' THEN   #MOD-850174 mark
      LET p_row = 3 LET p_col = 10
      OPEN WINDOW i060_w AT p_row,p_col WITH FORM "gnm/42f/gnmi060"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  #str MOD-850174 mark
  #ELSE
  #   LET p_row = 4 LET p_col = 11
  #   OPEN WINDOW i060_w AT p_row,p_col WITH FORM "anm/42f/anmi060"
  #     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  #END IF
  #end MOD-850174 mark
   CALL cl_ui_init()
 
   LET g_wc = '1=1' CALL i060_b_fill(g_wc)
   CALL i060_menu()
   CLOSE WINDOW i060_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i060_menu()
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i060_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i060_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_q()
   CALL i060_b_askkey()
END FUNCTION
 
FUNCTION i060_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680107 VARCHAR(1)                   
    l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680107 VARCHAR(1)                   
 
    LET g_action_choice = ""                                                    
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nml01,nml02,nml03,nml05,nmlacti FROM nml_file WHERE nml01=? FOR UPDATE"    #FUN-640004
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nml
            WITHOUT DEFAULTS
            FROM s_nml.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT 
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd='u' 
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3  #MOD-960067
           #LET g_nml_t.* = g_nml[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_nml_t.nml01 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_nml_t.* = g_nml[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i060_set_entry(p_cmd)                                      
                CALL i060_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end           
 
                BEGIN WORK
                OPEN i060_bcl USING g_nml_t.nml01
                IF STATUS THEN
                   CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i060_bcl INTO g_nml[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_nml_t.nml01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
          #NEXT FIELD nml01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i060_set_entry(p_cmd)                                          
            CALL i060_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end    
                INITIALIZE g_nml[l_ac].* TO NULL      #900423
                LET g_nml[l_ac].nmlacti = 'Y'       #Body default
            LET g_nml_t.* = g_nml[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD nml01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
             # CLOSE i060_bcl                                                   
             # CALL g_nml.deleteElement(l_ac)                                   
             # IF g_rec_b != 0 THEN                                             
             #    LET g_action_choice = "detail"                                
             #    LET l_ac = l_ac_t                                             
             # END IF                                                           
             # EXIT INPUT
            END IF
            INSERT INTO nml_file(nml01,nml02,nml03,nml05,    #FUN-640004
                                 nmlacti,nmluser,nmldate,nmloriu,nmlorig)
            VALUES(g_nml[l_ac].nml01,g_nml[l_ac].nml02,
                   g_nml[l_ac].nml03,g_nml[l_ac].nml05,g_nml[l_ac].nmlacti,     #FUN-640004
                   g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nml[l_ac].nml01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","nml_file",g_nml[l_ac].nml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
               CANCEL INSERT
              #LET g_nml[l_ac].* = g_nml_t.*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD nml01                        #check 編號是否重複
            IF g_nml[l_ac].nml01 != g_nml_t.nml01 OR
               (g_nml[l_ac].nml01 IS NOT NULL AND g_nml_t.nml01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM nml_file
                    WHERE nml01 = g_nml[l_ac].nml01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nml[l_ac].nml01 = g_nml_t.nml01
                    NEXT FIELD nml01
                END IF
            END IF
 
	AFTER FIELD nml03
           #No.A111
           #IF g_aza.aza26 = '2' THEN   #MOD-850174 mark
               IF (g_nml[l_ac].nml03 != '10' AND g_nml[l_ac].nml03 != '11' AND
                   g_nml[l_ac].nml03 != '20' AND g_nml[l_ac].nml03 != '21' AND
                   g_nml[l_ac].nml03 != '30' AND g_nml[l_ac].nml03 != '31' AND
                   g_nml[l_ac].nml03 != '40') OR cl_null(g_nml[l_ac].nml03) THEN
                  LET g_nml[l_ac].nml03 = g_nml_t.nml03
                  NEXT FIELD nml03
               END IF
           #str MOD-850174 mark
           #ELSE
           #  IF g_nml[l_ac].nml03 NOT MATCHES '[123]' OR 
           #     cl_null(g_nml[l_ac].nml03) THEN
           #     LET g_nml[l_ac].nml03 = g_nml_t.nml03
           #     NEXT FIELD nml03
           #  END IF
           #END IF
           #end MOD-850174 mark
           #end
#TQC-740058......begin                                                          
        AFTER FIELD nml05                                                       
            IF NOT cl_null(g_nml[l_ac].nml05) THEN                              
               IF g_nml[l_ac].nml05 <= 0 THEN                                   
                  CALL cl_err(g_nml[l_ac].nml05,'mfg9243',0)                    
                  NEXT FIELD nml05                                              
               END IF                                                           
            END IF                                                              
#TQC-740058.....end
 
        BEFORE DELETE                            #是否取消單身
            IF g_nml_t.nml01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM nml_file WHERE nml01 = g_nml_t.nml01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nml_t.nml01,SQLCA.sqlcode,0) #No.FUN-660148
                   CALL cl_err3("del","nml_file",g_nml_t.nml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i060_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nml[l_ac].* = g_nml_t.*
               CLOSE i060_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nml[l_ac].nml01,-263,1)                            
             LET g_nml[l_ac].* = g_nml_t.*                                      
          ELSE                                      
            UPDATE nml_file SET nml01 = g_nml[l_ac].nml01,
                                        nml02 = g_nml[l_ac].nml02,
                                        nml03 = g_nml[l_ac].nml03,
                                        nml05 = g_nml[l_ac].nml05,   #FUN-640004
                                        nmlacti = g_nml[l_ac].nmlacti,
                                        nmlmodu = g_user,
                                        nmldate = g_today
                         WHERE nml01=g_nml_t.nml01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nml[l_ac].nml01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nml_file",g_nml_t.nml01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nml[l_ac].* = g_nml_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i060_bcl         
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nml[l_ac].* = g_nml_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_nml.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE i060_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
          END IF
        # LET g_nml_t.* = g_nml[l_ac].*          # 900423
          LET l_ac_t = l_ac                                                     
          CLOSE i060_bcl                                                        
          COMMIT WORK   
 
        ON ACTION CONTROLN
            CALL i060_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nml01) AND l_ac > 1 THEN
                LET g_nml[l_ac].* = g_nml[l_ac-1].*
                NEXT FIELD nml01
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
 
 
    CLOSE i060_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i060_b_askkey()
    CLEAR FORM
   CALL g_nml.clear()
    CONSTRUCT g_wc ON nml01,nml02,nml03,nml05,nmlacti   #FUN-640004
            FROM s_nml[1].nml01,s_nml[1].nml02,s_nml[1].nml03
			       ,s_nml[1].nml05,s_nml[1].nmlacti    #FUN-640004
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmluser', 'nmlgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i060_b_fill(g_wc)
END FUNCTION
 
FUNCTION i060_b_fill(p_wc2)        #BODY FILL UP
DEFINE
    p_wc2  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
        "SELECT nml01,nml02,nml03,nml05,nmlacti",    #FUN-640004
        " FROM nml_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i060_pb FROM g_sql
    DECLARE nml_curs CURSOR FOR i060_pb
 
    FOR g_cnt = 1 TO g_nml.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nml[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH nml_curs INTO g_nml[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nml.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i060_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.*  ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY #MOD-590109
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-830119---start---
FUNCTION i060_out()
    DEFINE
        l_nml           RECORD LIKE nml_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680107 VARCHAR(20)
        l_wc            LIKE type_file.chr1000,  #No.TQC-960307 
        l_za05          LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(40)
DEFINE p_nml03 LIKE nml_file.nml03
DEFINE l_nml03 STRING
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('anmi060') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    #-----TQC-6B0131---------
   #str MOD-850174 mark
   #IF g_aza.aza26 = '2' THEN
   #   LET g_zaa[33].zaa06 = "Y"
   #ELSE
   #   LET g_zaa[34].zaa06 = "Y"
   #END IF
   #end MOD-850174 mark
    CALL cl_prt_pos_len()
    #LET g_sql="SELECT * FROM nml_file ",          # 組合出 SQL 指令
    #          " WHERE ",g_wc CLIPPED
    
   #IF g_aza.aza26 = '2' THEN   #MOD-850174 mark
       LET g_sql="SELECT * FROM nml_file ",          # 組合出 SQL 指令
                 " WHERE ",g_wc CLIPPED,
                 " AND nml03 IN ('10','11','20','21','30','31','40')"
   #str MOD-850174 mark
   #ELSE
   #   LET g_sql="SELECT * FROM nml_file ",          # 組合出 SQL 指令
   #             " WHERE ",g_wc CLIPPED,
   #             " AND nml03 IN ('1','2','3')"
   #END IF
   #end MOD-850174 mark
    
    CALL cl_wcchp(g_wc,'nml01,nml02,nml03,nml05,nmlacti')
#            RETURNING g_wc              #No.TQC-960307
             RETURNING l_wc              #No.TQC-960307
#   LET g_str=g_wc   #,";",g_aza.aza26   #MOD-850174 mod  #No.TQC-A40115
    LET g_str=l_wc   #,";",g_aza.aza26   #MOD-850174 mod  #No.TQC-A40115
    CALL cl_prt_cs1('anmi060','anmi060',g_sql,g_str)          #No.FUN-830119
    #-----END TQC-6B0131-----
#    PREPARE i060_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i060_co CURSOR FOR i060_p1
 
#    START REPORT i060_rep TO l_name
 
#    FOREACH i060_co INTO l_nml.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i060_rep(l_nml.*)
#    END FOREACH
 
#    FINISH REPORT i060_rep
 
#    CLOSE i060_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i060_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#        sr              RECORD LIKE nml_file.*,
#        l_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
#    DEFINE l_nml03      STRING   #TQC-6B0131
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.nml01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#           #No.A111
#           #-----TQC-6B0131-----
#           #PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
#            IF g_aza.aza26 = '2' THEN
#               PRINT g_x[31],g_x[32],g_x[34]
#            ELSE
#               PRINT g_x[31],g_x[32],g_x[33]
#            END IF
#           #-----END TQC-6B0131-----
#            PRINT g_dash1
#           #end
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            CALL nml03_des(sr.nml03) RETURNING l_nml03   #TQC-6B0131
#            IF sr.nmlacti = 'N' THEN PRINT '*'; END IF
#          #No.A111
#         PRINT COLUMN g_c[31],sr.nml01,
#                  COLUMN g_c[32],sr.nml02;
#                 #-----TQC-6B0131---------
#                 #COLUMN g_c[33],sr.nml03
#                  IF g_aza.aza26 = '2' THEN
#                     PRINT COLUMN g_c[34],l_nml03
#                  ELSE
#                     PRINT COLUMN g_c[33],l_nml03
#                  END IF
#                 #-----END TQC-6B0131-----
#           #end
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc,'nml01,nml02,nml03')
#                    RETURNING g_sql
#               PRINT g_dash[1,g_len]
#
#         #TQC-630166
#         {
#              IF g_sql[001,080] > ' ' THEN
#       	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#              IF g_sql[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#              IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#         }
#                CALL cl_prt_pos_wc(g_sql)
#         #END TQC-630166
#
#            END IF
#          #No.A111
#            IF g_aza.aza26 = '2' THEN
#               PRINT ''
#               PRINT COLUMN g_c[31],g_x[16] CLIPPED
#               PRINT COLUMN g_c[31],g_x[9] CLIPPED,
#                     COLUMN g_c[32],g_x[10] CLIPPED,
#                    #COLUMN g_c[33],g_x[11] CLIPPED   #TQC-6B0131
#                     COLUMN g_c[34],g_x[11] CLIPPED   #TQC-6B0131
#               PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#                     COLUMN g_c[32],g_x[13] CLIPPED,
#                    #COLUMN g_c[33],g_x[14] CLIPPED   #TQC-6B0131
#                     COLUMN g_c[34],g_x[14] CLIPPED   #TQC-6B0131
#               PRINT COLUMN g_c[32],g_x[15] CLIPPED
#            END IF
#           #end
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
 
#-----TQC-6B0131---------
#FUNCTION nml03_des(p_nml03)
#  DEFINE p_nml03 LIKE nml_file.nml03
#  DEFINE l_nml03 STRING
#
#  IF g_aza.aza26 = '2' THEN
#     CASE p_nml03
#          WHEN '10'
#            LET l_nml03 = cl_getmsg('anm-510',g_lang)
#          WHEN '11'
#            LET l_nml03 = cl_getmsg('anm-511',g_lang)
#          WHEN '20'
#            LET l_nml03 = cl_getmsg('anm-512',g_lang)
#          WHEN '21'
#            LET l_nml03 = cl_getmsg('anm-513',g_lang)
#          WHEN '30'
#            LET l_nml03 = cl_getmsg('anm-514',g_lang)
#          WHEN '31'
#            LET l_nml03 = cl_getmsg('anm-515',g_lang)
#          WHEN '40'
#            LET l_nml03 = cl_getmsg('anm-516',g_lang)
#     END CASE
#
#  ELSE
#     CASE p_nml03
#          WHEN '1'
#            LET l_nml03 = cl_getmsg('anm-517',g_lang)
#          WHEN '2'
#            LET l_nml03 = cl_getmsg('anm-518',g_lang)
#          WHEN '3'
#            LET l_nml03 = cl_getmsg('anm-519',g_lang)
#     END CASE
#  END IF
#  RETURN l_nml03
#END FUNCTION
#-----END TQC-6B0131-----
#No.FUN-830119---end---
 
#No.FUN-570108 --start                                                          
FUNCTION i060_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nml01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i060_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nml01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end        
