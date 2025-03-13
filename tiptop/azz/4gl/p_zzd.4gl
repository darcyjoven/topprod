# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: p_zzd
# Descriptions...: 製造業管理辭典                            
# Date & Author..: 97/11/19 charis
# Modify.........: No.FUN-510050 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-540140 05/04/20 By alex 修改 controlf 寫法
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70067 11/01/07 By tommas 資料匯入匯出功能 
# Modify.........: No:FUN-B10060 11/02/08 By tsai_yen 說明資料匯入的規範
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os                 #No.FUN-B30176
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_zzd          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        zzd01       LIKE zzd_file.zzd01,   
        zzd02       LIKE zzd_file.zzd02,  
        zzdacti     LIKE zzd_file.zzdacti      #No.FUN-680135 VARCHAR(1)
                    END RECORD,
    g_zzd_t         RECORD                     #程式變數 (舊值)
        zzd01       LIKE zzd_file.zzd01,   
        zzd02       LIKE zzd_file.zzd02,  
        zzdacti     LIKE zzd_file.zzdacti      #No.FUN-680135 VARCHAR(1)
                    END RECORD,
    #g_wc2          LIKE type_file.chr1000,    #No.FUN-580092 HCN  #No.FUN-680135 VARCHAR(1000)
    g_wc2           STRING,                    #No.FUN-580092 HCN  #TQC-630166
    g_sql           STRING,
    g_rec_b         LIKE type_file.num5,       #單身筆數  #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
 
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680135 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
 
MAIN
 
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0096
DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680135  SMALLINT 
   OPTIONS                                     #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 5 LET p_col = 18
   OPEN WINDOW p_zzd_w AT p_row,p_col  WITH FORM "azz/42f/p_zzd"
     ATTRIBUTE (STYLE = "sm1")
    
   CALL cl_ui_init()
   CALL p_zzd_memo()   #FUN-B10060
        
   LET g_wc2 = '1=1'
   CALL p_zzd_b_fill(g_wc2)
   CALL p_zzd_menu()
 
   CLOSE WINDOW p_zzd_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
 
FUNCTION p_zzd_menu()
 
 
    WHILE TRUE
       CALL p_zzd_bp("G")
 
       CASE g_action_choice
          WHEN "query"
             IF cl_chk_act_auth() THEN
                CALL p_zzd_q() 
             END IF
          WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL p_zzd_b() 
             ELSE
                LET g_action_choice = NULL
             END IF
          WHEN "output" 
             IF cl_chk_act_auth() THEN
                CALL p_zzd_out() 
             END IF
          WHEN "help"
             CALL cl_show_help()
          WHEN "exit"
             EXIT WHILE
          WHEN "controlg"
             CALL cl_cmdask()
          WHEN "exporttoexcel"     #No.FUN-A70067
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zzd),'','')
             END IF
          WHEN "load_data"          #No.FUN-A70067
             IF cl_chk_act_auth() THEN
                CALL p_zzd_load_data()
             END IF
       END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zzd_q()
 
   CALL p_zzd_b_askkey()
 
END FUNCTION
 
FUNCTION p_zzd_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,        #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,        #可新增否          #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5         #可刪除否          #No.FUN-680135 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   LET g_forupd_sql = "SELECT zzd01,zzd02,zzdacti FROM zzd_file",
                      " WHERE zzd01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zzd_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_zzd WITHOUT DEFAULTS FROM s_zzd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
     
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''  
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
 
            LET p_cmd='u'
            LET g_zzd_t.* = g_zzd[l_ac].*  #BACKUP
 
            OPEN p_zzd_bcl USING g_zzd_t.zzd01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_zzd_t.zzd01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_zzd_bcl INTO g_zzd[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zzd_t.zzd01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zzd[l_ac].* TO NULL      #900423
         LET g_zzd_t.* = g_zzd[l_ac].*         #新輸入資料
         LET g_zzd[l_ac].zzdacti='Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zzd_file(zzd01,zzd02,zzdacti)
              VALUES(g_zzd[l_ac].zzd01,g_zzd[l_ac].zzd02,g_zzd[l_ac].zzdacti)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zzd[l_ac].zzd01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zzd_file",g_zzd[l_ac].zzd01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      AFTER FIELD zzd01                        #check 編號是否重複
         IF g_zzd[l_ac].zzd01 != g_zzd_t.zzd01 OR (g_zzd[l_ac].zzd01 IS NOT NULL AND g_zzd_t.zzd01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM zzd_file
             WHERE zzd01 = g_zzd[l_ac].zzd01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_zzd[l_ac].zzd01 = g_zzd_t.zzd01
               NEXT FIELD zzd01
            END IF
         END IF
 
      AFTER FIELD zzdacti
         IF NOT cl_null(g_zzd[l_ac].zzdacti) THEN
            IF g_zzd[l_ac].zzdacti NOT MATCHES '[YN]' THEN
               NEXT FIELD zzdacti
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_zzd_t.zzd01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM zzd_file WHERE zzd01 = g_zzd_t.zzd01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zzd_t.zzd01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zzd_file",g_zzd_t.zzd01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zzd[l_ac].* = g_zzd_t.*
            CLOSE p_zzd_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zzd[l_ac].zzd01,-263,1)
            LET g_zzd[l_ac].* = g_zzd_t.*
         ELSE
            UPDATE zzd_file SET zzd01=g_zzd[l_ac].zzd01,
                                zzd02=g_zzd[l_ac].zzd02,
                                zzdacti=g_zzd[l_ac].zzdacti
             WHERE zzd01=g_zzd_t.zzd01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zzd[l_ac].zzd01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zzd_file",g_zzd_t.zzd01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zzd[l_ac].* = g_zzd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_zzd[l_ac].* = g_zzd_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_zzd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_zzd_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE p_zzd_bcl
         COMMIT WORK
 
#     ON KEY(CONTROL-N)
#        CALL p_zzd_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(zzd01) AND l_ac > 1 THEN
            LET g_zzd[l_ac].* = g_zzd[l_ac-1].*
            NEXT FIELD zzd01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE p_zzd_bcl
   COMMIT WORK
        
END FUNCTION
 
FUNCTION p_zzd_b_askkey()
 
   CLEAR FORM
   CALL g_zzd.clear()
   CONSTRUCT g_wc2 ON zzd01,zzd02,zzdacti
           FROM s_zzd[1].zzd01,s_zzd[1].zzd02,s_zzd[1].zzdacti
 #TQC-860017 start
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-860017 end
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL p_zzd_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p_zzd_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     #No.FUN-680135 VARCHAR(300)
 
   LET g_sql = "SELECT zzd01,zzd02,zzdacti,''",
               " FROM zzd_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE p_zzd_pb FROM g_sql
   DECLARE zzd_curs CURSOR FOR p_zzd_pb
 
   CALL g_zzd.clear() 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH zzd_curs INTO g_zzd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_zzd.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
  
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zzd_bp(p_ud)
 
    DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    IF p_ud != "G" OR  g_action_choice = "detail" THEN
       RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_zzd TO s_zzd.* ATTRIBUTE(COUNT=g_rec_b)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION query                            # Q.查詢
          LET g_action_choice="query"
          EXIT DISPLAY
       ON ACTION detail                           # B.單身
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DISPLAY
       ON ACTION help                             # H.說明
          LET g_action_choice="help"
          EXIT DISPLAY 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION output
           LET g_action_choice="output"
           EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
         CALL p_zzd_memo()                        #FUN-B10060
 
       ON ACTION exit                             # Esc.結束
          LET g_action_choice="exit"
          EXIT DISPLAY

      ON ACTION exporttoexcel             #No.FUN-A70067
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY

      ON ACTION load_data           #No.FUN-A70067
         LET g_action_choice="load_data"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zzd_out()
    DEFINE
        l_i             LIKE type_file.num5,      #No.FUN-680135 SMALLINT
        l_name          LIKE type_file.chr20,     # External(Disk) file name  #No.FUN-680135 VARCHAR(20)
        l_zzd   RECORD LIKE zzd_file.*,
        l_za05          LIKE type_file.chr1000,   #No.FUN-680135 VARCHAR(40)
        l_chr           LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    CALL cl_outnam('p_zzd') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM zzd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p_zzd_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zzd_co                         # SCROLL CURSOR
        CURSOR FOR p_zzd_p1
 
    START REPORT p_zzd_rep TO l_name
 
    FOREACH p_zzd_co INTO l_zzd.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p_zzd_rep(l_zzd.*)
    END FOREACH
 
    FINISH REPORT p_zzd_rep
 
    CLOSE p_zzd_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

FUNCTION p_zzd_load_data()  #No.FUN-A70067  add
    DEFINE l_file_path      STRING
    DEFINE l_r,l_c          INTEGER
    DEFINE l_sr,l_sc,l_cell STRING
    DEFINE l_value          STRING
    DEFINE l_zzd01          LIKE zzd_file.zzd01,
           l_zzd02          LIKE zzd_file.zzd02,
           l_zzdacti        LIKE zzd_file.zzdacti
    DEFINE l_result         INTEGER
    DEFINE l_cnt            INTEGER

    LET l_file_path = cl_browse_file()

    IF l_file_path IS NOT NULL  THEN
       IF l_file_path.toLowerCase() MATCHES "*.xls" OR    #判斷副檔名為xls或xlsx的處理程序
          l_file_path.toLowerCase() MATCHES "*.xlsx" THEN   

          CALL ui.Interface.frontCall("standard","shellexec",[l_file_path] ,l_result)  #開啟excel檔案
          CALL zzd_check_error(l_result,"Open File")
          SLEEP 2
          CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",l_file_path],[l_result]) #WINDDE連結EXCEL
          CALL zzd_check_error(l_result,"Connect File")

          CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[l_result])     #WINDDE連結Sheet1
          CALL zzd_check_error(l_result,"Connect Sheet1")

          PREPARE zzd_pre1 FROM "INSERT INTO zzd_file VALUES (?,?,?)"
          PREPARE zzd_upd1 FROM "UPDATE zzd_file SET zzd02 = ? , zzdacti = ? WHERE zzd01 = ? "          

          LET l_r = 1
          BEGIN WORK
             WHILE TRUE

                FOR l_c = 1 TO 3
                   LET l_sr = l_r
                   LET l_sc = l_c
                   LET l_cell = "R", l_sr.trim() ,"C" ,l_sc.trim()

                   CALL ui.Interface.frontCall("WINDDE", "DDEPeek", ["EXCEL", l_file_path, l_cell],[l_result,l_value])
                   CALL zzd_check_error(l_result,"Peek Cells")

                   CASE l_c
                      WHEN 1
                         LET l_zzd01 = l_value
                         IF l_zzd01 IS NULL THEN EXIT WHILE END IF
                         EXIT CASE
                      WHEN 2
                         LET l_zzd02 = l_value
                         IF l_zzd02 IS NULL THEN EXIT WHILE END IF
                         EXIT CASE
                      WHEN 3
                         LET l_zzdacti = l_value
                         IF l_zzdacti IS NULL THEN LET l_zzdacti = "Y" END IF

                         SELECT COUNT(*) INTO l_cnt FROM zzd_file WHERE zzd01 = l_zzd01

                         IF l_cnt > 0 THEN
                            EXECUTE zzd_upd1 USING l_zzd02, l_zzdacti, l_zzd01
                         ELSE
                            EXECUTE zzd_pre1 USING l_zzd01, l_zzd02, l_zzdacti
                         END IF

                         IF SQLCA.SQLCODE THEN
                            EXIT WHILE
                         END IF

                         EXIT CASE
                   END CASE
                END FOR
                LET l_r = l_r + 1
             END WHILE

          IF SQLCA.SQLCODE THEN
             CALL cl_err3("ins", "zzd_file", l_zzd01, "",SQLCA.sqlcode, "","",1)
             ROLLBACK WORK
             FREE zzd_pre1
          ELSE
             COMMIT WORK
             FREE zzd_pre1
             CALL cl_err("", "aoo-302",1)
          END IF

          CALL ui.Interface.frontCall("WINDDE","DDEFinish", ["EXCEL",l_file_path], [l_result] )
          CALL zzd_check_error(l_result,"Finish")           #xls處理程序結束

       ELSE
          IF l_file_path.toLowerCase() MATCHES "*.csv" OR  #判斷副檔名為csv或txt，必須是CSV格式，預設以|為分格符號
             l_file_path.toLowerCase() MATCHES "*.txt" THEN
             CALL zzd_load_txt(l_file_path)
          END IF
       END IF
    END IF

    CALL p_zzd_b_fill(g_wc2)

END FUNCTION

FUNCTION zzd_load_txt(p_file_path)  #No.FUN-A70067  add
   DEFINE p_file_path   STRING               #上傳的檔案路徑
   DEFINE l_tmpdir      STRING               #暫存資料夾
   DEFINE l_tmpfile     STRING               #暫存檔案路徑
   DEFINE l_convfile    STRING               #轉碼後的檔案路徑
   DEFINE l_cmd         STRING               #shell
   DEFINE l_n           LIKE type_file.num5
   DEFINE ss            STRING
   DEFINE l_delimiter   STRING
   DEFINE ms_codeset    STRING,              #環境編碼
          ls_codeset    STRING               #上傳的檔案編碼
   DEFINE channel_r     base.Channel,        #給轉碼用的
          channel_cmd   base.Channel         #給取得上傳的檔案編碼用的
   DEFINE l_token       base.StringTokenizer
   DEFINE l_read_str    STRING
   DEFINE l_zzd01       LIKE zzd_file.zzd01,
          l_zzd02       LIKE zzd_file.zzd02,
          l_zzdacti     LIKE zzd_file.zzdacti
   DEFINE l_cnt         INTEGER
   DEFINE l_now_str    STRING

   LET l_now_str = CURRENT
   CALL cl_replace_str(l_now_str, "-", "") RETURNING l_now_str
   CALL cl_replace_str(l_now_str, " ", "") RETURNING l_now_str
   CALL cl_replace_str(l_now_str, ":", "") RETURNING l_now_str
   CALL cl_replace_str(l_now_str, ".", "") RETURNING l_now_str

   LET l_tmpdir = FGL_GETENV("TEMPDIR")
   LET l_tmpdir = l_tmpdir.trim()
   LET l_n = l_tmpdir.getLength()

   IF l_n > 0 THEN
      IF l_tmpdir.getIndexOf("/", l_n) > 0 THEN
         LET l_tmpdir = l_tmpdir.subString(1, l_n -1)
      END IF
   END IF

   LET l_tmpfile = l_tmpdir,"/", FGL_GETPID() CLIPPED ,"_",g_user, l_now_str CLIPPED , ".tmp"
   LET l_tmpfile = cl_replace_str(l_tmpfile, " ", "")
   LET l_convfile = l_tmpfile, ".conv"
   IF NOT cl_upload_file(p_file_path, l_tmpfile) THEN
      CALL cl_err(NULL, "lib-212", 1)
      RETURN
   END IF

   LET ls_codeset = "UNICODE"              #預設檔案編碼為Unicode
   LET channel_cmd = base.Channel.create()
   LET l_cmd = "file ",l_tmpfile
   CALL channel_cmd.openPipe(l_cmd, "r")
   WHILE channel_cmd.read([ss])
   END WHILE
   CALL channel_cmd.close()

   LET ss = ss.toUpperCase()

   IF ss MATCHES "*ISO-8859*" THEN    #檔案編碼BIG-5 ?
      LET ls_codeset = "BIG-5"
   ELSE
      IF ss MATCHES "*UTF-8*" THEN    #檔案編碼UTF-8 ?
         LET ls_codeset = "UTF-8"
      ELSE
         IF ss MATCHES "*GBK*" OR ss MATCHES "GB2312" THEN  #檔案編碼是GBK / GBK2312 ?
            LET ls_codeset = "GB2312"
         END IF
      END IF
   END IF

   LET ms_codeset = cl_get_codeset()

   #LET l_cmd = "iconv -f ", ls_codeset, " -t ", ms_codeset, " " || l_tmpfile CLIPPED || " > " || l_convfile CLIPPED  #FUN-B30176 mark
   #FUN-B30176-add-start--
   IF os.Path.separator() = "/" THEN
      LET l_cmd = "iconv -f ", ls_codeset, " -t ", ms_codeset, " " || l_tmpfile CLIPPED || " > " || l_convfile CLIPPED
   ELSE 
      CASE ms_codeset
         WHEN "UTF-8"
            LET l_cmd = "java -cp  zhcode.java zhcode -u8", " " || l_tmpfile CLIPPED || " > " || l_convfile CLIPPED
         WHEN "BIG-5"
            LET l_cmd = "java -cp  zhcode.java zhcode -ub", " " || l_tmpfile CLIPPED || " > " || l_convfile CLIPPED 
         WHEN "GB2312"
            LET l_cmd = "java -cp  zhcode.java zhcode -ug", " " || l_tmpfile CLIPPED || " > " || l_convfile CLIPPED
      END CASE
   END IF
   #FUN-B30176-add-end--
   RUN l_cmd
   LET l_cmd = "cp -f " || l_convfile CLIPPED || " " || l_tmpfile CLIPPED
   RUN l_cmd
   LET l_cmd = " killcr " || l_tmpfile CLIPPED
   RUN l_cmd

   LET channel_r = base.Channel.create()

   CALL channel_r.openFile(l_tmpfile, "r")
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF

   CALL channel_r.setDelimiter("")

   PREPARE zzd_txt_pre1 FROM "INSERT INTO zzd_file VALUES (?,?,?)"
   PREPARE zzd_txt_upd1 FROM "UPDATE zzd_file SET zzd02 = ?, zzdacti = ? WHERE zzd01 = ? "
   LET l_n = 1

   BEGIN WORK
   WHILE TRUE
      LET l_read_str = channel_r.readLine()

      IF channel_r.isEof() THEN EXIT WHILE END IF  #檔案讀完了

      LET l_token = base.StringTokenizer.create(l_read_str, "|")

      LET l_zzd01 = l_token.nextToken()       #填值，token到沒資料時是NULL
      LET l_zzd02 = l_token.nextToken()       #填值，token到沒資料時是NULL
      LET l_zzdacti = l_token.nextToken()     #填值，token到沒資料時是NULL

      IF l_zzd01 IS NULL OR l_zzd02 IS NULL OR l_zzdacti IS NULL THEN
         EXIT WHILE
      END IF

      SELECT COUNT(*) INTO l_cnt FROM zzd_file WHERE zzd01 = l_zzd01

      IF l_cnt > 0 THEN
         EXECUTE zzd_txt_upd1 USING l_zzd02, l_zzdacti, l_zzd01
      ELSE
         EXECUTE zzd_txt_pre1 USING l_zzd01, l_zzd02, l_zzdacti
      END IF

      IF SQLCA.SQLCODE THEN
         EXIT WHILE
      END IF

      LET l_n = l_n + 1
   END WHILE

   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins", "zzd_file", l_zzd01, "",SQLCA.sqlcode, "","",1)
      ROLLBACK WORK
      FREE zzd_txt_pre1
   ELSE
      COMMIT WORK
      FREE zzd_txt_pre1
      CALL cl_err("", "aoo-302",1)
   END IF

END FUNCTION

FUNCTION zzd_check_error(p_result, p_msg) #No.FUN-A70067  add
   DEFINE p_result  LIKE type_file.num5
   DEFINE li_result LIKE type_file.num5
   DEFINE p_msg     STRING
   DEFINE ls_msg    STRING

   IF p_result THEN RETURN END IF  #沒有錯誤

   DISPLAY p_msg, " DDE Error:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])  #取得DDE錯誤訊息
   DISPLAY ls_msg

   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result]) #結束所有DDE檔案

   IF NOT li_result THEN
      DISPLAY "Can't close DDE files"
   END IF

END FUNCTION 

REPORT p_zzd_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
        sr RECORD LIKE zzd_file.*,
        l_chr           LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.zzd01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.zzdacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
            PRINT COLUMN g_c[32],sr.zzd01,
                  COLUMN g_c[33],sr.zzd02
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'zzd01,zzd02,zzd03,zzd04')
                    RETURNING g_wc2
               PRINT g_dash[1,g_len]
               #TQC-630166
               # IF g_wc2[001,080] > ' ' THEN
	       #        PRINT g_x[8] CLIPPED,g_wc2[001,070] CLIPPED END IF
               # IF g_wc2[071,140] > ' ' THEN
	       #        PRINT COLUMN 10,     g_wc2[071,140] CLIPPED END IF
               # IF g_wc2[141,210] > ' ' THEN
	       #        PRINT COLUMN 10,     g_wc2[141,210] CLIPPED END IF
                 CALL cl_prt_pos_wc(g_wc2)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT


FUNCTION p_zzd_memo()   #FUN-B10060
   DEFINE l_memo     LIKE gae_file.gae04
   DEFINE l_c        LIKE type_file.num5
   DEFINE l_cust     LIKE type_file.chr1
   
   #若有客製碼為Y的資料則優先抓取
   SELECT COUNT(*) INTO l_c FROM gae_file
      WHERE gae01 = 'p_zzd' AND gae03 = g_lang AND gae11 = 'Y'
   IF l_c > 0 THEN
      LET l_cust = "Y"
   ELSE
      LET l_cust = "N"
   END IF
   #說明資料匯入的規範
   SELECT gae04 INTO l_memo FROM gae_file
      WHERE gae01='p_zzd' AND gae02 = 'memo' AND gae03 = g_lang
        AND gae11 = l_cust AND gae12 = g_ui_setting
   DISPLAY l_memo TO memo
END FUNCTION
