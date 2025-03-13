# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi201.4gl
# Descriptions...: 媒體代碼維護作業
# Date & Author..: 05/10/18 By day    
# Modify.........: No.FUN-660104 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/20 By mike 報表格式修改為 crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0160 10/11/29 By huangtao 修改媒體編號欄位新增時候無法輸入的問題
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_toa           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        toa01       LIKE toa_file.toa01,
        toa02       LIKE toa_file.toa02,
        toa03       LIKE toa_file.toa03, 
        toaacti     LIKE toa_file.toaacti 
                    END RECORD,
    g_toa_t         RECORD                 #程式變數 (舊值)
        toa01       LIKE toa_file.toa01,
        toa02       LIKE toa_file.toa02,
        toa03       LIKE toa_file.toa03,
        toaacti     LIKE toa_file.toaacti
                    END RECORD,
    g_wc2,g_sql     string, 
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT     #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
 
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose      #No.FUN-680120 SMALLINT
DEFINE   g_msg        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_str        STRING                       #No.FUN-760083
DEFINE   l_table      STRING                       #No.FUN-760083  
MAIN
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6B0014
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
#No.FUN-760083   --begin--
    LET g_sql="toa01.toa_file.toa01,",
              "toa02.toa_file.toa02,",
              "toa03.toa_file.toa03,",
              "toaacti.toa_file.toaacti,",
              "l_desc.type_file.chr1000"
    LET l_table=cl_prt_temptable("atmi201",g_sql) CLIPPED 
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1)
    END IF
#No.FUN-760083   --END--
               
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW i201_w AT p_row,p_col WITH FORM "atm/42f/atmi201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1' CALL i201_b_fill(g_wc2)
    CALL i201_bp('D')
    CALL i201_menu() 
    CLOSE WINDOW i201_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i201_menu()
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i201_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_toa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_q()
   CALL i201_b_askkey()
END FUNCTION
 
FUNCTION i201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680120 VARCHAR(1)             #可新增否
    l_allow_delete  LIKE type_file.chr1                  #No.FUN-680120 VARCHAR(1)             #可刪除否
DEFINE  li_result   LIKE type_file.num5                  #No.FUN-680120 SMALLINT
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql="SELECT toa01,toa02,toa03,toaacti ",
                     "  FROM toa_file ",
                     "  WHERE toa01= ?  ",
                     " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    INPUT ARRAY g_toa WITHOUT DEFAULTS FROM s_toa.*
    ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
               INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
               APPEND ROW = l_allow_insert)
 
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_toa_t.* = g_toa[l_ac].*  #BACKUP
                LET g_before_input_done = FALSE
                CALL i201_set_entry(p_cmd)
                CALL i201_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                OPEN i201_bcl USING g_toa_t.toa01      #表示更改狀態
                IF STATUS THEN
                   CALL cl_err("OPEN i201_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i201_bcl INTO g_toa[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_toa_t.toa01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont() 
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE           #TQC-AB0160
            CALL i201_set_entry(p_cmd)
            CALL i201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            OPEN i201_bcl USING g_toa_t.toa01      #表示更改狀態
            INITIALIZE g_toa[l_ac].* TO NULL     
            LET g_toa[l_ac].toa03   = '1'    
            LET g_toa[l_ac].toaacti = 'Y'       #Body default
            LET g_toa_t.* = g_toa[l_ac].*       #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD toa01
 
    AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
              INSERT INTO toa_file(toa01,toa02,toa03,toaacti)
              VALUES(g_toa[l_ac].toa01,g_toa[l_ac].toa02,
                     g_toa[l_ac].toa03,
                     g_toa[l_ac].toaacti)
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_toa[l_ac].toa01,SQLCA.sqlcode,0)  #No.FUN-660104
              CALL cl_err3("ins","toa_file",g_toa[l_ac].toa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF
 
 
        AFTER FIELD toa01                        #check 編號是否重複
            IF NOT cl_null(g_toa[l_ac].toa01) THEN
               IF g_toa[l_ac].toa01 != g_toa_t.toa01 OR
                  g_toa_t.toa01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM toa_file
                       WHERE toa01 = g_toa[l_ac].toa01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_toa[l_ac].toa01 = g_toa_t.toa01
                       NEXT FIELD toa01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_toa_t.toa01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM toa_file WHERE toa01 = g_toa_t.toa01
                IF SQLCA.sqlcode THEN
                #   CALL cl_err(g_toa_t.toa01,SQLCA.sqlcode,0)  #No.FUN-660104
                    CALL cl_err3("del","toa_file",g_toa_t.toa01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete OK"
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
           IF INT_FLAG THEN         
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_toa[l_ac].* = g_toa_t.*
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_toa[l_ac].toa01,-263,0)
              LET g_toa[l_ac].* = g_toa_t.*
           ELSE
              UPDATE toa_file SET
                                  toa01=g_toa[l_ac].toa01,
                                  toa02=g_toa[l_ac].toa02,
                                  toa03=g_toa[l_ac].toa03,
                                  toaacti=g_toa[l_ac].toaacti
               WHERE CURRENT OF i201_bcl
              IF SQLCA.sqlcode THEN
              #   CALL cl_err(g_toa[l_ac].toa01,SQLCA.sqlcode,0) #No.FUN-660104
                  CALL cl_err3("upd","toa_file",g_toa[l_ac].toa01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                  LET g_toa[l_ac].* = g_toa_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
    AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN   
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_toa[l_ac].* = g_toa_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_toa.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i201_bcl     
              ROLLBACK WORK       
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE i201_bcl       
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i201_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(toa01) AND l_ac > 1 THEN
                LET g_toa[l_ac].* = g_toa[l_ac-1].*
                NEXT FIELD toa01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION help   
         CALL cl_show_help() 
 
 
        END INPUT
    CLOSE i201_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_b_askkey()
    CLEAR FORM
    CALL g_toa.clear()
    CONSTRUCT g_wc2 ON toa01,toa02,toa03,toaacti
         FROM s_toa[1].toa01,s_toa[1].toa02,
              s_toa[1].toa03,s_toa[1].toaacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
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
    CALL i201_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT toa01,toa02,toa03,toaacti ",
        " FROM toa_file ",
        " WHERE ",p_wc2 CLIPPED,   #單身
        " ORDER BY toa01"
    PREPARE i201_pb FROM g_sql
    DECLARE toa_curs CURSOR FOR i201_pb
 
    CALL g_toa.clear()
    LET g_cnt = 1
    FOREACH toa_curs INTO g_toa[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_toa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i201_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_toa TO s_toa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()        
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
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
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i201_out()
    DEFINE
        l_toa           RECORD LIKE toa_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20) 
        l_za05          LIKE za_file.za05 
DEFINE   l_desc    LIKE    type_file.chr1000         #No.FUN-760083  
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN 
    END IF
    CALL cl_wait()
    #CALL cl_outnam('atmi201') RETURNING l_name      #No.FUN-760083  
    LET g_str=''                                    #No.FUN-760083
    CALL cl_del_data(l_table)                        #No.FUN-760083  
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM toa_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i201_p1 FROM g_sql                    # RUNTIME 編譯
    DECLARE i201_co                               # SCROLL CURSOR
         CURSOR FOR i201_p1
 
    #START REPORT i201_rep TO l_name              #No.FUN-760083  
 
    FOREACH i201_co INTO l_toa.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#No.FUN-760083--begin--
        CASE l_toa.toa03                                                                                                           
                 WHEN '1' CALL cl_getmsg('atm-101',g_lang) RETURNING l_desc                                                         
                 WHEN '2' CALL cl_getmsg('atm-102',g_lang) RETURNING l_desc                                                         
                 WHEN '3' CALL cl_getmsg('atm-103',g_lang) RETURNING l_desc                                                         
                 WHEN '4' CALL cl_getmsg('atm-104',g_lang) RETURNING l_desc                                                         
                 WHEN '5' CALL cl_getmsg('atm-105',g_lang) RETURNING l_desc                                                         
                 WHEN '6' CALL cl_getmsg('atm-106',g_lang) RETURNING l_desc                                                         
                 WHEN '7' CALL cl_getmsg('atm-107',g_lang) RETURNING l_desc                                                         
        END CASE                 
        EXECUTE 	insert_prep USING   l_toa.toa01,l_toa.toa02,l_toa.toa03,
                                            l_toa.toaacti,l_desc   
#No.FUN-760083  --end--                                          
        #OUTPUT TO REPORT i201_rep(l_toa.*)        #No.FUN-760083  
    END FOREACH
 
    #FINISH REPORT i201_rep                        #No.FUN-760083  
 
    CLOSE i201_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)             #No.FUN-760083  
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-760083
    IF g_zz05='Y' THEN
       CALL cl_wcchp(g_wc2,'toa01,toa02,toa03,toaacti')
       RETURNING   g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs3("atmi201","atmi201",g_sql,g_str)            #No.FUN-760083
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i201_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        sr RECORD LIKE toa_file.*,
        l_chr           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_desc          LIKE ze_file.ze03         #No.FUN-680120 VARCHAR(10) 
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.toa01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            CASE sr.toa03                                                       
                 WHEN '1' CALL cl_getmsg('atm-101',g_lang) RETURNING l_desc     
                 WHEN '2' CALL cl_getmsg('atm-102',g_lang) RETURNING l_desc     
                 WHEN '3' CALL cl_getmsg('atm-103',g_lang) RETURNING l_desc     
                 WHEN '4' CALL cl_getmsg('atm-104',g_lang) RETURNING l_desc     
                 WHEN '5' CALL cl_getmsg('atm-105',g_lang) RETURNING l_desc     
                 WHEN '6' CALL cl_getmsg('atm-106',g_lang) RETURNING l_desc     
                 WHEN '7' CALL cl_getmsg('atm-107',g_lang) RETURNING l_desc     
            END CASE                                                  
            PRINT COLUMN g_c[31],sr.toa01 CLIPPED,
                  COLUMN g_c[32],sr.toa02 CLIPPED,
                  COLUMN g_c[33],sr.toa03 CLIPPED,
                  COLUMN g_c[34],l_desc CLIPPED,
                  COLUMN g_c[35],sr.toaacti
 
        ON LAST ROW
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
 
}
#No.FUN-760083  --end--
FUNCTION i201_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("toa01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i201_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("toa01",FALSE) 
    END IF 
 
END FUNCTION
