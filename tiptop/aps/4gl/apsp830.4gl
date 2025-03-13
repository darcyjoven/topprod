# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsp830.4gl
# Descriptions...: APS規劃結果加班資訊自動更新作業
# Date & Author..: 08/04/23 By rainy  #FUN-840156
# Modify.........: No:FUN-840209 08/05/22 By Mandy g_dbs =>g_plant
# Modify.........: No:FUN-870042 08/07/08 BY duke change vol to vnc
# Modify.........: No:FUN-870099 08/07/21 by duke 可重覆勾選
# Modify.........: No:FUN-890014 08/09/02 by duke 是否排程欄位從畫面上拿掉,該欄位vol07不用了.
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:FUN-960009 09/06/02 By Duke 調整加班資訊更新規則並加入對照表畫面
# Modify.........: No:FUN-A30109 10/03/29 By Lilan 當單身異動碼全為"0:不變"時,沒有可以更新的資料時,處理異常
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版----------------------end---

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-840156
#模組變數(Module Variables)
DEFINE
    g_vol01         LIKE vol_file.vol01,
    g_vol02         LIKE vol_file.vol02,
    g_vol01_t       LIKE vol_file.vol01, #FUN-960009 ADD
    g_vol02_t       LIKE vol_file.vol02, #FUN-960009 ADD
    g_vol1          DYNAMIC ARRAY OF RECORD #加班資訊  FUN-870042
        vol11          LIKE vol_file.vol11,   #更新否
        vol12          LIKE vol_file.vol12,   #異動碼 0:不變，1:新增，2:刪除，3:修改 #FUN-960009 ADD
        vol08          LIKE vol_file.vol08,   #是否外包
        vol09          LIKE vol_file.vol09,   #資源型態
        vol03          LIKE vol_file.vol03,   #資源編號
        vol10          LIKE vol_file.vol10,   #加班型態
        vol04          LIKE vol_file.vol04,   #日期
        vol05          LIKE vol_file.vol05,   #開始時間(整數)
        vol05_2         LIKE vbc_file.vbc031,  #開始時間(日期)
        vol06          LIKE vol_file.vol06,   #結束時間(整數)
        vol06_2         LIKE vbc_file.vbc041,  #結束時間(日期)
        vol07          LIKE vol_file.vol07,   #排程  #FUN-890014 MARK #FUN-960009 UNMARK
        vol11a         LIKE vol_file.vol11,
        vol05a         LIKE vol_file.vol05, 
        vol05b         LIKE vol_file.vol05,
        vol05c         LIKE vol_file.vol05,
        vol06a         LIKE vol_file.vol06,
        vol06b         LIKE vol_file.vol06,
        vol06c         LIKE vol_file.vol06,
        vol04_1        LIKE type_file.num5,   #FUN-960009 ADD
        vol04_2        LIKE type_file.num5    #FUN-960009 ADD
                    END RECORD,
   #FUN-960009 ADD --STR-----------------------------------------------
    g_vnc1          DYNAMIC ARRAY OF RECORD #加班資訊  
        vnc06          LIKE vnc_file.vnc06,   #是否外包
        vnc07          LIKE vnc_file.vnc07,   #資源型態
        vnc01          LIKE vnc_file.vnc01,   #資源編號
        vnc02          LIKE vnc_file.vnc02,   #日期
        vnc08          LIKE vnc_file.vnc08,   #加班型態
        vnc031         LIKE vnc_file.vnc031,  #起始時間
        vnc041         LIKE vnc_file.vnc041,  #結束時間
        vnc05          LIKE vnc_file.vnc05    #是否排程
                   END RECORD,
    g_vnc2          DYNAMIC ARRAY OF RECORD #加班資訊
        vnc06          LIKE vnc_file.vnc06,   #是否外包
        vnc07          LIKE vnc_file.vnc07,   #資源型態
        vnc08          LIKE vnc_file.vnc08,   #加班型態
        vnc01          LIKE vnc_file.vnc01,   #加班型態
        vnc09          LIKE vnc_file.vnc09,   #加班型態
        vnc10          LIKE vnc_file.vnc10   #加班型態 
                   END RECORD,
   #FUN-960009 ADD --END-----------------------------------------------
    g_wc            STRING,  
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4   LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,            #FUN-960009 ADD
    g_sql           STRING, 
    g_cmd           LIKE type_file.chr1000,       
    g_t1            LIKE type_file.chr5,          
    l_ac,l_ac2,l_ac3,l_ac4   LIKE type_file.num5,     #目前處理的ARRAY CNT      
    g_up            LIKE type_file.chr1,             #FUN-960009 ADD
    l_ac_t          LIKE type_file.num5              #FUN-960009 ADD 

#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5          
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE  g_before_input_done  LIKE type_file.num5         
DEFINE  g_chr           LIKE type_file.chr1          
DEFINE  g_cnt           LIKE type_file.num10         
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03        

DEFINE  g_row_count    LIKE type_file.num10         
DEFINE  g_curs_index   LIKE type_file.num10         
DEFINE  g_jump         LIKE type_file.num10         
DEFINE  mi_no_ask      LIKE type_file.num5          
DEFINE  g_void         LIKE type_file.chr1          



MAIN
#FUN-B50022--mod---str---
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT	 
#FUN-B50022--mod---end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   

    LET p_row = 4 LET p_col = 5

    OPEN WINDOW p830_w AT 2,2 WITH FORM "aps/42f/apsp830"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()

    CALL cl_set_comp_entry('vol11',FALSE);   #FUN-960009 ADD

    CALL p830_default()
    CALL p830_menu()

    CLOSE WINDOW p830_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN


#QBE 查詢資料
FUNCTION p830_cs()

 DEFINE  l_type          LIKE type_file.chr2        
 DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM                             #清除畫面
   CALL g_vol1.clear()
   CALL g_vnc1.clear()   #FUN-960009 ADD  

   INITIALIZE g_vol01 TO NULL   
   INITIALIZE g_vol02 TO NULL   

   CONSTRUCT BY NAME g_wc ON vol01,vol02
     BEFORE CONSTRUCT
        CALL cl_qbe_init()

   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(vol01)
            CALL cl_init_qry_var()
           #FUN-960009 MOD --STR------------------------------ 
           #LET g_qryparam.state = "c"
           #LET g_qryparam.form ="q_vlz01"
           #CALL cl_create_qry() RETURNING g_qryparam.multiret
           #DISPLAY g_qryparam.multiret TO vol01
            LET g_qryparam.form = "q_vlz01"
            LET g_qryparam.default1 = g_vol01
            LET g_qryparam.arg1 = g_plant CLIPPED
            CALL cl_create_qry() RETURNING g_vol01,g_vol02  
            DISPLAY  g_vol01 TO vol01
            DISPLAY  g_vol02 TO vol02
           #FUN-960009 MOD --END------------------------------
            NEXT FIELD vol01
         OTHERWISE EXIT CASE
      END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030   #FUN-B50022

   IF INT_FLAG THEN RETURN END IF


   LET g_sql  = "SELECT UNIQUE vol01,vol02 ",
                " FROM vol_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND vol00 ='",g_plant,"'",   #FUN-960009 ADD
                " ORDER BY vol01,vol02"
   PREPARE p830_prepare FROM g_sql
   DECLARE p830_cs SCROLL CURSOR WITH HOLD FOR p830_prepare

   #FUN-960009 MOD --STR-----------------------------------------
   # LET g_sql  = "SELECT COUNT(UNIQUE vol01) ", 
   #             " FROM vol_file ",
   #             " WHERE ", g_wc CLIPPED
     LET g_sql = "SELECT COUNT(*) FROM ",
                 " (SELECT DISTINCT vol01,vol02  ",
                 "    FROM vol_file  ",
                 "    WHERE ", g_wc CLIPPED,   
                 "       AND vol00 ='",g_plant,"'",
                 " ) "
   #FUN-960009 MOD --END----------------------------------------
   PREPARE p830_precount FROM g_sql
   DECLARE p830_count CURSOR FOR p830_precount
END FUNCTION


FUNCTION p830_default()
  CALL cl_set_comp_visible("vol11a,vol05,vol06,vol05a,vol05b,vol05c,vol06a,vol06b,vol06c",FALSE)
  CALL cl_set_comp_visible("vol07,vol04_1, vol04_2",FALSE)  #FUN-960009 ADD
END FUNCTION


FUNCTION p830_menu()

   WHILE TRUE
     #FUN-960009 MOD --STR-------------------------------------------------
     #CASE
     #   WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
     #      CALL p830_bp1("G")
     #END CASE
      CALL p830_bp1()
     #FUN-960009 MOD --END-------------------------------------------------


      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_vol01_t = NULL #FUN-960009 ADD
               LET g_vol02_t = NULL #FUN-960009 ADD
               CALL p830_q()
            END IF

         WHEN "detail"
            CASE
            WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
               CALL p830_b1()
            END CASE

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_up = 'R'  #FUN-960009 ADD
        #FUN-960009 ADD --STR-------------------
         WHEN "unscheduler" #未納入排程資料
            IF cl_null(g_vol01) OR cl_null(g_vol02) THEN
               CALL cl_err('',9046,1)
            ELSE
              #DISPLAY '   ' TO FORMONLY.cnt
               CALL p830_b3_fill()
               CALL p830_bp2_refresh()
               CALL p803_bp2()
            END IF
         WHEN "upgrade" #加班資訊整批更新
            IF g_rec_b1=0 THEN
               CALL cl_err('','apm-204',1)
            ELSE
               CALL i830_upd()
            END IF
        #WHEN "reqry" #重新查詢
        #   IF cl_null(g_vol01) OR cl_null(g_vol02) THEN
        #      CALL cl_err('',9046,1)
        #   ELSE
        #      LET g_vol01_t = g_vol01
        #      LET g_vol02_t = g_vol02
        #      CALL p830_q()
        #   END IF
         WHEN "view1"
           CALL p803_bp2()

         WHEN "exporttoexcel"
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vol1),'','')
        #FUN-960009 ADD --END------------------- 


      END CASE
   END WHILE
END FUNCTION


FUNCTION p830_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   LET g_cnt = 0 #FUN-960009 ADD
   LET l_cnt = 0 #FUN-960009 ADD
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   IF g_vol01_t IS NULL THEN  #FUN-960009 ADD
      INITIALIZE g_vol01 TO NULL   
      INITIALIZE g_vol02 TO NULL   
   END IF                     #FUN-960009 ADD
   CALL g_vol1.clear()
   CALL g_vnc1.clear()  #FUN-960009 ADD

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt

   IF g_vol01_t IS NULL THEN  #FUN-960009 ADD
      CALL p830_cs()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   END IF                     #FUN-960009 ADD
   MESSAGE " SEARCHING ! "
   OPEN p830_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_vol01 TO NULL   
      INITIALIZE g_vol02 TO NULL   
      CALL g_vol1.clear()
   ELSE
      OPEN p830_count
      FETCH p830_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p830_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION


#處理資料的讀取
FUNCTION p830_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)

   CASE p_flag
      WHEN 'N' FETCH NEXT     p830_cs INTO g_vol01,g_vol02
      WHEN 'P' FETCH PREVIOUS p830_cs INTO g_vol01,g_vol02
      WHEN 'F' FETCH FIRST    p830_cs INTO g_vol01,g_vol02
      WHEN 'L' FETCH LAST     p830_cs INTO g_vol01,g_vol02
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about         
                  CALL cl_about()      
               ON ACTION help          
                  CALL cl_show_help()  
               ON ACTION controlg      
                  CALL cl_cmdask()     
            END PROMPT

            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump p830_cs INTO g_vol01,g_vol02 
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vol01,SQLCA.sqlcode,0)
      INITIALIZE g_vol01 TO NULL  
      INITIALIZE g_vol02 TO NULL  
      CLEAR FORM
      CALL g_vol1.clear()
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
   SELECT UNIQUE vol01,vol02 INTO g_vol01,g_vol02 FROM vol_file WHERE vol01 = g_vol01 AND vol02 = g_vol02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vol_file",g_vol01,g_vol02,SQLCA.sqlcode,"","",1)  
      INITIALIZE g_vol01 TO NULL  
      INITIALIZE g_vol02 TO NULL  
      CALL g_vol1.clear()
      RETURN
   END IF
   LET g_vol01_t = g_vol01 #FUN-960009 ADD
   LET g_vol02_t = g_vol02 #FUN-960009 ADD
   CALL p830_show()
END FUNCTION


#將資料顯示在畫面上
FUNCTION p830_show()
   DISPLAY g_vol01 TO vol01
   DISPLAY g_vol02 TO vol02
#   CALL cl_set_comp_visible("vol11a",FALSE)
   CALL p830_b1_fill("1=1")    #單身 一般訂單
   CALL cl_show_fld_cont()               
END FUNCTION


#一般訂單
FUNCTION p830_b1()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_vol11t        LIKE vol_file.vol11,
   l_i             LIKE type_file.num5,            
   g_rec_b         LIKE type_file.num5 

   LET g_action_choice = ""

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_vol01) OR cl_null(g_vol02) THEN RETURN END IF
 
   IF g_rec_b1 = 0 THEN RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT vol00,vol01, ",
                      "      case when vol11 is null then 0 else vol11 end vol11, ",
                      "      vol08,vol09,vol03,vol10,vol04,vol05,' ',vol06,' ', ",
                      "      case when vol11 is null then 0 else vol11 end vol11a, ",
                     #FUN-B50022---mod---str---
                     #"      TRUNC(vol05/3600) vol05a,TRUNC((vol05-(TRUNC(vol05/3600)*3600))/60) vol05b,mod(vol05,60) vol05c, ",
                     #"      TRUNC(vol06/3600) vol06a,TRUNC((vol06-(TRUNC(vol06/3600)*3600))/60) vol06b,mod(vol06,60) vol06c  ",
                      "      CAST(vol05/3600 AS INT) vol05a,CAST((vol05-(CAST(vol05/3600 AS INT)*3600))/60 AS INT) vol05b,mod(vol05,60) vol05c, ",
                      "      CAST(vol06/3600 AS INT) vol06a,CAST((vol06-(CAST(vol06/3600 AS INT)*3600))/60 AS INT) vol06b,mod(vol06,60) vol06c  ",
                     #FUN-B50022---mod---end---
                      " FROM vol_file",
                      " WHERE vol00=? AND vol01=? AND vol02=? AND vol03=? AND vol04=? ",
                      "               AND vol05=? AND vol08=? AND vol09=? FOR UPDATE" #FUN-B50022 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)									  #FUN-B50022 add
   DECLARE p830_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_vol1 WITHOUT DEFAULTS FROM s_arr1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

     BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

     BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT

        BEGIN WORK
        IF g_rec_b1 >= l_ac THEN
           LET p_cmd='u'
           OPEN p830_b1_cl USING g_plant,g_vol01,g_vol02,g_vol1[l_ac].vol03,
                           g_vol1[l_ac].vol04,g_vol1[l_ac].vol05,g_vol1[l_ac].vol08,g_vol1[l_ac].vol09 #FUN-840209
           IF STATUS THEN
              CALL cl_err("OPEN p830_b1_cl:", STATUS, 1)
              LET l_lock_sw = "Y"
           END IF
           LET l_vol11t = g_vol1[l_ac].vol11
           
        END IF


       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_vol1[l_ac].vol11 = l_vol11t
             CLOSE p830_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF

       #FUN-870099  可重覆勾選
       #AFTER FIELD vol11
       #   IF g_vol1[l_ac].vol11a='1' AND g_vol1[l_ac].vol11=0 THEN 
       #      CALL cl_err('','aps-708',1)
       #      LET g_vol1[l_ac].vol11=1
       #      NEXT FIELD vol11
       #   END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_vol1[l_ac].vol11 = l_vol11t
             END IF
             CLOSE p830_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE p830_b1_cl
          COMMIT WORK

      #FUN-960009 MARK --STR-------------------------------------------- 
      # ON ACTION all_yes
      #     FOR l_i = 1 TO g_rec_b1
      #         LET g_vol1[l_i].vol11 = 1
      #         DISPLAY BY NAME g_vol1[l_i].vol11
      #     END FOR
      #
      # ON ACTION all_no
      #     FOR l_i = 1 TO g_rec_b1
      #         IF g_vol1[l_i].vol11a='0' THEN
      #            LET g_vol1[l_i].vol11 = 0
      #            DISPLAY BY NAME g_vol1[l_i].vol11
      #         END IF
      #     END FOR
      #
      # ON ACTION accept
      #    IF g_rec_b1=0 THEN
      #       RETURN
      #    ELSE
      #       CALL i830_upd()
      #       EXIT INPUT
      #    END IF 
      #FUN-960009 MARK --END---------------------------------------------

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT

   CLOSE p830_b1_cl
   COMMIT WORK
END FUNCTION


#一般訂單
FUNCTION p830_b1_fill(p_wc1)
DEFINE l_sql1   STRING  #FUN-B50022 add
DEFINE l_sql2   STRING  #FUN-B50022 add
DEFINE
#    p_wc1           LIKE type_file.chr1000  
     p_wc1         STRING     #NO.FUN-910082   

      IF cl_null(p_wc1) THEN  LET  p_wc1 = ' 1=1 ' END IF 

      LET l_sql1 = cl_tp_tochar('vol04','yyyy') #FUN-B50022 add
      LET l_sql2 = cl_tp_tochar('vol04','mm')   #FUN-B50022 add

      LET g_sql = "SELECT case when vol11 is null then 0 else vol11 end vol11, ",
                  "       case when vol12 is null then 0 else vol12 end vol12, ",  #FUN-960009 ADD
                  "       vol08,vol09,vol03,vol10,vol04,vol05,' ', ",
                 #"       vol06,' ',case when vol11 is null then 0 else vol11 end vol11a,  ",   #FUN-960009 MARK
                  "       vol06,' ',vol07,case when vol11 is null then 0 else vol11 end vol11a,  ",   #FUN-960009 ADD
                 #FUN-B50022--mod---str---
                 #"       TRUNC(vol05/3600) vol05a,TRUNC((vol05-(TRUNC(vol05/3600)*3600))/60) vol05b,mod(vol05,60) vol05c, ",
                 #"       TRUNC(vol06/3600) vol06a,TRUNC((vol06-(TRUNC(vol06/3600)*3600))/60) vol06b,mod(vol06,60) vol06c,  ",
                  "        CAST(vol05/3600 AS INT) vol05a,CAST((vol05-(CAST(vol05/3600 AS INT)*3600))/60 AS INT) vol05b,mod(vol05,60) vol05c, ",
                  "        CAST(vol06/3600 AS INT) vol06a,CAST((vol06-(CAST(vol06/3600 AS INT)*3600))/60 AS INT) vol06b,mod(vol06,60) vol06c,  "
                 #"            to_char(vol04,'yyyy') vol04_1,      to_char(vol04,'mm') vol04_2  ",  #FUN-960009 ADD            #FUN-B50022 mark
      LET g_sql = g_sql CLIPPED,l_sql1 CLIPPED," vol04_1,",l_sql2 CLIPPED," vol04_2 ",
                 #FUN-B50022--mod---end---
                  "  FROM vol_file ",
                  "  WHERE vol00 ='",g_plant,"'",  
                  "   AND vol01 ='",g_vol01,"'",
                  "   AND vol02 ='",g_vol02,"'",
                  "   AND ",p_wc1 CLIPPED,
                 #"   ORDER BY vol08,vol09,vol03 "                   #FUN-960009 MARK
                  "   ORDER BY vol08,vol09,vol03,vol04,vol10,vol05 " #FUN-960009 ADD
    PREPARE p830_pb1 FROM g_sql
    DECLARE vol1_curs1 CURSOR FOR p830_pb1

    CALL g_vol1.clear()
    LET g_cnt= 1
    LET l_cnt = 0    #FUN-960009 ADD
    FOREACH vol1_curs1 INTO g_vol1[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #FUN-960009 ADD --STR----------------
       IF g_vol1[g_cnt].vol10 = 0 AND g_vol1[g_cnt].vol12 MATCHES '[013]' THEN
          LET l_cnt = l_cnt + 1
       END IF
      #FUN-960009 ADD --END----------------
       LET g_cnt=g_cnt+1
       IF g_vol1[g_cnt-1].vol05a=0 then 
          LET g_vol1[g_cnt-1].vol05_2 = '00:'
       ELSE
         IF g_vol1[g_cnt-1].vol05a<10 then
            LET g_vol1[g_cnt-1].vol05_2 = '0',g_vol1[g_cnt-1].vol05a using '#',':'
         ELSE
            LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05a using '##',':'
         END IF
       END IF  
       IF g_vol1[g_cnt-1].vol05b=0 then
          LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,'00:'
       ELSE
         IF g_vol1[g_cnt-1].vol05b<10 then
            LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,'0',g_vol1[g_cnt-1].vol05b using '#',':'
         ELSE
            LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,g_vol1[g_cnt-1].vol05b using '##',':'
         END IF
       END IF
       IF g_vol1[g_cnt-1].vol05c=0 then
          LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,'00'
       ELSE
          IF g_vol1[g_cnt-1].vol05c<10 then
             LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,'0',g_vol1[g_cnt-1].vol05c using '#'
          ELSE
             LET g_vol1[g_cnt-1].vol05_2 = g_vol1[g_cnt-1].vol05_2,g_vol1[g_cnt-1].vol05c using '##'
          END IF
       END IF

       IF g_vol1[g_cnt-1].vol06a=0 then
          LET g_vol1[g_cnt-1].vol06_2 = '00:'
          ELSE
             IF g_vol1[g_cnt-1].vol06a<10 then
                LET g_vol1[g_cnt-1].vol06_2 = '0',g_vol1[g_cnt-1].vol06a using '#',':'
                ELSE
                   LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06a using '##',':'
             END IF
       END IF
       IF g_vol1[g_cnt-1].vol06b=0 then
          LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,'00:'
          ELSE
             IF g_vol1[g_cnt-1].vol06b<10 then
                LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,'0',g_vol1[g_cnt-1].vol06b using '#',':'
                ELSE
                   LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,g_vol1[g_cnt-1].vol06b using '##',':'
             END IF
       END IF
       IF g_vol1[g_cnt-1].vol06c=0 then
          LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,'00'   #FUN-870099
          ELSE
             IF g_vol1[g_cnt-1].vol06c<10 then
                LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,'0',g_vol1[g_cnt-1].vol06c using '#'
                ELSE
                   LET g_vol1[g_cnt-1].vol06_2 = g_vol1[g_cnt-1].vol06_2,g_vol1[g_cnt-1].vol06c using '##'
             END IF
       END IF

       DISPLAY BY NAME g_vol1[g_cnt-1].vol05_2
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_vol1.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    #DISPLAY g_rec_b1 TO FORMONLY.cn2  #FUN-960009 MARK
END FUNCTION



#一般訂單
#FUNCTION p830_bp1(p_ud)  #FUN-960009 MARK
 FUNCTION p830_bp1()  #FUN-960009 ADD

   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)

  #FUN-960009 MOD --STR-------------------------------
  #IF p_ud <> "G" OR g_action_choice = "detail" THEN
  #   RETURN
  #END IF
   IF g_up = "V" THEN
      RETURN
   END IF
  #FUN-960009 MOD --END-------------------------------

   #DISPLAY g_rec_b1 TO FORMONLY.cn2  #FUN-960009 MARK

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)


   DISPLAY ARRAY g_vol1 TO s_arr1.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        #FUN-960009 ADD --STR----------------------------
         IF g_cnt =0 THEN
            CALL cl_set_action_active("upgrade,unscheduler,reqry",FALSE)
         ELSE
            CALL cl_set_action_active("upgrade,unscheduler,reqry",TRUE)
         END IF
         IF l_cnt = 0 OR cl_null(l_cnt) THEN
            CALL cl_set_action_active("upgrade",FALSE)
         ELSE
            CALL cl_set_action_active("upgrade",TRUE)
         END IF
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

        #FUN-960009 ADD --END----------------------------  

      BEFORE ROW
         LET l_ac = ARR_CURR()
        #FUN-960009 ADD --STR-----------
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL p830_b2_fill()
         CALL p830_bp2_refresh()
        #FUN-960009 ADD --END----------

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #FUN-960009 MARK --STR--------------
     #ON ACTION detail
     #   LET g_action_choice="detail"
     #   EXIT DISPLAY
     #FUN-960009 MARK --END-------------

      ON ACTION first
         CALL p830_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY

      ON ACTION previous
         CALL p830_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL p830_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL p830_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL p830_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

     #FUN-960009 ADD --STR---------------
      ON ACTION unscheduler
         LET g_action_choice = "unscheduler"
         EXIT DISPLAY

      ON ACTION upgrade
         LET g_action_choice = "upgrade" 
         EXIT DISPLAY

     #ON ACTION reqry
     #   LET g_action_choice = "reqry"
     #   EXIT DISPLAY

     ON ACTION view1
        LET g_action_choice = "view1"
        EXIT DISPLAY

     ON ACTION exporttoexcel
        LET g_action_choice = 'exporttoexcel'
        EXIT DISPLAY

     #FUN-960009 ADD --END---------------


      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#FUN-960009 ----mod----str----
FUNCTION i830_upd()
DEFINE    l_i   LIKE type_file.num5
DEFINE    l_i2  LIKE type_file.num5
   
  LET  l_i2 = 0
  FOR  l_i = 1 to g_rec_b1
       IF g_vol1[l_i].vol10=0 AND
         #g_vol1[l_i].vol12 MATCHES '[013]' THEN #0:不變 1:新增 2:刪除 3:修改  #FUN-A30109 mark
          g_vol1[l_i].vol12 MATCHES '[123]' THEN #0:不變 1:新增 2:刪除 3:修改  #FUN-A30109 add
          LET l_i2 = l_i2 + 1
       END IF
  END FOR

  LET l_i = 1

  IF  l_i2 >= 1 THEN
      IF NOT cl_sure(18,20) THEN
         RETURN
      END IF
      BEGIN WORK 
      #先清除掉所有vnc_file 記錄
      DELETE FROM vnc_file 
       WHERE vnc08 = 0  #vnc08 0:加班 1:維修
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","vnc_file",g_vol01,g_vol02,SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
      
      FOR l_i = 1 TO g_rec_b1
          IF g_vol1[l_i].vol10=0  AND g_vol1[l_i].vol12 MATCHES '[013]' THEN  #FUN-960009 ADD
             LET l_i2 = l_i2 + 1
              INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc04,vnc06,vnc07,vnc08,vnc031,vnc041,vnc05,vnc09,vnc10)
                values(g_vol1[l_i].vol03,g_vol1[l_i].vol04,g_vol1[l_i].vol05,
                       g_vol1[l_i].vol06,g_vol1[l_i].vol08,
                       g_vol1[l_i].vol09,g_vol1[l_i].vol10,g_vol1[l_i].vol05_2,g_vol1[l_i].vol06_2,g_vol1[l_i].vol07,g_vol1[l_i].vol04_1,g_vol1[l_i].vol04_2)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vnc_file",g_vol01,g_vol02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                RETURN
             END IF
          END IF 
      END FOR
      UPDATE vol_file 
         SET vol11 = 1                  
       WHERE vol00 = g_plant  
         AND vol01 = g_vol01
         AND vol02 = g_vol02
         AND vol12 IN ('1','2','3') #1:新增 2:刪除 3:修改
         AND vol10 = 0              #0:加班 1:維修

     #FUN-A30109 mod str ----------------------
     #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #   CALL cl_err3("upd","vol_file",g_vol01,g_vol02,SQLCA.sqlcode,"","",1)
     #   ROLLBACK WORK
     #   RETURN
     #END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err("upd vol_file",SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN #無可更新資料
         CALL cl_err("upd vol_file",'aps-709',1)
         ROLLBACK WORK
         RETURN
      END IF
     #FUN-A30109 mod end ----------------------

      LET g_success = 'Y'
      CALL p830_supply_overworkinfo()   #填補其他日期之基本預設資料
      IF g_success = 'Y' THEN
          COMMIT WORK
          CALL cl_err('',9062,1)      #資料更新成功
      ELSE
          ROLLBACK WORK
          RETURN
      END IF
      LET g_vol01_t = g_vol01
      LET g_vol02_t = g_vol02
      CALL p830_show()
  ELSE
      CALL cl_err('','aps-709',1) #無可更新之資料!
  END IF

END FUNCTION
#FUN-960009 ----mod----end----

#FUN-960009 ADD --STR----------------------
FUNCTION p803_bp2()
DEFINE   p_ud   LIKE type_file.chr1


  CALL cl_set_act_visible("accept,cancel", FALSE)
  IF g_action_choice = "unscheduler" THEN
     DISPLAY ARRAY g_vol1 TO s_arr1.* ATTRIBUTE(COUNT=0,UNBUFFERED)
        BEFORE DISPLAY 
          EXIT DISPLAY

     END DISPLAY
  END IF

  LET g_action_choice = " "  
  DISPLAY ARRAY g_vnc1 TO s_arr2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

     BEFORE ROW

     ON ACTION help
        LET g_action_choice="help"
        EXIT DISPLAY

     ON ACTION locale
        CALL cl_dynamic_locale()

     ON ACTION exit
        LET g_action_choice="exit"
        EXIT DISPLAY
     ON ACTION controlg
        LET g_up = "V"
        LET g_action_choice="controlg"
        EXIT DISPLAY

     ON ACTION cancel
        LET g_action_choice="exit"
        EXIT DISPLAY

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY

     ON ACTION about
        CALL cl_about()

     #將focus指回單頭
     ON ACTION return
        LET g_up = "R"
        LET g_action_choice="return"
        EXIT DISPLAY
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p830_b2_fill()
DEFINE  l_i      LIKE type_file.num5          
DEFINE  l_sql1   STRING  #FUN-B50022 add

    CALL g_vnc1.clear()
    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2

        LET l_sql1 = cl_tp_tochar('vnc02','yy/mm/dd') #FUN-B50022 add

        LET g_sql = "SELECT vnc06,vnc07,vnc01,vnc02,vnc08,vnc031,vnc041,vnc05 ",
                    "  FROM vnc_file ",
                    " WHERE vnc01 = '",g_vol1[l_ac].vol03,"'"
                   #"   AND to_char(vnc02,'yy/mm/dd') = '",g_vol1[l_ac].vol04,"'",              #FUN-B50022 mark
        LET g_sql = g_sql CLIPPED," AND ",l_sql1 CLIPPED,   " = '",g_vol1[l_ac].vol04,"'",      #FUN-B50022 add
                    "   AND vnc06 = ",g_vol1[l_ac].vol08,
                    "   AND vnc07 = ",g_vol1[l_ac].vol09,
                    "   AND vnc03 <> vnc04 ",
                    " ORDER BY vnc06,vnc07,vnc01,vnc02,vnc08,vnc031 "
        PREPARE p830_pre2 FROM g_sql
        DECLARE p830_cs2 CURSOR FOR p830_pre2


        IF NOT(g_rec_b2 > g_max_rec) THEN
           FOREACH p830_cs2 INTO g_vnc1[g_rec_b2].*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b2_fill foreach1:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF

              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
        
    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2

END FUNCTION

FUNCTION p830_bp2_refresh()
   DISPLAY ARRAY g_vnc1 TO s_arr2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END DISPLAY
END FUNCTION

FUNCTION p830_b3_fill()
DEFINE  l_i      LIKE type_file.num5          
DEFINE  l_vnc    RECORD
                  vnc06          LIKE vnc_file.vnc06, 
                  vnc07          LIKE vnc_file.vnc07, 
                  vnc01          LIKE vnc_file.vnc01, 
                  vnc02          LIKE vnc_file.vnc02,
                  vnc08          LIKE vnc_file.vnc08,
                  vnc03          LIKE vnc_file.vnc03
                 END RECORD
   #CALL g_vol1.clear() #090818 mark
    CALL g_vnc1.clear()

    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2


       #LET g_sql = "SELECT vnc06,vnc07,vnc01,vnc02,vnc08,vnc031,vnc041,vnc05 ",
       #            "  FROM vnc_file ",
       #            " WHERE vnc03 <> vnc04 ",
       #            "   AND to_char(vnc02,'yyyy/mm/dd') NOT IN ",
       #            "        (SELECT DISTINCT TO_CHAR(vol04,'yyyy/mm/dd')  ",
       #            "           FROM vol_file  ",
       #            "          WHERE vol00='",g_plant,"'",
       #            "            AND vol01='",g_vol01,"'",
       #            "            AND vol02='",g_vol02,"'",
       #            "        )   ",
       #            " ORDER BY vnc06,vnc07,vnc01,vnc02,vnc08,vnc031 "
        LET g_sql = "SELECT vnc06,vnc07,vnc01,vnc02,vnc08,vnc03 ",
                    "  FROM vnc_file ",
                    " WHERE vnc03 <> vnc04 ",
                    "  MINUS ", #差集
                    "SELECT vol08,vol09,vol03,vol04,vol10,vol05 ",
                    "  FROM vol_file ",
                    " WHERE vol00='",g_plant,"'",
                    "   AND vol01='",g_vol01,"'",
                    "   AND vol02='",g_vol02,"'",
                    " ORDER BY 1,2,3,4,5,6"
        PREPARE p830_pre3 FROM g_sql
        DECLARE p830_cs3 CURSOR FOR p830_pre3


        IF NOT(g_rec_b2 > g_max_rec) THEN
          #FOREACH p830_cs3 INTO g_vnc1[g_rec_b2].*
           FOREACH p830_cs3 INTO l_vnc.*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b3_fill foreach1:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              SELECT vnc06,vnc07,vnc01,vnc02,vnc08,vnc031,vnc041,vnc05
                INTO g_vnc1[g_rec_b2].*
                FROM vnc_file
               WHERE vnc01 = l_vnc.vnc01
                 AND vnc02 = l_vnc.vnc02
                 AND vnc03 = l_vnc.vnc03
                 AND vnc06 = l_vnc.vnc06
                 AND vnc07 = l_vnc.vnc07
                 AND vnc08 = l_vnc.vnc08

              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
        
    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2

END FUNCTION

#填補其他日期之預設記錄
FUNCTION p830_supply_overworkinfo()
DEFINE l_sdate, l_edate      LIKE type_file.dat,
       l_i                   LIKE type_file.num5
  LET g_sql = "SELECT DISTINCT vnc06,vnc07,vnc08,vnc01,vnc09,vnc10 ",
              "  FROM vnc_file  ",
              " WHERE vnc08 = 0 ",
              "  ORDER BY vnc06,vnc07,vnc08,vnc01,vnc09,vnc10 "
  PREPARE p830_pre4 FROM g_sql
  DECLARE p830_cs4 CURSOR FOR p830_pre4

  CALL g_vnc2.clear()
  LET l_i = 1
  FOREACH p830_cs4 INTO g_vnc2[l_i].*
    LET l_sdate = MDY(g_vnc2[l_i].vnc10,1,g_vnc2[l_i].vnc09)
    IF g_vnc2[l_i].vnc10 = 12 THEN
       LET l_edate = MDY(1,1,g_vnc2[l_i].vnc09+1)
    ELSE
       LET l_edate = MDY(g_vnc2[l_i].vnc10+1,1,g_vnc2[l_i].vnc09)
    END IF

    WHILE TRUE
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM vnc_file
       WHERE vnc01 = g_vnc2[l_i].vnc01
         AND vnc02 = l_sdate
         AND vnc06 = g_vnc2[l_i].vnc06
         AND vnc07 = g_vnc2[l_i].vnc07
         AND vnc08 = g_vnc2[l_i].vnc08
         AND vnc09 = g_vnc2[l_i].vnc09
         AND vnc10 = g_vnc2[l_i].vnc10
      IF l_cnt = 0 THEN
          INSERT INTO vnc_file(vnc01,vnc02,vnc03,vnc04,vnc05,vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10)
                        VALUES(g_vnc2[l_i].vnc01,l_sdate,0,0,0,'00:00:00','00:00:00',
                               g_vnc2[l_i].vnc06,g_vnc2[l_i].vnc07,g_vnc2[l_i].vnc08,
                               g_vnc2[l_i].vnc09,g_vnc2[l_i].vnc10)
          IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","vnc_file",g_vnc2[l_i].vnc01,l_sdate,SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
          END IF
      END IF
      LET l_sdate = l_sdate + 1
      IF l_sdate = l_edate THEN
         EXIT WHILE
      END IF
    END WHILE
    LET l_i = l_i + 1
  END FOREACH
END FUNCTION

#FUN-960009 ADD --END------------------------
