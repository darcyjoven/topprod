# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi300.4gl
# Descriptions...: 特性類別資料維護作業
# Date & Author..: 04/09/18 By Lifeng
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: NO.FUN-590002 05/12/27 By Monster radio type 應都要給預設值
# Modify.........: NO.MOD-660041 06/06/13 By Joe 改善刪除單身無法正式刪除
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0074 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0063 06/11/14 By Ray 程序中沒有無效FUNCTION,不應該讓該功能的按紐亮著
# Modify.........: No.MOD-6C0020 06/12/08 By claire 刪除時單身刪除要於重新fetch前執行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-7C0106 07/12/08 By judy 預設上筆資料應在單身屬性值欄位
# Modify.........: No.FUN-810099 07/12/26 By Cockroach 報表改為p_query實現
# Modify.........: No.FUN-810099 08/04/17 By destiny p_query增加新功能
# Modify.........: No.FUN-870117 08/07/22 By ve007 描述說明需要有重復性說明,刪除資料時單身沒有刪除
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-930084 09/08/12 By arman 屬性代碼改為開窗查詢功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960091 09/10/23 By jan 新增'状态'页签,以及‘无效’action
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50012 10/05/12 By shaoyong 增加一個屬性字段agc07(1.顏色  2.尺寸),在服飾業中對其進行控管,可限定屬性顏色、尺碼
# Modify.........: No.FUN-A50011 10/05/20 By yangfeng 增加兩個變量接受參數，并做相應的處理 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90101 11/11/23 By lixiang  當g_azw.azw04 <> '1'時,將屬性編號agc01控制在4碼範圍
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20117 12/02/10 By lixiang 服飾BUG修改
# Modify.........: No:MOD-C30120 12/02/10 By xjll  服飾bug修改
# Modify.........: No:TQC-C30167 12/03/09 By huangrh 服飾製造不筆數，agc07
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_agc           RECORD LIKE agc_file.*,       #主件料件(假單頭)
    g_agc_t         RECORD LIKE agc_file.*,       #主件料件(舊值)
    g_agc_o         RECORD LIKE agc_file.*,       #主件料件(舊值)
    g_agc01_t       LIKE agc_file.agc01,          #(舊值)
    g_agd           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                    agd02    LIKE agd_file.agd02, #屬性可選值
                    agd03    LIKE agd_file.agd03, #說明
                    agd04    LIKE agd_file.agd04  #順序      #FUN-B90101 add
                    END RECORD,
    g_agd_t         RECORD                        #程式變數(舊值)
                    agd02    LIKE agd_file.agd02, #屬性可選值
                    agd03    LIKE agd_file.agd03, #說明
                    agd04    LIKE agd_file.agd04  #順序      #FUN-B90101 add
                    END RECORD,
    g_agd_o         RECORD                        #程式變數(舊值)
                    agd02    LIKE agd_file.agd02, #屬性可選值
                    agd03    LIKE agd_file.agd03, #說明
                    agd04    LIKE agd_file.agd04  #順序      #FUN-B90101 add
                    END RECORD,
    g_sql           string,                       #No.FUN-580092 HCN
    g_wc,g_wc2      string,                       #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,           #No.FUN-690026 DATE
    g_sw            LIKE type_file.num5,          #單位是否可轉換 #No.FUN-690026 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-690026 VARCHAR(60)
    g_rec_b         LIKE type_file.num5,          #單身筆數  #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    vdate           LIKE type_file.dat            #No.FUN-690026 DATE
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT    #No.FUN-6A0061
DEFINE g_argv1             LIKE agc_file.agc01    #No.FUN-A50011 VARCHAR2(20)
DEFINE g_argv2             LIKE agc_file.agc01    #No.FUN-A50011 VARCHAR2(20)
DEFINE l_ima_t             LIKE agc_file.agc01    #No.FUN-A50011
DEFINE l_ima940,l_ima941   LIKE agc_file.agc01    #No.FUN-A50011
#主程式開始
MAIN
#DEFINE
#    l_time        LIKE type_file.chr8                    #計算被使用時間  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    LET g_argv1 = ARG_VAL(1)               #No.FUN-A50011
    LET g_argv2 = ARG_VAL(2)
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql =
        "SELECT * FROM agc_file WHERE agc01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_curl CURSOR FROM g_forupd_sql
#No.FUN-6A0074 -- begin --
#      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
#        RETURNING l_time
      CALL cl_used(g_prog,g_time,1) RETURNING g_time 
#No.FUN-6A0074 -- end --
    LET p_row = 3 LET p_col = 20
 
    OPEN WINDOW i300_w AT p_row,p_col         #顯示畫面
         WITH FORM "aim/42f/aimi300"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()

    IF NOT s_industry('slk') THEN
       CALL cl_set_comp_visible("agc07",FALSE)
       CALL cl_set_comp_visible("agd04",FALSE)    #FUN-B90101   
       LET g_agc.agc07 =''
    END IF
#No.FUN-A50011 -- begin --
    IF NOT cl_null(g_argv1) THEN
       CALL cl_set_comp_entry("agc02,agc03,agc07",FALSE)     #FUN-B90101  
       CALL i300_q()
       DISPLAY ARRAY g_agd TO s_agd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
          BEFORE DISPLAY
             EXIT DISPLAY
       END DISPLAY
    #FUN-B90101--mark-begin-
    #  CALL i300_copy()
    #  SELECT ima940,ima941 INTO l_ima940,l_ima941 FROM ima_file WHERE ima01 = g_argv2
    #  IF g_argv1 = l_ima940 THEN
    #      UPDATE ima_file SET ima940 = l_ima_t  WHERE ima01 = g_argv2   
    #      IF SQLCA.SQLERRD[3]=0 THEN
    #          CALL cl_err3("upd","ima_file",l_ima_t,"",SQLCA.sqlcode,
    #                      "","",1)  
    #      END IF
    #  END IF 
    #  IF g_argv1 = l_ima941 THEN
    #      UPDATE ima_file SET ima941 = l_ima_t  WHERE ima01 = g_argv2   
    #      IF SQLCA.SQLERRD[3]=0 THEN
    #          CALL cl_err3("upd","ima_file",l_ima_t,"",SQLCA.sqlcode,
    #                      "","",1)  
    #      END IF
    #  END IF 
    #FUN-B90101--mark-end-
    END IF
#No.FUN-A50011 -- end --
    CALL i300_menu()
    CLOSE WINDOW i300_w                 #結束畫面
#No.FUN-6A0074 -- begin --
#      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
#        RETURNING l_time
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time
#No.FUN-6A0074 -- end --
END MAIN
 
#QBE 查詢資料
FUNCTION i300_curs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031  HCN
DEFINE l_flag      LIKE type_file.chr1     #判斷單身是否給條件  #No.FUN-690026 VARCHAR(1)
LET l_ac = ARR_CURR()
LET l_ac = 1
 
    CLEAR FORM                             #清除畫面
    CALL g_agd.clear()
  IF cl_null(g_argv1) THEN                 #No.FUN-A50011
    LET l_flag = 'N'
    LET g_vdate = g_today
    INITIALIZE g_agc.* TO NULL  #FUN-640213 add

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
  
      CONSTRUCT BY NAME g_wc ON                                       # 螢幕上取單頭條件
                        agc01,agc02,agc03,agc07,                      #FUN-960091
                        agcuser,agcgrup,agcmodu,agcdate,agcacti       #FUN-960091 #FUN-A50012
      
    
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      #No.FUN-930084  --begin--
      ON ACTION CONTROLP 
          CASE WHEN INFIELD(agc01)                                     
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state= "c"                                       
                LET g_qryparam.form = "q_agc"                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO agc01                            
                NEXT FIELD agc01                                                
          OTHERWISE EXIT CASE                                                   
          END CASE     
      #No.FUN-930084  --end--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    
#FUN-A50012 --start--
# IF  s_industry('slk') THEN
#    IF g_wc= " 1=1" THEN
#       LET g_agc.agc07 = ' '
#    ELSE
#       LET g_sql="SELECT distinct agc07 FROM agc_file WHERE ", g_wc CLIPPED
#       PREPARE i300_pre FROM g_sql 
#       DECLARE i300_cus CURSOR WITH HOLD FOR i300_pre
#       OPEN i300_cus
#       FETCH i300_cus INTO g_agc.agc07
#       CLOSE i300_cus 
#    END IF
# END IF
#FUN-A50012 --end--

    CONSTRUCT g_wc2 ON agd02,agd03,agd04                       #FUN-B90101 add agd04
                  FROM s_agd[1].agd02,s_agd[1].agd03,s_agd[1].agd04   #FUN-B90101 add agd04
      ON ACTION controlp
         IF INFIELD(agd02) THEN

           #FUN-A50012 --start--
                CALL  cl_init_qry_var()
#                IF NOT cl_null(g_agc.agc07)   THEN
#                   IF s_industry('slk') THEN
#                      IF g_agc.agc07='1' THEN LET g_qryparam.arg1=25 END IF
#                      IF g_agc.agc07='2' THEN LET g_qryparam.arg1=26 END IF
#                      LET  g_qryparam.form = "q_tqa"
##                      LET  g_qryparam.state = "c"
#                      LET  g_qryparam.default1 = g_agd[l_ac].agd02
#                      CALL cl_create_qry() RETURNING g_agd[l_ac].agd02
#                      DISPLAY g_agd[l_ac].agd02 TO agd02
#                   END IF
#                ELSE
                   LET  g_qryparam.form = "q_agd02"
                   LET  g_qryparam.state = "c"
                   LET  g_qryparam.default1 = g_agd[l_ac].agd02
                   CALL cl_create_qry() RETURNING g_agd[l_ac].agd02
                   DISPLAY g_agd[l_ac].agd02 TO agd02
#                END IF
           #FUN-A50012 --end--
         END IF

#      AFTER FIELD agd02
#        #FUN-A50012 --start--
#         IF s_industry('slk') THEN     
#            CALL i300_agd03()
#         END IF
#        #FUN-A50012 --end--

    #No.FUN-580031 --start--     HCN
     BEFORE CONSTRUCT
#        CALL cl_set_comp_entry("agd03",false)
        CALL cl_qbe_display_condition(lc_qbe_sn)
    #No.FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
#No.FUN-A50011 -- begin--
  ELSE
    LET g_wc = "agc01 = '",g_argv1,"'"
  END IF 
#No.FUN-A50011 -- end --
    IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
    IF INT_FLAG THEN RETURN END IF
     IF l_flag = 'N' THEN			# 若單身未輸入條件
        LET g_sql = "SELECT agc01 FROM agc_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY agc01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE agc_file.agc01 ",
                   "  FROM agc_file, agd_file ",
                   " WHERE agc01 = agd01",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY agc01"
     END IF
 
    PREPARE i300_prepare FROM g_sql
	DECLARE i300_curs
        SCROLL CURSOR WITH HOLD FOR i300_prepare
 
    IF l_flag = 'N' THEN			# 取合乎條件筆數
       #LET g_sql="SELECT COUNT(*) FROM agc_file WHERE ",g_wc CLIPPED                  #FUN-C20006 mark
        LET g_sql="SELECT COUNT(DISTINCT agc01) FROM agc_file WHERE ",g_wc CLIPPED     #FUN-C20006 add
    ELSE 
       #LET g_sql="SELECT COUNT(*) FROM agc_file,agd_file WHERE ",                     #FUN-C20006 mark
        LET g_sql="SELECT COUNT(DISTINCT agc01) FROM agc_file,agd_file WHERE ",        #FUN-C20006 add 
                  "agd01=agc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i300_precount FROM g_sql
    DECLARE i300_count CURSOR FOR i300_precount
END FUNCTION
 
FUNCTION i300_menu()
DEFINE  l_cmd  LIKE type_file.chr1000          #No.FUN-810099
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i300_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i300_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i300_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i300_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i300_u()
           END IF
        #FUN-960091--begin--add-------
        WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL i300_x()
            END IF
        #FUN-960091--end--add------------
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i300_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
#No.FUN-830154-begin--by--destiny
              #NO.FUN-810099 --BEGIN--
              CALL i300_out()
#              IF cl_null(g_wc) OR cl_null(g_wc2) THEN
#                LET g_wc = " 1=1"
#                LET g_wc2 = " 1=1"
#              END IF
#              LET l_cmd = 'p_query "aimi300" "',g_wc CLIPPED,'" 'AND' "',g_wc2 CLIPPED,'" '
#              CALL cl_cmdrun(l_cmd)
#              #NO.FUN-810099 --END--
#No.FUN-810099--end--
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
 
        #No.FUN-680046-------add--------str----
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_agc.agc01 IS NOT NULL THEN
                LET g_doc.column1 = "agc01"
                LET g_doc.value1 = g_agc.agc01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-680046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i300_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_agd.clear()
    INITIALIZE g_agc.* LIKE agc_file.*             #DEFAULT 設定
    LET g_agc01_t = NULL
    #預設值及將數值類變數清成零
    #NO.590002 START----------
    LET g_agc.agc04='1'
    #NO.590002 END------------
    LET g_agc_t.* = g_agc.*
    LET g_agc_o.* = g_agc.*
    CALL cl_opmsg('a')
 
    WHILE TRUE
        #FUN-960091--begin--add------
        LET g_agc.agcacti ='Y'                   #有效的資料
        LET g_agc.agcuser = g_user
        LET g_agc.agcoriu = g_user
        LET g_agc.agcorig = g_grup
        LET g_agc.agcgrup = g_grup               #使用者所屬群
        LET g_agc.agcdate = g_today
        #FUN-960091--end--add-p-------
        CALL i300_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_agc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_agc.agc01) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        #這里增加一個判斷，如果用戶選擇的使用方式不為'3.預定義範圍'，則
        #就算其中輸入了信息也不進行保存（但在輸入過程中不清空）
        IF g_agc.agc04 <> '3' THEN
           LET g_agc.agc05 = NULL
           LET g_agc.agc06 = NULL
        END IF
 
        INSERT INTO agc_file VALUES (g_agc.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#          CALL cl_err(g_agc.agc01,SQLCA.sqlcode,1) #No.FUN-660156
           CALL cl_err3("ins","agc_file",g_agc.agc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        SELECT agc01 INTO g_agc.agc01 FROM agc_file
         WHERE agc01 = g_agc.agc01
        LET g_agc01_t = g_agc.agc01        #保留舊值
        LET g_agc_t.* = g_agc.*
        CALL g_agd.clear()
        LET g_rec_b=0
 
        #這里進行了調整，根據單頭agc04的選擇情況來決定是否需要輸入單身
        IF g_agc.agc04 = '2' THEN
           CALL i300_b()                   #輸入單身
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i300_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_agc.agc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_agc01_t = g_agc.agc01
    BEGIN WORK
    OPEN i300_curl USING g_agc.agc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_curl:", STATUS, 1)
       CLOSE i300_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_curl INTO g_agc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i300_curl
        RETURN
    END IF
    LET g_agc.agcmodu = g_user     #FUN-960091             #修改者
    LET g_agc.agcdate = g_today    #FUN-960091             #修改日期
    CALL i300_show()
    WHILE TRUE
        LET g_agc_t.* = g_agc.*
        LET g_agc_o.* = g_agc.*
        LET g_agc01_t = g_agc.agc01
        CALL i300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_agc.*=g_agc_t.*
            CALL i300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_agc.agc01 != g_agc01_t THEN # 更改KEY
           UPDATE agd_file SET agd01 = g_agc.agc01
                WHERE agd01 = g_agc01_t
           IF SQLCA.sqlcode THEN
#             CALL cl_err('agd',SQLCA.sqlcode,0) #No.FUN-660156
              CALL cl_err3("upd","agd_file",g_agc01_t,"",SQLCA.sqlcode,
                           "","agd",1)  #No.FUN-660156
              CONTINUE WHILE 
           END IF
        END IF
        UPDATE agc_file SET agc_file.* = g_agc.*
         WHERE agc01 = g_agc01_t
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","agc_file",g_agc_t.agc01,"",SQLCA.sqlcode,
                        "","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        #這里進行了調整，根據單頭agc04的選擇情況來決定是否需要輸入單身
        IF g_agc.agc04 = '2' THEN
           CALL i300_b()                   #輸入單身
        ELSE
           #否則需要刪除在agd_file中可能存在的選項記錄
           #防止原來是與定義值而現在不是的的這種情況
           DELETE FROM agd_file WHERE agd01 = g_agc.agc01
           CALL g_agd.clear()
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i300_curl
    COMMIT WORK
END FUNCTION
 
#處理INPUT(單頭)
FUNCTION i300_i(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
    l_cmd     LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(40)
    l_n       LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
     
    INPUT BY NAME g_agc.agcoriu,g_agc.agcorig,  #FUN-960091
                  g_agc.agc01,g_agc.agc02,g_agc.agc03,g_agc.agc07,g_agc.agc04,
                  g_agc.agc05,g_agc.agc06,             #FUN-A50012
                  g_agc.agcuser,g_agc.agcgrup,g_agc.agcmodu,g_agc.agcdate,g_agc.agcacti  #FUN-960091
                  WITHOUT DEFAULTS
                  ATTRIBUTE(UNBUFFERED)
   
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i300_set_entry(p_cmd)
           CALL i300_set_no_entry(p_cmd)
           #MOD-C30120---add----------------
           IF p_cmd= 'a' THEN
              CALL cl_set_comp_entry("agc02,agc03,agc07",TRUE)
           END IF
           #MOD-C30120---end----------------
           LET g_before_input_done = TRUE
 
        AFTER FIELD agc01
           IF NOT cl_null(g_agc.agc01) THEN
              IF cl_null(g_agc_t.agc01) OR         # 若輸入或更改且改KEY
                (p_cmd = "u" AND g_agc.agc01 != g_agc_t.agc01) THEN
#FUN-B90101--add-----begin--------------------------------------
                 IF g_azw.azw04 <> '1' THEN
                    IF length(g_agc.agc01) >4 THEN
                       CALL cl_err('','aim234',0)   #屬性編號長度不可以大於4碼
                       LET g_agc.agc01 = g_agc_t.agc01
                       DISPLAY BY NAME g_agc.agc01
                      NEXT FIELD agc01
                     END IF
                 END IF
#FUN-B90101-------------end-------------------------------------
                  SELECT COUNT(*) INTO l_n FROM agc_file
                   WHERE agc01 = g_agc.agc01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_agc.agc01,-239,0)
                     LET g_agc.agc01 = g_agc_t.agc01
                     DISPLAY BY NAME g_agc.agc01
                     NEXT FIELD agc01
                 END IF
              END IF
           END IF
 
        AFTER FIELD agc03
           IF NOT cl_null(g_agc.agc03) THEN
              IF g_agc.agc03 <=0 THEN
                 CALL cl_err("","aim-918",0)
                 NEXT FIELD agc03
              END IF
              #如果單身已經有數據了則不允許修改使用長度
              IF g_agc.agc03 <> g_agc_t.agc03 THEN
                 SELECT COUNT(*) INTO l_n FROM agd_file
                  WHERE agd01 = g_agc.agc01
                 IF l_n > 0 THEN
                    CALL cl_err('','aim-9222',0)
                    LET g_agc.agc03 = g_agc_t.agc03
                 END IF
              END IF
           END IF
 
        BEFORE FIELD agc04
           CALL i300_set_entry(p_cmd)
 
        ON CHANGE agc04
           IF NOT cl_null(g_agc.agc04) THEN
              IF g_agc.agc04 <> '3' THEN
                 LET g_agc.agc05 = NULL
                 LET g_agc.agc06 = NULL
                 DISPLAY BY NAME g_agc.agc05,g_agc.agc06
                 CALL cl_set_comp_required("agc05,agc06",FALSE)
              ELSE
                 #如果選擇了預定義範圍方式則必須要輸入起止範圍
                 CALL cl_set_comp_required("agc05,agc06",TRUE)
              END IF
              CALL i300_set_no_entry(p_cmd)
           END IF
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
#FUN-A50012 --begin--             
           IF s_industry('slk') AND g_azw.azw04='2' THEN   #TQC-C30167
              IF cl_null(g_agc.agc07)  THEN
                 #CALL cl_err('屬性欄位',1200,0)  #FUN-C20006 mark
                  CALL cl_err('',-1124,0)         #FUN-C20006 add 
                  NEXT FIELD agc07
              END IF
           END IF
#FUN-A50012 --end--             

           #檢查範圍起止值的長度是否符合前面定義的長度規範
           IF g_agc.agc04 = '3' THEN
              IF LENGTH(g_agc.agc05) != g_agc.agc03 THEN
                 CALL cl_err('','aim-911',0)
                 NEXT FIELD agc05
              END IF
              IF LENGTH(g_agc.agc06) != g_agc.agc03 THEN
                 CALL cl_err('','aim-911',0)
                 NEXT FIELD agc06
              END IF
              #截至範圍必須大於起始範圍
              IF g_agc.agc06 <= g_agc.agc05 THEN
                 CALL cl_err('','aim-919',0)
                 NEXT FIELD agc05
              END IF
           END IF
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
 
 
#Query 查詢
FUNCTION i300_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_agd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i300_curs()
    IF INT_FLAG THEN
        INITIALIZE g_agc.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN i300_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_agc.* TO NULL
    ELSE
        OPEN i300_count
        FETCH i300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i300_curs INTO g_agc.agc01
      WHEN 'P' FETCH PREVIOUS i300_curs INTO g_agc.agc01
      WHEN 'F' FETCH FIRST    i300_curs INTO g_agc.agc01
      WHEN 'L' FETCH LAST     i300_curs INTO g_agc.agc01
      WHEN '/'
         IF (NOT mi_no_ask) THEN     #No.FUN-6A0061
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
             END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i300_curs INTO g_agc.agc01
         LET mi_no_ask = FALSE    #No.FUN-6A0061
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0)
        INITIALIZE g_agc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_agc.* FROM agc_file WHERE agc01 = g_agc.agc01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) #No.FUN-660156
        CALL cl_err3("sel","agc_file",g_agc.agc01,"",SQLCA.sqlcode,
                     "","",1)  #No.FUN-660156
        INITIALIZE g_agc.* TO NULL
        RETURN
    END IF
    CALL i300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i300_show()
    LET g_agc_t.* = g_agc.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
     g_agc.agc01,g_agc.agc02,g_agc.agc03,g_agc.agc04,g_agc.agc05,g_agc.agc06,g_agc.agc07,
     g_agc.agcoriu,g_agc.agcorig,                                           #FUN-960091  
     g_agc.agcuser,g_agc.agcgrup,g_agc.agcmodu,g_agc.agcdate,g_agc.agcacti  #FUN-960091
 
    CALL i300_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION i300_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_agc.agc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i300_curl USING g_agc.agc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_curl:", STATUS, 1)
       CLOSE i300_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_curl INTO g_agc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i300_show()
 
    #判斷是否在aimi310屬性群組作業中有引用過當前的明細屬性，如果有用到則不允許刪除
    SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb03 = g_agc.agc01
    IF l_cnt > 0 THEN   #系統中已經有屬性群組引用到了當前屬性
       CALL cl_err('Forbidden:','aim-916',1)
       RETURN
    END IF
 
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "agc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_agc.agc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM agc_file WHERE agc01=g_agc.agc01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) #No.FUN-660156
          CALL cl_err3("del","agc_file",g_agc.agc01,"",SQLCA.sqlcode,
                       "","",1)  #No.FUN-660156
#      DELETE FROM agd_file WHERE agd01=g_agc.agc01  #MOD-6C0020 add   #By FUN-870117
       ELSE
       	  DELETE FROM agd_file WHERE agd01=g_agc.agc01  #MOD-6C0020 add   #By FUN-870117
          CLEAR FORM
          CALL g_agd.clear()
          OPEN i300_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i300_curs
             CLOSE i300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i300_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i300_curs
             CLOSE i300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i300_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i300_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE     #No.FUN-6A0061
             CALL i300_fetch('/')
          END IF
       END IF
      #DELETE FROM agd_file WHERE agd01=g_agc.agc01  #MOD-6C0020 mark
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
            VALUES ('aimi300',g_user,g_today,g_msg,g_agc.agc01,'delete',g_plant,g_legal) #No.FUN-980004
    END IF
    CLOSE i300_curl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態           #No.FUN-690026 VARCHAR(1)
    l_buf           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
    l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
    l_allow_insert  LIKE type_file.num5,    #可新增否           #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否           #No.FUN-690026 SMALLINT
    l_tqa03         LIKE tqa_file.tqa03                         #No.FUN-B90101
  
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    #這里增加判斷，如果使用方式不為預定義值時則不進入單身，因為沒有單身
    IF g_agc.agc04 <> '2' THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT agd02,agd03,agd04 FROM agd_file ",          #FUN-B90101 add agd04
       " WHERE agd01=? and agd02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_b_curl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_agd WITHOUT DEFAULTS FROM s_agd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           IF s_industry('slk') THEN
            # CALL cl_set_comp_entry("agd03",FALSE)    #FUN-B90101 mark
           #FUN-B90101--add--begin--
              IF NOT cl_null(g_agc.agc07) THEN
                 CALL cl_set_comp_entry("agd03",FALSE)
                 CALL cl_set_comp_required("agd04",TRUE)
              ELSE
                 CALL cl_set_comp_entry("agd03",TRUE)
                 CALL cl_set_comp_required("agd04",FALSE)
              END IF
           #FUN-B90101--add--end--
           ELSE
              CALL cl_set_comp_entry("agd03",TRUE)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN i300_curl USING g_agc.agc01
            IF STATUS THEN
               CALL cl_err("OPEN i300_curl:", STATUS, 1)
               CLOSE i300_curl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i300_curl INTO g_agc.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE i300_curl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_agd_t.* = g_agd[l_ac].*  #BACKUP
               LET g_agd_o.* = g_agd[l_ac].*
               OPEN i300_b_curl USING g_agc.agc01,g_agd[l_ac].agd02
               IF STATUS THEN
                  CALL cl_err("OPEN i300_b_curl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i300_b_curl INTO g_agd[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_agd_t.agd02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #TQC-C20117--add--begin--
            IF s_industry('slk') THEN
               IF NOT cl_null(g_agc.agc07) THEN
                  CALL cl_set_comp_entry("agd03",FALSE)
                  CALL cl_set_comp_required("agd04",TRUE)
               ELSE
                  CALL cl_set_comp_entry("agd03",TRUE)
                  CALL cl_set_comp_required("agd04",FALSE)
               END IF
            END IF 
          #TQC-C20117--add--end--
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_agd[l_ac].* TO NULL      #900423
            LET g_agd_t.* = g_agd[l_ac].*         #新輸入資料
            LET g_agd_o.* = g_agd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD agd02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i300_b_curl
               CANCEL INSERT
            END IF
            INSERT INTO agd_file(agd01,agd02,agd03,agd04)     #FUN-B90101 add agd04
                 VALUES(g_agc.agc01,g_agd[l_ac].agd02,g_agd[l_ac].agd03,g_agd[l_ac].agd04)   #FUN-B90101 add agd04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_agd[l_ac].agd02,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("ins","agd_file",g_agc.agc01,g_agd[l_ac].agd02,SQLCA.sqlcode,
                            "","",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
    	       COMMIT WORK
            END IF
 
        AFTER FIELD agd02
            IF NOT cl_null(g_agd[l_ac].agd02) THEN
               IF p_cmd='a' OR (p_cmd = 'u' AND
                               (g_agd[l_ac].agd02 != g_agd_t.agd02 OR g_agd_t.agd02 IS NULL)) THEN
                  LET l_n=0
                  SELECT COUNT(*) INTO l_n FROM agd_file
                   WHERE agd01=g_agc.agc01 AND agd02 = g_agd[l_ac].agd02
                  IF l_n>0 THEN
                     LET g_agd[l_ac].agd02 = g_agd_t.agd02
                     CALL cl_err('',-239,0)
                     NEXT FIELD agd02
                  END IF
                  IF length(g_agd[l_ac].agd02) <> g_agc.agc03 THEN
                     CALL cl_err(g_agd[l_ac].agd02,'aim-911',0)
                     NEXT FIELD agd02
                  END IF
                # CALL i300_agd03_2()      #No.FUN-B90101 mark
                #FUN-B90101--add--begin--    
                  IF NOT cl_null(g_agc.agc07) THEN
                     IF g_agc.agc07='1' THEN LET l_tqa03 = '25' END IF
                     IF g_agc.agc07='2' THEN LET l_tqa03 = '26' END IF 
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa01 =g_agd[l_ac].agd02
                                                AND tqa03 = l_tqa03
                     IF l_n = 0 THEN
                        CALL cl_err(g_agd[l_ac].agd02,100,0)
                        LET g_agd[l_ac].agd02 = g_agd_t.agd02
                        NEXT FIELD agd02
                     ELSE    
                        SELECT tqa02 INTO g_agd[l_ac].agd03 FROM tqa_file
                             WHERE tqa01 =g_agd[l_ac].agd02
                               AND tqa03 = l_tqa03
                     END IF
                  END IF
                #FUN-B90101--add--end--
                  NEXT FIELD agd03
               END IF
            END IF
        
        BEFORE FIELD agd03
#           IF s_industry('slk') THEN
#              cl_set_comp_entry('agd03',false)
#           END IF
         
         #No.FUN-870117 --begin--
        AFTER FIELD agd03
            IF NOT cl_null(g_agd[l_ac].agd03) THEN
               IF NOT cl_null(g_agc.agc07) THEN     #No.FUN-B90101 add 
                  IF p_cmd='a' OR (p_cmd = 'u' AND
                                  (g_agd[l_ac].agd03 != g_agd_t.agd03)) THEN
                     LET l_n=0
                     SELECT COUNT(*) INTO l_n FROM agd_file
                      WHERE agd01=g_agc.agc01 AND agd03 = g_agd[l_ac].agd03
                     IF l_n>0 THEN
                        LET g_agd[l_ac].agd03 = g_agd_t.agd03
                        CALL cl_err('',-239,0) NEXT FIELD agd03
                     END IF
                  END IF
               END IF               #No.FUN-B90101 add
            END IF 
        #No.FUN-870117 --end--
        
        #FUN-B90101--add--str--
        AFTER FIELD agd04
            IF NOT cl_null(g_agd[l_ac].agd04) THEN
               IF g_agd[l_ac].agd04 <= 0 THEN
                  LET g_agd[l_ac].agd04 = g_agd_t.agd04
                  CALL cl_err('','aim-040',0)
                  NEXT FIELD agd04
               END IF 
               IF p_cmd='a' OR (p_cmd = 'u' AND
                               (g_agd[l_ac].agd04 != g_agd_t.agd04 OR g_agd_t.agd04 IS NULL)) THEN
                  LET l_n=0
                  SELECT COUNT(*) INTO l_n FROM agd_file
                   WHERE agd01=g_agc.agc01 AND agd04=g_agd[l_ac].agd04
                  IF l_n>0 THEN
                     LET g_agd[l_ac].agd04 = g_agd_t.agd04
                     CALL cl_err('',-239,0) NEXT FIELD agd04
                  END IF
               END IF
            ELSE
               IF NOT cl_null(g_agc.agc07) THEN
                  CALL cl_err('',-1124,0)
                  NEXT FIELD agd04
               END IF 
            END IF
        #FUN-B90101--add--end--

        BEFORE DELETE      #是否取消單身
        ## NO.MOD-660041----------------------------------------------
        ## IF g_agd_t.agd02 > 0 AND (NOT cl_null(g_agd_t.agd02)) THEN
        ## NO.MOD-660041----------------------------------------------
           IF (NOT cl_null(g_agd_t.agd02)) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM agd_file
        ## NO.MOD-660041----------------------------------------------
          ##    WHERE agd01 = g_agc.agc01 AND agd02 = g_agc.agc02
                WHERE agd01 = g_agc.agc01 AND agd02 = g_agd[l_ac].agd02
        ## NO.MOD-660041----------------------------------------------
               IF SQLCA.sqlcode OR g_success='N' THEN
#                 CALL cl_err(g_agd_t.agd02,SQLCA.sqlcode,0) #No.FUN-660156
                  CALL cl_err3("del","agd_file",g_agc.agc01,g_agd[l_ac].agd02,SQLCA.sqlcode,
                               "","",1)  #No.FUN-660156
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_agd[l_ac].* = g_agd_t.*
               CLOSE i300_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_agd[l_ac].agd03,-263,1)
               LET g_agd[l_ac].* = g_agd_t.*
            ELSE
               UPDATE agd_file
                  SET agd02=g_agd[l_ac].agd02,
                      agd03=g_agd[l_ac].agd03,          
                      agd04=g_agd[l_ac].agd04     #FUN-B90101 add 
                WHERE agd01=g_agc.agc01
                  AND agd02=g_agd_t.agd02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_agd[l_ac].agd02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("upd","agd_file",g_agc.agc01,g_agd_t.agd02,SQLCA.sqlcode,
                                "","",1)  #No.FUN-660156
                   LET g_agd[l_ac].* = g_agd_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
    	           COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_agd[l_ac].* = g_agd_t.*
                #FUN-D40030--add--str--
                ELSE
                   CALL g_agd.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D40030--add--end--
               END IF
               CLOSE i300_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i300_b_curl
            COMMIT WORK
 
     ON ACTION CONTROLN
            CALL i300_b_askkey()
            EXIT INPUT
 
     ON ACTION CONTROLO                       #沿用所有欄位
 #         IF INFIELD(agd03) AND l_ac > 1 THEN  #TQC-7C0106
           IF INFIELD(agd02) AND l_ac > 1 THEN  #TQC-7C0106
              LET g_agd[l_ac].* = g_agd[l_ac-1].*
         #    LET g_agd[l_ac].agd02 = NULL #TQC-7C0106
              NEXT FIELD agd02
           END IF
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
            CALL cl_cmdask()
      ON ACTION controlp
         IF INFIELD(agd02) THEN
           #FUN-A50012 --begin--
                CALL  cl_init_qry_var()
                IF s_industry('slk') AND g_azw.azw04='2' THEN  #TQC-C30167add azw04='2'
                   IF NOT cl_null(g_agc.agc07)   THEN
                      IF g_agc.agc07='1' THEN LET g_qryparam.arg1=25 END IF
                      IF g_agc.agc07='2' THEN LET g_qryparam.arg1=26 END IF
                      LET  g_qryparam.form = "q_tqa"
                      LET  g_qryparam.default1 = g_agd[l_ac].agd02
                      CALL cl_create_qry() RETURNING g_agd[l_ac].agd02
                      DISPLAY g_agd[l_ac].agd02 TO agd02
                   END IF
            #FUN-B90101--mark--begin--
            #TQC-C30167modify---begin--
               ELSE
                  IF NOT cl_null(g_agc.agc07)   THEN
                     IF g_agc.agc07='1' THEN LET g_qryparam.arg1=25 END IF
                     IF g_agc.agc07='2' THEN LET g_qryparam.arg1=26 END IF
                     LET  g_qryparam.form = "q_tqa"
                  ELSE
                     LET  g_qryparam.form = "q_tqa02"
                  END IF
                  LET  g_qryparam.default1 = g_agd[l_ac].agd02
                  CALL cl_create_qry() RETURNING g_agd[l_ac].agd02
                  DISPLAY g_agd[l_ac].agd02 TO agd02
            #TQC-C30167modify---end--
            #FUN-B90101--mark--end--
                END IF 
           #FUN-A50012 --end--
         END IF
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
    END INPUT
   
    #FUN-960091--begin--add-----------
    LET g_agc.agcmodu = g_user
    LET g_agc.agcdate = g_today
    UPDATE agc_file SET agcmodu = g_agc.agcmodu,agcdate = g_agc.agcdate
     WHERE agc01 = g_agc.agc01
    DISPLAY BY NAME g_agc.agcmodu,g_agc.agcdate
    #FUN-960091--end--add------------
 
    CLOSE i300_b_curl
    COMMIT WORK
    CALL i300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i300_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM agc_file WHERE agc01 = g_agc.agc01
         INITIALIZE g_agc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#單身重查
FUNCTION i300_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CLEAR agc02,agc03
    CONSTRUCT l_wc2 ON agd02,agd03 # 螢幕上取單身條件
         FROM s_agd[1].agd02,s_agd[1].agd03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
 
    LET g_sql =
        "SELECT agd02,agd03,agd04",     #FUN-B90101 add agd04
        "  FROM agd_file",
        "  WHERE agd01 ='",g_agc.agc01,"' ",
        "   AND ",p_wc2 CLIPPED
 
    PREPARE i300_pb FROM g_sql
    DECLARE agd_curs                       #SCROLL CURSOR
        CURSOR FOR i300_pb
 
    CALL g_agd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH agd_curs INTO g_agd[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_agd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i300_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_agd TO s_agd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION invalid                  #FUN-960091
         LET g_action_choice="invalid"   #FUN-960091
         EXIT DISPLAY                    #FUN-960091
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#No.TQC-6B0063 --begin
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
#No.TQC-6B0063 --end
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION related_document                #No.FUN-680046相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
            CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
  
 END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#NO.FUN-810099 --BEGIN--
FUNCTION i300_out()
#   DEFINE
#       l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_name          LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_za05          LIKE za_file.za05,
#       sr RECORD
#            agc01      LIKE agc_file.agc01,
#            agc02      LIKE agc_file.agc02,
#            agc03      LIKE agc_file.agc03,
#            agc04      LIKE agc_file.agc04,
#            l_desc     LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(16)
#            agc05      LIKE agc_file.agc05,
#            agc06      LIKE agc_file.agc06,
#            agd02      LIKE agd_file.agd02,
#            agd03      LIKE agd_file.agd03
#       END RECORD
DEFINE  l_cmd  LIKE type_file.chr1000          #No.FUN-810099                                                                       
#NO.FUN-810099 --BEGIN--                                                                                                            
    IF cl_null(g_wc) AND NOT cl_null(g_agc.agc01) AND NOT cl_null(g_agc.agc02) AND NOT cl_null(g_agc.agc03) THEN                    
        LET g_wc = "agc01='",g_agc.agc01,"' AND agc02='",g_agc.agc02,"' AND agc03='",g_agc.agc03,"'"                                
    END IF                                                                                                                          
    IF cl_null(g_wc)  THEN                                                                                                          
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF cl_null(g_wc2) then                                                                                                          
        LET g_wc2 = " 1=1"                                                                                                          
    END IF                                                                                                                          
    LET l_cmd = 'p_query "aimi300" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'" '                                                         
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN                                                                                                                          
#NO.FUN-810099 --END-- 
#   CALL cl_wait()
#   CALL cl_outnam('aimi300') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT agc01,agc02,agc03,agc04,'',agc05,agc06,agd02,agd03",
#             "  FROM agc_file,agd_file",   # 組合出 SQL 指令
#             "  WHERE agc01=agd_file.agd01(+)",
#             "   AND ",g_wc CLIPPED ,
#             "   AND ",g_wc2 CLIPPED ,
#             " ORDER BY agc01,agd_file.agd02 "
#   PREPARE i300_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i300_co CURSOR FOR i300_p1
 
#   START REPORT i300_rep TO l_name
 
#   FOREACH i300_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       CASE WHEN sr.agc04 = '1'
#               CALL cl_getmsg('aim-913',g_lang) RETURNING sr.l_desc
#            WHEN sr.agc04 = '2'
#               CALL cl_getmsg('aim-914',g_lang) RETURNING sr.l_desc
#            WHEN sr.agc04 = '3'
#               CALL cl_getmsg('aim-915',g_lang) RETURNING sr.l_desc
#            OTHERWISE  LET sr.l_desc = ''
#       END CASE
#       OUTPUT TO REPORT i300_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i300_rep
 
#   CLOSE i300_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i300_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr RECORD
#            agc01      LIKE agc_file.agc01,
#            agc02      LIKE agc_file.agc02,
#            agc03      LIKE agc_file.agc03,
#            agc04      LIKE agc_file.agc04,
#            l_desc     LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(16)
#            agc05      LIKE agc_file.agc05,
#            agc06      LIKE agc_file.agc06,
#            agd02      LIKE agd_file.agd02,
#            agd03      LIKE agd_file.agd03
#       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH 66
 
#   ORDER BY sr.agc01,sr.agd02
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
 
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           PRINT
#           PRINT g_dash[1,g_len]
 
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                 g_x[35],g_x[36],g_x[37],g_x[38],
#                 g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.agc01
#           PRINT COLUMN g_c[31],sr.agc01,
#                 COLUMN g_c[32],sr.agc02,
#                 COLUMN g_c[33],sr.agc03 USING '--------',
#                 COLUMN g_c[34],sr.agc04,
#                 COLUMN g_c[35],sr.l_desc;
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[36],sr.agc05,
#                 COLUMN g_c[37],sr.agc06,
#                 COLUMN g_c[38],sr.agd02,
#                 COLUMN g_c[39],sr.agd03
 
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
#NO.FUN-810099 --END--
 
#FUN-960091--begin--add-------------------
FUNCTION i300_x()
    DEFINE
        l_chr LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    IF g_agc.agc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i300_curl USING g_agc.agc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_curl:", STATUS, 1)
       CLOSE i300_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_curl INTO g_agc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0)
        CLOSE i300_curl ROLLBACK WORK RETURN
    END IF
    CALL i300_show()
 
    IF cl_exp(0,0,g_agc.agcacti) THEN
        LET g_chr=g_agc.agcacti
        IF g_agc.agcacti='Y' THEN
            LET g_agc.agcacti='N'
        ELSE
            LET g_agc.agcacti='Y'
        END IF
        UPDATE agc_file
            SET agcacti=g_agc.agcacti,
                agcmodu=g_user, agcdate=g_today
            WHERE agc01=g_agc.agc01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","agc_file",g_agc.agc01,"",SQLCA.sqlcode,"","",1)
            LET g_agc.agcacti=g_chr
        END IF
        DISPLAY BY NAME g_agc.agcacti 
    END IF
    CLOSE i300_curl
    COMMIT WORK
END FUNCTION
#FUN-960091--end--add------------------
 
FUNCTION i300_copy()
DEFINE
    new_ver     LIKE agc_file.agc01,
    old_ver     LIKE agc_file.agc01,
    l_n         LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_agc.agc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE   #FUN-580026
   CALL i300_set_entry('a')             #FUN-580026
   LET g_before_input_done = TRUE    #FUN-580026
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 WHILE TRUE
   INPUT new_ver FROM agc01
       AFTER FIELD agc01
           IF NOT cl_null(new_ver) THEN
              SELECT COUNT(*) INTO l_n FROM agc_file
               WHERE agc01 = new_ver
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err(new_ver,-239,0)
                 NEXT FIELD agc01
              END IF
           END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY BY NAME g_agc.agc01
      LET l_ima_t = g_agc.agc01
      RETURN
   END IF
   IF new_ver IS NULL THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 IF l_ima_t IS NULL THEN
   LET l_ima_t = new_ver         #No.FUN-A50011
 END IF
   DROP TABLE y
   SELECT * FROM agc_file
    WHERE agc01=g_agc.agc01
     INTO TEMP y
    UPDATE y
       SET agc01 = new_ver,
           agcuser=g_user,   #資料所有者      #FUN-960091
           agcgrup=g_grup,   #資料所有者所屬群#FUN-960091
           agcmodu=NULL,     #資料修改日期    #FUN-960091
           agcdate=g_today,  #資料建立日期    #FUN-960091
           agcacti='Y'       #有效資料        #FUN-960091
   INSERT INTO agc_file
      SELECT * FROM y
 
   DROP TABLE x
   SELECT * FROM agd_file
       WHERE agd01=g_agc.agc01
        INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) #No.FUN-660156
      CALL cl_err3("ins","x",g_agc.agc01,"",SQLCA.sqlcode,
                   "","",1)  #No.FUN-660156
      RETURN
   END IF
   UPDATE x
      SET agd01=new_ver
   INSERT INTO agd_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_agc.agc01,SQLCA.sqlcode,0) #No.FUN-660156
      CALL cl_err3("ins","agd_file",g_agc.agc01,"",SQLCA.sqlcode,
                   "","",1)  #No.FUN-660156
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_ver,') OK'
      ATTRIBUTE(REVERSE)
   LET old_ver = g_agc.agc01
   SELECT agc_file.* INTO g_agc.* FROM agc_file
    WHERE agc01=new_ver
   CALL i300_u()
   CALL i300_b()
   #SELECT agc_file.* INTO g_agc.* FROM agc_file #FUN-C30027
   # WHERE agc01= old_ver                        #FUN-C30027
   CALL i300_show()
END FUNCTION
 
FUNCTION i300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("agc01",TRUE)
    END IF
 
    IF g_agc.agc04 = '3' THEN
       CALL cl_set_comp_entry("agc05,agc06",TRUE)
    ELSE
       CALL cl_set_comp_entry("agc05,agc06",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("agc01",FALSE)
    END IF
 
    IF g_agc.agc04 != '3' THEN
       CALL cl_set_comp_entry("agc05,agc06",FALSE)
    ELSE
       CALL cl_set_comp_entry("agc05,agc06",TRUE)
    END IF
 
END FUNCTION

FUNCTION i300_agd03()
    DEFINE l_agd03 LIKE agd_file.agd03
    LET g_sql="SELECT agd02 FROM agd_file WHERE ", g_wc2 CLIPPED
    PREPARE i300_pre2 FROM g_sql 
    DECLARE i300_cus2 CURSOR WITH HOLD FOR i300_pre2
    OPEN i300_cus2
    FETCH i300_cus2 INTO g_agd[l_ac].agd02
    CLOSE i300_cus2 
    SELECT agd03 INTO g_agd[l_ac].agd03 FROM agd_file
           WHERE
  agd02 =g_agd[l_ac].agd02
    DISPLAY g_agd[l_ac].agd03 TO agd03
END FUNCTION

#FUN-A50012 --begin--
FUNCTION i300_agd03_2()
    DEFINE l_tqa03  LIKE tqa_file.tqa03
    DEFINE l_n      LIKE type_file.num5                #FUN-B90101 add  
    IF g_agc.agc07='1' THEN LET l_tqa03 = '25' END IF
    IF g_agc.agc07='2' THEN LET l_tqa03 = '26' END IF
    SELECT tqa02 INTO g_agd[l_ac].agd03 FROM tqa_file   
     WHERE tqa01 =g_agd[l_ac].agd02                    
       AND tqa03 = l_tqa03                            
    DISPLAY g_agd[l_ac].agd03 TO agd03
END FUNCTION
#FUN-A50012 --end--
#Patch....NO.TQC-610036 <> #
