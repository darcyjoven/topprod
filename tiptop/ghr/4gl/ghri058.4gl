# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghri058.4gl
# Descriptions...: 補刷卡維護作業
# Date & Author..: 13/05/20 by mengyye
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_hrcr_hd        RECORD                       #單頭變數
        hrcr01       LIKE hrcr_file.hrcr01,  
        hrcr03       LIKE hrcr_file.hrcr03,  
        hrcr04       LIKE hrcr_file.hrcr04,  
        hrcr07       LIKE hrcr_file.hrcr07,  
        hrcr09       LIKE hrcr_file.hrcr09,  
        hrcr11       LIKE hrcr_file.hrcr11,  
        hrcr05       LIKE hrcr_file.hrcr05,  
        hrcr12       LIKE hrcr_file.hrcr12,  
        hrcr06       LIKE hrcr_file.hrcr06,  
        hrcr08       LIKE hrcr_file.hrcr08,  
        hrcr10       LIKE hrcr_file.hrcr10,  
        hrcr13       LIKE hrcr_file.hrcr13, 
        hrcr14       LIKE hrcr_file.hrcr14, 
        hrcr15       LIKE hrcr_file.hrcr15, 
        hrcr16       LIKE hrcr_file.hrcr16, 
        hrcr17       LIKE hrcr_file.hrcr17, 
        hrcr18       LIKE hrcr_file.hrcr18, 
        hrcr19       LIKE hrcr_file.hrcr19, 
        hrcrconf     LIKE hrcr_file.hrcrconf,
        hrcruser     LIKE hrcr_file.hrcruser,
        hrcrgrup     LIKE hrcr_file.hrcrgrup,
        hrcrmodu     LIKE hrcr_file.hrcrmodu,  
        hrcrdate     LIKE hrcr_file.hrcrdate, 
        hrcroriu     LIKE hrcr_file.hrcroriu,  
        hrcrorig     LIKE hrcr_file.hrcrorig  
        END RECORD,
    g_hrcr_hd_t      RECORD                       #單頭變數
        hrcr01       LIKE hrcr_file.hrcr01,  
        hrcr03       LIKE hrcr_file.hrcr03,  
        hrcr04       LIKE hrcr_file.hrcr04,  
        hrcr07       LIKE hrcr_file.hrcr07,  
        hrcr09       LIKE hrcr_file.hrcr09,  
        hrcr11       LIKE hrcr_file.hrcr11,  
        hrcr05       LIKE hrcr_file.hrcr05,  
        hrcr12       LIKE hrcr_file.hrcr12,  
        hrcr06       LIKE hrcr_file.hrcr06,  
        hrcr08       LIKE hrcr_file.hrcr08,  
        hrcr10       LIKE hrcr_file.hrcr10,  
        hrcr13       LIKE hrcr_file.hrcr13, 
        hrcr14       LIKE hrcr_file.hrcr14, 
        hrcr15       LIKE hrcr_file.hrcr15, 
        hrcr16       LIKE hrcr_file.hrcr16, 
        hrcr17       LIKE hrcr_file.hrcr17, 
        hrcr18       LIKE hrcr_file.hrcr18, 
        hrcr19       LIKE hrcr_file.hrcr19, 
        hrcrconf     LIKE hrcr_file.hrcrconf,
        hrcruser     LIKE hrcr_file.hrcruser,
        hrcrgrup     LIKE hrcr_file.hrcrgrup,
        hrcrmodu     LIKE hrcr_file.hrcrmodu,  
        hrcrdate     LIKE hrcr_file.hrcrdate, 
        hrcroriu     LIKE hrcr_file.hrcroriu,  
        hrcrorig     LIKE hrcr_file.hrcrorig  
        END RECORD,
    g_hrcr_hd_o      RECORD                       #單頭變數
        hrcr01       LIKE hrcr_file.hrcr01,  
        hrcr03       LIKE hrcr_file.hrcr03,  
        hrcr04       LIKE hrcr_file.hrcr04,  
        hrcr07       LIKE hrcr_file.hrcr07,  
        hrcr09       LIKE hrcr_file.hrcr09,  
        hrcr11       LIKE hrcr_file.hrcr11,  
        hrcr05       LIKE hrcr_file.hrcr05,  
        hrcr12       LIKE hrcr_file.hrcr12,  
        hrcr06       LIKE hrcr_file.hrcr06,  
        hrcr08       LIKE hrcr_file.hrcr08,  
        hrcr10       LIKE hrcr_file.hrcr10,  
        hrcr13       LIKE hrcr_file.hrcr13, 
        hrcr14       LIKE hrcr_file.hrcr14, 
        hrcr15       LIKE hrcr_file.hrcr15, 
        hrcr16       LIKE hrcr_file.hrcr16, 
        hrcr17       LIKE hrcr_file.hrcr17, 
        hrcr18       LIKE hrcr_file.hrcr18, 
        hrcr19       LIKE hrcr_file.hrcr19, 
        hrcrconf     LIKE hrcr_file.hrcrconf,
        hrcruser     LIKE hrcr_file.hrcruser,
        hrcrgrup     LIKE hrcr_file.hrcrgrup,
        hrcrmodu     LIKE hrcr_file.hrcrmodu,  
        hrcrdate     LIKE hrcr_file.hrcrdate, 
        hrcroriu     LIKE hrcr_file.hrcroriu,  
        hrcrorig     LIKE hrcr_file.hrcrorig  
        END RECORD,
    g_hrcr           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        hrcr02       LIKE hrcr_file.hrcr02,      
        hrat02       LIKE hrat_file.hrat02,       
        hrat03       LIKE hrat_file.hrat03,       
        hrat03_name  LIKE type_file.chr20, 
        hrat04       LIKE hrat_file.hrat04,       
        hrat04_name  LIKE type_file.chr20, 
        hrat05       LIKE hrat_file.hrat05,       
        hrat05_name  LIKE type_file.chr20, 
        hrat25      LIKE hrat_file.hrat25     
        END RECORD,
    g_hrcr_t         RECORD                       #程式變數(舊值)
          hrcr02       LIKE hrcr_file.hrcr02,      
        hrat02       LIKE hrat_file.hrat02,       
        hrat03       LIKE hrat_file.hrat03,       
        hrat02_name  LIKE type_file.chr20, 
        hrat04       LIKE hrat_file.hrat04,       
        hrat04_name  LIKE type_file.chr20, 
        hrat05       LIKE hrat_file.hrat05,       
        hrat05_name  LIKE type_file.chr20, 
        hrat25      LIKE hrat_file.hrat25      
        END RECORD,
    g_wc            string,                          #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql           string,                          #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #單身筆數   #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680061 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
DEFINE   l_table        STRING                       #No.FUN-770033
DEFINE   g_str          STRING                       #No.FUN-770033
#主程式開始
MAIN
DEFINE
    p_row,p_col LIKE type_file.num5      #No.FUN-680061 smallint
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GHR")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056

    INITIALIZE g_hrcr_hd.* to NULL
    INITIALIZE g_hrcr_hd_t.* to NULL
    INITIALIZE g_hrcr_hd_o.* to NULL

    LET g_forupd_sql =" SELECT hrcr01, hrcr03, hrcr04,",
                      " hrcr07, hrcr09, hrcr11,",  
                      " hrcr05, hrcr12, hrcr06,",
                      " hrcr08, hrcr10, hrcr13,",  
                      " hrcr14, hrcr15, hrcr16,",  
                      " hrcr17, hrcr18, hrcr19,",  
                      " hrcrconf,hrcruser,hrcrgrup,",
                      " hrcrmodu,hrcrdate,", 
                      " hrcroriu,hrcrorig FROM hrcr_file ",  
                      "  WHERE hrcr01 = ? ",
                      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i058_lock_u1 CURSOR FROM g_forupd_sql 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW i058_w AT p_row,p_col
        WITH FORM "ghr/42f/ghri058" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL cl_set_label_justify("i058_w","right")    
    CALL i058_menu()
    CLOSE WINDOW i058_w                          #結束畫面
      CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i058_curs()
    CLEAR FORM #清除畫面
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_hrcr_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON hrcr01,hrcr03, hrcr04,
          hrcr07, hrcr09, hrcr11,
          hrcr05, hrcr12, hrcr06,
          hrcr08, hrcr10, hrcr13,
          hrcr14, hrcr15, hrcr16,
          hrcr17, hrcr18, hrcr19,
          hrcrconf,hrcruser,hrcrgrup,hrcroriu,hrcrorig,hrcrmodu,hrcrdate,hrcr02
        FROM hrcr01, hrcr03, hrcr04,
              hrcr07, hrcr09, hrcr11,
              hrcr05, hrcr12, hrcr06,
              hrcr08, hrcr10, hrcr13,
              hrcr14, hrcr15, hrcr16,
              hrcr17, hrcr18, hrcr19,
              hrcrconf, hrcruser,hrcrgrup,hrcroriu,hrcrorig,hrcrmodu,hrcrdate, 
              s_hrcr[1].hrcr02  
    BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrcr05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_hrat01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcr05
 
                WHEN INFIELD(hrcr12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.arg1 = "('009')"
                    LET g_qryparam.form ="q_hrbm033"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcr12                 
                WHEN INFIELD(hrcr02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_hrat01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcr02
            END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
               CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
 
    IF INT_FLAG THEN
        CALL i058_show()
        RETURN
    END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcruser', 'hrcrgrup')
    #End:FUN-980030
    LET g_wc = cl_replace_str(g_wc,"hrcr05","a.hrat01") 
    LET g_wc = cl_replace_str(g_wc,"hrcr02","b.hrat01") 
    
    LET g_sql = "SELECT UNIQUE hrcr01,hrcr03,hrcr04,hrcr07,hrcr09,hrcr11,a.hrat01,hrcr12,hrcr06,hrcr08,hrcr10,hrcr13,",
                "              hrcr14,hrcr15,hrcr16,hrcr17,hrcr18,hrcr19,",
                "              hrcrconf",
                "  FROM hrcr_file,hrat_file a,hrat_file b",
                " WHERE a.hratid = hrcr05 AND b.hratid = hrcr02 AND ", g_wc CLIPPED,
                " ORDER BY hrcr01"
    PREPARE i058_prepare FROM g_sql
    DECLARE i058_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i058_prepare
 
    LET g_sql = "SELECT COUNT(DISTINCT hrcr01) ",
                "  FROM hrcr_file,hrat_file a,hrat_file b",
                " WHERE a.hratid = hrcr05 AND b.hratid = hrcr02 AND ", g_wc CLIPPED,
                " ORDER BY hrcr01 "
    PREPARE i058_precnt FROM g_sql
    DECLARE i058_cnt CURSOR FOR i058_precnt
END FUNCTION
 
FUNCTION i058_menu()
   WHILE TRUE
      CALL i058_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i058_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i058_q()
           END IF
        WHEN "modify"       
            IF cl_chk_act_auth() THEN
               CALL i058_u()
            END IF
             
        WHEN "confirm"                        
            IF cl_chk_act_auth() THEN
               CALL i058_y()
            END IF 
             
        WHEN "undo_confirm"                         
            IF cl_chk_act_auth() THEN
               CALL i058_z()
            END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i058_r()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i058_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   #No.FUN-4B0021
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcr),'','')
           END IF
        #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i058_a()
	 DEFINE l_hrbtud02  LIKE hrbt_file.hrbtud02
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
     CALL g_hrcr.clear()     #MOD-530524
    INITIALIZE g_hrcr_hd.* TO NULL                  #單頭初始清空
    INITIALIZE g_hrcr_hd_o.* TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i058_auto_hrcr01() RETURNING g_hrcr_hd.hrcr01
        LET g_hrcr_hd.hrcr03 = g_today
        LET g_hrcr_hd.hrcr04 = g_today
        LET g_hrcr_hd.hrcr06 = ' '
        LET g_hrcr_hd.hrcr07 = ' ' 
        LET g_hrcr_hd.hrcr08 = ' ' 
        LET g_hrcr_hd.hrcr09 = ' ' 
        LET g_hrcr_hd.hrcr10 = ' ' 
        LET g_hrcr_hd.hrcr11 = ' '
        LET g_hrcr_hd.hrcrconf = 'N'
        LET g_hrcr_hd.hrcr14 = ' '
        LET g_hrcr_hd.hrcr16 = ' '
        LET g_hrcr_hd.hrcr18 = ' '
        LET g_hrcr_hd.hrcr15 = ' '
        LET g_hrcr_hd.hrcr17 = ' '
        LET g_hrcr_hd.hrcr19 = ' '
        LET g_hrcr_hd.hrcruser = g_user
        LET g_hrcr_hd.hrcrgrup = g_grup
        LET g_hrcr_hd.hrcrdate = g_today
        LET g_hrcr_hd.hrcroriu = g_user    
        LET g_hrcr_hd.hrcrorig = g_grup  
        SELECT hrbtud02 INTO l_hrbtud02 FROM hrbt_file 
        IF l_hrbtud02='002' THEN 
        	LET g_hrcr_hd.hrcr14 = '1'
          LET g_hrcr_hd.hrcr16 = '1'
          LET g_hrcr_hd.hrcr18 = '1'
          LET g_hrcr_hd.hrcr15 = '1'
          LET g_hrcr_hd.hrcr17 = '1'
          LET g_hrcr_hd.hrcr19 = '1'
        END IF 
        IF l_hrbtud02='003' THEN 
        	LET g_hrcr_hd.hrcr14 = '6'
          LET g_hrcr_hd.hrcr16 = '6'
          LET g_hrcr_hd.hrcr18 = '6'
          LET g_hrcr_hd.hrcr15 = '6'
          LET g_hrcr_hd.hrcr17 = '6'
          LET g_hrcr_hd.hrcr19 = '6'
        END IF 
        CALL i058_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     IF cl_null(g_hrcr_hd.hrcr01)  OR
        cl_null(g_hrcr_hd.hrcr03)  OR
        cl_null(g_hrcr_hd.hrcr04)  OR
        cl_null(g_hrcr_hd.hrcr05)  OR
        cl_null(g_hrcr_hd.hrcr06)  THEN
        CONTINUE WHILE
     END IF
        CALL g_hrcr.clear()
        LET g_rec_b=0
        CALL i058_b()                            #輸入單身
        LET g_hrcr_hd_t.* = g_hrcr_hd.*            #保留舊值
        LET g_hrcr_hd_o.* = g_hrcr_hd.*            #保留舊值
        LET g_wc="     hrcr01='",g_hrcr_hd.hrcr01,"' "
              
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理單頭欄位(hrcr01, hrcr02, hrcr04, hrcr05)INPUT
FUNCTION i058_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680061 VARCHAR(1)
    l_n     LIKE type_file.num5,     #No.FUN-680061 SMALLINT
    l_count LIKE type_file.num5 ,
    l_hrcr05_desc LIKE type_file.chr20,
    l_hrcr07_desc LIKE type_file.chr20, 
    l_hrcr12_desc LIKE type_file.chr20
DEFINE  g_h,g_m   LIKE  type_file.num5 

    LET l_n = 0
 
     DISPLAY g_hrcr_hd.hrcr01, g_hrcr_hd.hrcr03, g_hrcr_hd.hrcr04,
             g_hrcr_hd.hrcr07, g_hrcr_hd.hrcr09, g_hrcr_hd.hrcr11,  
             g_hrcr_hd.hrcr05, g_hrcr_hd.hrcr12, g_hrcr_hd.hrcr06,
             g_hrcr_hd.hrcr08, g_hrcr_hd.hrcr10, g_hrcr_hd.hrcr13,  
             g_hrcr_hd.hrcr14, g_hrcr_hd.hrcr15, g_hrcr_hd.hrcr16,  
             g_hrcr_hd.hrcr17, g_hrcr_hd.hrcr18, g_hrcr_hd.hrcr19,  
             g_hrcr_hd.hrcrconf,g_hrcr_hd.hrcruser,g_hrcr_hd.hrcrgrup,
             g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate, 
             g_hrcr_hd.hrcroriu,g_hrcr_hd.hrcrorig          
          TO hrcr01, hrcr03, hrcr04,
             hrcr07, hrcr09, hrcr11,  
             hrcr05, hrcr12, hrcr06,
             hrcr08, hrcr10, hrcr13,  
             hrcr14, hrcr15, hrcr16,  
             hrcr17, hrcr18, hrcr19,  
             hrcrconf,hrcruser,hrcrgrup,
             hrcrmodu,hrcrdate, 
             hrcroriu,hrcrorig 
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
    INPUT BY NAME g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr12,
          g_hrcr_hd.hrcr04, g_hrcr_hd.hrcr05, 
          g_hrcr_hd.hrcr06, g_hrcr_hd.hrcr14,
          g_hrcr_hd.hrcr07, g_hrcr_hd.hrcr15,
          g_hrcr_hd.hrcr08, g_hrcr_hd.hrcr16,
          g_hrcr_hd.hrcr09, g_hrcr_hd.hrcr17,
          g_hrcr_hd.hrcr10, g_hrcr_hd.hrcr18,
          g_hrcr_hd.hrcr11, g_hrcr_hd.hrcr19,
          g_hrcr_hd.hrcr13
     WITHOUT DEFAULTS
        AFTER FIELD hrcr03
            IF cl_null(g_hrcr_hd.hrcr03) THEN
               CALL cl_err('', 'afa-321', 0)
               NEXT FIELD hrcr03
            END IF
 
        AFTER FIELD hrcr04
            IF cl_null(g_hrcr_hd.hrcr04) THEN
               CALL cl_err('', 'afa-321', 0)
               NEXT FIELD hrcr04
            END IF
 
        AFTER FIELD hrcr05
            IF NOT cl_null(g_hrcr_hd.hrcr05) THEN
               SELECT COUNT(*) INTO l_count FROM hrat_file 
                WHERE hratconf ='Y' AND hrat01 = g_hrcr_hd.hrcr05
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN  
                  CALL cl_err('','ghr-081',1)            
                  NEXT FIELD hrcr05 
               END IF
               SELECT hrat02 INTO l_hrcr05_desc FROM hrat_file
                WHERE hratconf ='Y' AND hrat01 = g_hrcr_hd.hrcr05
                 DISPLAY l_hrcr05_desc TO FORMONLY.hrcr05_desc
             END IF
 
        AFTER FIELD hrcr06
            IF NOT cl_null(g_hrcr_hd.hrcr06) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr06[1,2]
               LET g_m=g_hrcr_hd.hrcr06[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr06
               END IF
            END IF
        AFTER FIELD hrcr07
            IF NOT cl_null(g_hrcr_hd.hrcr07) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr07[1,2]
               LET g_m=g_hrcr_hd.hrcr07[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr07
               END IF
            END IF 
        AFTER FIELD hrcr08
            IF cl_null(g_hrcr_hd.hrcr08) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr08[1,2]
               LET g_m=g_hrcr_hd.hrcr08[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr08
               END IF
            END IF 
             
         AFTER FIELD hrcr09
            IF NOT cl_null(g_hrcr_hd.hrcr09) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr09[1,2]
               LET g_m=g_hrcr_hd.hrcr09[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr09
               END IF
            END IF 
         AFTER FIELD hrcr10
            IF NOT cl_null(g_hrcr_hd.hrcr10) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr10[1,2]
               LET g_m=g_hrcr_hd.hrcr10[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr10
               END IF
            END IF
        AFTER FIELD hrcr11
            IF NOT cl_null(g_hrcr_hd.hrcr11) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcr_hd.hrcr11[1,2]
               LET g_m=g_hrcr_hd.hrcr11[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcr11
               END IF
            END IF   
              
        AFTER FIELD hrcr12
             IF NOT cl_null(g_hrcr_hd.hrcr12) THEN
               SELECT COUNT(*) INTO l_count FROM hrbm_file 
                WHERE hrbm03 =g_hrcr_hd.hrcr12 AND hrbm07 ='Y' AND hrbm02 = '009'
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN  
                  CALL cl_err('','mfg1306',1)            
                  NEXT FIELD hrcr12 
               END IF
               SELECT hrbm04 INTO l_hrcr12_desc FROM hrbm_file 
                WHERE hrbm03 =g_hrcr_hd.hrcr12  AND hrbm07 ='Y' AND hrbm02 = '009'
                DISPLAY l_hrcr12_desc TO FORMONLY.hrcr12_desc
             END IF
             
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(hrcr05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_hrat01"
                    LET g_qryparam.default1 = g_hrcr_hd.hrcr05
                    CALL cl_create_qry() RETURNING g_hrcr_hd.hrcr05
                    DISPLAY BY NAME g_hrcr_hd.hrcr05
 
                WHEN INFIELD(hrcr12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.arg1 = "('009')"
                    LET g_qryparam.form ="q_hrbm033"
                    LET g_qryparam.default1 = g_hrcr_hd.hrcr12
                    CALL cl_create_qry() RETURNING g_hrcr_hd.hrcr12
                    DISPLAY BY NAME g_hrcr_hd.hrcr12               
            END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION i058_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrcr_hd.hrcr01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_hrcr_hd.hrcrconf = 'Y' THEN
      CALL cl_err('',1209,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrcr_hd_t.hrcr01 = g_hrcr_hd.hrcr01 
 
   BEGIN WORK
   OPEN i058_lock_u1 USING g_hrcr_hd.hrcr01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i058_lock_u1
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i058_lock_u1 INTO g_hrcr_hd.*
   SELECT hrat01 INTO g_hrcr_hd.hrcr05 FROM hrat_file WHERE hratid = g_hrcr_hd.hrcr05
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrcr01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i058_lock_u1
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i058_i("u")
      IF INT_FLAG THEN
         LET g_hrcr_hd_t.hrcr01 = g_hrcr_hd.hrcr01
         DISPLAY g_hrcr_hd.hrcr01 TO hrcr01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      SELECT hratid INTO g_hrcr_hd.hrcr05 FROM hrat_file WHERE hrat01 = g_hrcr_hd.hrcr05
      UPDATE hrcr_file SET hrcr03 = g_hrcr_hd.hrcr03,  
                           hrcr04 = g_hrcr_hd.hrcr04,  
                           hrcr07 = g_hrcr_hd.hrcr07,  
                           hrcr09 = g_hrcr_hd.hrcr09,  
                           hrcr11 = g_hrcr_hd.hrcr11,  
                           hrcr05 = g_hrcr_hd.hrcr05,  
                           hrcr12 = g_hrcr_hd.hrcr12,  
                           hrcr06 = g_hrcr_hd.hrcr06,  
                           hrcr08 = g_hrcr_hd.hrcr08,  
                           hrcr10 = g_hrcr_hd.hrcr10,  
                           hrcr13 = g_hrcr_hd.hrcr13,  
                           hrcr14 = g_hrcr_hd.hrcr14,  
                           hrcr15 = g_hrcr_hd.hrcr15,  
                           hrcr16 = g_hrcr_hd.hrcr16,  
                           hrcr17 = g_hrcr_hd.hrcr17,  
                           hrcr18 = g_hrcr_hd.hrcr18,  
                           hrcr19 = g_hrcr_hd.hrcr19,  
                           hrcrconf=g_hrcr_hd.hrcrconf,
                           hrcruser=g_hrcr_hd.hrcruser,
                           hrcrgrup=g_hrcr_hd.hrcrgrup,
                           hrcrmodu=g_hrcr_hd.hrcrmodu,
                           hrcrdate=g_hrcr_hd.hrcrdate,
                           hrcroriu=g_hrcr_hd.hrcroriu,
                           hrcrorig=g_hrcr_hd.hrcrorig
             WHERE hrcr01 = g_hrcr_hd.hrcr01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","hrcr_file",g_hrcr_hd.hrcr01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

FUNCTION i058_y()
  DEFINE l_str     LIKE ze_file.ze01
  DEFINE l_n       LIKE type_file.num10
  DEFINE l_hrcr    RECORD LIKE hrcr_file.*
  DEFINE l_hrby    RECORD LIKE hrby_file.*
    IF g_hrcr_hd.hrcr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    CALL i058_show()
    IF g_hrcr_hd.hrcrconf = 'Y' THEN
       CALL cl_err(g_hrcr_hd.hrcr01,'axm1163',0)
       RETURN
    END IF
    LET l_str = 'aim-301'
    IF  NOT cl_confirm(l_str) THEN RETURN END IF 
    
    BEGIN WORK

    LET g_success = 'Y'
    LET l_n = 1 
    LET g_sql = "SELECT * FROM hrcr_file WHERE hrcr01 = '",g_hrcr_hd.hrcr01,"' "
    PREPARE i058_y_prep FROM g_sql
    DECLARE i058_y_cs CURSOR FOR i058_y_prep
    FOREACH i058_y_cs INTO l_hrcr.*
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('',sqlca.sqlcode,1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       
       INITIALIZE l_hrby.* TO NULL
       LET l_hrby.hrby01 = l_hrcr.hrcr01
       LET l_hrby.hrby05 = l_hrcr.hrcr03
       LET l_hrby.hrby08 = l_hrcr.hrcr13
       LET l_hrby.hrby09 = l_hrcr.hrcr02
       LET l_hrby.hrby11 = '1'
       LET l_hrby.hrby12 = '2'
       LET l_hrby.hrby13 = l_hrcr.hrcr12
       LET l_hrby.hrbyacti = 'Y'
       UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05
       #1
       IF NOT cl_null(l_hrcr.hrcr06) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr06
       LET l_hrby.hrby10 = l_hrcr.hrcr14
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       #2
       IF NOT cl_null(l_hrcr.hrcr07) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr07
       LET l_hrby.hrby10 = l_hrcr.hrcr15
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       #3
       IF NOT cl_null(l_hrcr.hrcr08) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr08
       LET l_hrby.hrby10 = l_hrcr.hrcr16
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       #4
       IF NOT cl_null(l_hrcr.hrcr09) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr09
       LET l_hrby.hrby10 = l_hrcr.hrcr17
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       #5
       IF NOT cl_null(l_hrcr.hrcr10) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr10
       LET l_hrby.hrby10 = l_hrcr.hrcr18
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       #5
       IF NOT cl_null(l_hrcr.hrcr11) THEN 
       LET l_hrby.hrby02 = l_n
       LET l_hrby.hrby06 = l_hrcr.hrcr11
       LET l_hrby.hrby10 = l_hrcr.hrcr19
       INSERT INTO hrby_file VALUES(l_hrby.*)
       IF SQLCA.sqlcode THEN 
       	  CALL cl_err('','ghr-133',1)
       	  LET g_success = 'N'
       	  EXIT FOREACH
       END IF 
       LET l_n = l_n + 1 
       END IF 
       IF NOT cl_null(l_hrcr.hrcr06) OR NOT cl_null(l_hrcr.hrcr07) OR NOT cl_null(l_hrcr.hrcr08) OR
       	 NOT cl_null(l_hrcr.hrcr09) OR NOT cl_null(l_hrcr.hrcr10) OR NOT cl_null(l_hrcr.hrcr11) THEN 
        UPDATE hrcp_file 
           SET hrcp35='N',
               hrcp04=' ',hrcp05=' ',hrcp22='',hrcp23='',hrcp24='',hrcp25='',hrcp26='',hrcp27='',hrcp28='',
               hrcp29='',hrcp30='',hrcp31='',hrcp32='',hrcp33=''
         WHERE hrcp03=l_hrcr.hrcr03
           AND hrcp07<>'Y'
           AND hrcp02=l_hrcr.hrcr02
       END IF 
     END FOREACH 
    
    IF g_success = 'Y' THEN
       UPDATE hrcr_file
          SET hrcrconf='Y'
        WHERE hrcr01=g_hrcr_hd.hrcr01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_hrcr_hd.hrcr01,SQLCA.sqlcode,0)
          LET g_success = 'N'
       END IF
    END IF 
    IF g_success = 'Y' THEN
    	 COMMIT WORK
    	 CALL cl_err('','abm-019',1)
    ELSE
       ROLLBACK WORK
       CALL cl_err('','abm-020',1)
    END IF 
    SELECT DISTINCT hrcrconf INTO g_hrcr_hd.hrcrconf FROM hrcr_file
     WHERE hrcr01 = g_hrcr_hd.hrcr01
    DISPLAY BY NAME g_hrcr_hd.hrcrconf
    CALL cl_set_field_pic1(g_hrcr_hd.hrcrconf,'','','','','','','')
END FUNCTION 

FUNCTION i058_z()
DEFINE l_str     LIKE ze_file.ze01
DEFINE l_hrcr    RECORD LIKE hrcr_file.*
   
    CALL i058_show()
    IF g_hrcr_hd.hrcr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_hrcr_hd.hrcrconf = 'N' THEN
       CALL cl_err(g_hrcr_hd.hrcr01,'9025',0)
       RETURN
    END IF
    LET l_str = 'aim-302'
    IF  NOT cl_confirm(l_str) THEN RETURN END IF 
    
    LET g_success = 'Y'
    BEGIN WORK
    SELECT * INTO l_hrcr.* FROM hrcr_file WHERE hrcr01 = g_hrcr_hd.hrcr01
    DELETE FROM hrby_file WHERE hrby01 = g_hrcr_hd.hrcr01 AND hrby12 = '2'
     UPDATE hrcp_file 
           SET hrcp35='N',
               hrcp04=' ',hrcp05=' ',hrcp22='',hrcp23='',hrcp24='',hrcp25='',hrcp26='',hrcp27='',hrcp28='',
               hrcp29='',hrcp30='',hrcp31='',hrcp32='',hrcp33=''
         WHERE hrcp03=l_hrcr.hrcr03
           AND hrcp07<>'Y'
           AND hrcp02=l_hrcr.hrcr02
    IF SQLCA.SQLCODE THEN
        CALL cl_err('','ghr-134',1)
        LET g_success = 'N'
    END IF  
    IF g_success = 'Y' THEN   
       UPDATE hrcr_file
          SET hrcrconf='N'
        WHERE hrcr01=g_hrcr_hd.hrcr01
       IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_hrcr_hd.hrcr01,SQLCA.sqlcode,0)
           LET g_success = 'N'
       END IF
    END IF 
    IF g_success = 'Y' THEN 
       COMMIT WORK
    ELSE 
       ROLLBACK WORK
    END IF 
    SELECT DISTINCT hrcrconf INTO g_hrcr_hd.hrcrconf FROM hrcr_file
     WHERE hrcr01 = g_hrcr_hd.hrcr01
    DISPLAY BY NAME g_hrcr_hd.hrcrconf
    CALL cl_set_field_pic1(g_hrcr_hd.hrcrconf,'','','','','','','')
END FUNCTION 

#Query 查詢
FUNCTION i058_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_hrcr_hd.* TO NULL             #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_hrcr.clear()
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i058_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i058_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_hrcr TO NULL
    ELSE
        OPEN i058_cnt
        FETCH i058_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i058_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i058_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1   
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i058_cs INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf
        WHEN 'P' FETCH PREVIOUS i058_cs INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf
        WHEN 'F' FETCH FIRST    i058_cs INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf
        WHEN 'L' FETCH LAST     i058_cs INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf
        WHEN '/'
         IF (NOT mi_no_ask) THEN                 #No.FUN-6A0057 g_no_ask 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
             END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i058_cs INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf
         LET mi_no_ask = FALSE             
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcr_hd.hrcr01, SQLCA.sqlcode, 0)
        INITIALIZE g_hrcr_hd.* TO NULL  #TQC-6B0105
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
   SELECT UNIQUE hrcr01,hrcr03,hrcr04,hrcr07,
                  hrcr09,hrcr11,hrat01,hrcr12,
                  hrcr06,hrcr08,hrcr10,hrcr13,
                  hrcr14,hrcr15,hrcr16,hrcr17,
                  hrcr18,hrcr19,
                  hrcrconf,
                  hrcruser,hrcrgrup,hrcroriu,hrcrorig,hrcrmodu,hrcrdate 
     INTO g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,g_hrcr_hd.hrcr07,
                                             g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr05,g_hrcr_hd.hrcr12,
                                             g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr13,
                                             g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                                             g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                                             g_hrcr_hd.hrcrconf,
                                             g_hrcr_hd.hrcruser,g_hrcr_hd.hrcrgrup,g_hrcr_hd.hrcroriu,
                                             g_hrcr_hd.hrcrorig,g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate
    #CHI-AC0006 add --end--
     FROM hrcr_file,hrat_file
    WHERE hrcr01 = g_hrcr_hd.hrcr01
      AND hrcr05 = hratid
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_hrcr_hd.hrcr01, SQLCA.sqlcode, 0) #FUN-660105
       CALL cl_err3("sel","hrcr_file",g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,SQLCA.sqlcode,"","",1) #FUN-660105 
       INITIALIZE g_hrcr TO NULL
       RETURN
   END IF
    LET g_data_owner = g_hrcr_hd.hrcruser   #FUN-4C0067
    LET g_data_group = g_hrcr_hd.hrcrgrup   #FUN-4C0067
    CALL i058_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i058_show()
   DEFINE l_hrcr05_desc LIKE type_file.chr20, 
          l_hrcr12_desc LIKE type_file.chr20
    LET g_hrcr_hd_t.* = g_hrcr_hd.*                #保存單頭舊值 #CHI-AC0006
    DISPLAY BY NAME g_hrcr_hd.hrcr01,            #顯示單頭值
                    g_hrcr_hd.hrcr03, 
                    g_hrcr_hd.hrcr04, 
                    g_hrcr_hd.hrcr07, 
                    g_hrcr_hd.hrcr09, 
                    g_hrcr_hd.hrcr11, 
                    g_hrcr_hd.hrcr05, 
                    g_hrcr_hd.hrcr12, 
                    g_hrcr_hd.hrcr06, 
                    g_hrcr_hd.hrcr08, 
                    g_hrcr_hd.hrcr10, 
                    g_hrcr_hd.hrcr13,
                    g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                    g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                    g_hrcr_hd.hrcrconf,
                    g_hrcr_hd.hrcruser,
                    g_hrcr_hd.hrcrgrup,
                    g_hrcr_hd.hrcrmodu,
                    g_hrcr_hd.hrcrdate,
                    g_hrcr_hd.hrcroriu,
                    g_hrcr_hd.hrcrorig
    SELECT hrat02 INTO l_hrcr05_desc FROM hrat_file   
     WHERE hratconf ='Y' AND hrat01 = g_hrcr_hd.hrcr05
    DISPLAY l_hrcr05_desc TO FORMONLY.hrcr05_desc
    SELECT hrbm04 INTO l_hrcr12_desc FROM hrbm_file                     
     WHERE hrbm03 =g_hrcr_hd.hrcr12 AND hrbm07 ='Y' AND hrbm02 = '009'
    DISPLAY l_hrcr12_desc TO FORMONLY.hrcr12_desc      
    IF cl_null(g_wc) THEN LET g_wc ='1=1' END IF                
    CALL i058_b_fill(g_wc) #單身hrcrgrup 
    CALL cl_set_field_pic1(g_hrcr_hd.hrcrconf,'','','','','','','')
    CALL cl_show_fld_cont()   
END FUNCTION                  
                             
FUNCTION i058_r()            
DEFINE
    l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
 
    IF g_hrcr_hd.hrcr01 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    IF g_hrcr_hd.hrcrconf = 'Y' THEN
      CALL cl_err('',1208,0)
      RETURN
   END IF
    CALL i058_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "hrcr01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "hrcr02"            #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "hrcr04"            #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "hrcr05"            #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "hrcr08"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_hrcr_hd.hrcr01      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_hrcr_hd.hrcr04      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_hrcr_hd.hrcr05      #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_hrcr_hd.hrcr08      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM hrcr_file
         WHERE hrcr01 = g_hrcr_hd.hrcr01
        IF STATUS             THEN
            CALL cl_err3("del","hrcr_file",g_hrcr_hd.hrcr01,g_hrcr_hd.hrcr03,SQLCA.sqlcode,"","",1) #FUN-660105
        ELSE
            CLEAR FORM
            CALL g_hrcr.clear()
            OPEN i058_cnt
            FETCH i058_cnt INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i058_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i058_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE 
               CALL i058_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(hrcr03, hrcr06, hrcr07)輸入
FUNCTION i058_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(1)
    l_bgz03         LIKE bgz_file.bgz03,    #抓取參數設定
    l_ima53         LIKE ima_file.ima53,    #料件主檔之最近單價
    l_ima54         LIKE ima_file.ima54,    #料件主檔之主供應商
    l_ima109        LIKE ima_file.ima109,   #料件基本資料之材料類別
    l_ccc23a        LIKE ccc_file.ccc23a,   #材料成本之最近成本
    l_pmh12         LIKE pmh_file.pmh12,    #計價原幣
    l_hratid        LIKE hrat_file.hratid,
    l_hratid_hrcr05        LIKE hrat_file.hratid,
    l_hrcr06         LIKE hrcr_file.hrcr06,    #儲存未經計算的hrcr06值
    l_bgb05         LIKE bgb_file.bgb05,    #材料類別對應的調幅
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-680061 SMALLINT
    l_count         LIKE type_file.num5 
    LET g_action_choice = ""
    IF g_hrcr_hd.hrcr01 IS NULL THEN RETURN END IF
    IF g_hrcr_hd.hrcrconf = 'Y' THEN
       CALL cl_err('',1209,0)
       RETURN
    END IF 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT hrcr02,'','','','','','','','' FROM hrcr_file ",
        "  WHERE hrcr01 = ? AND hrcr02 = ?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i058_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrcr WITHOUT DEFAULTS FROM s_hrcr.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_hrcr_t.* = g_hrcr[l_ac].*    #BACKUP
                SELECT hratid INTO g_hrcr[l_ac].hrcr02 FROM hrat_file WHERE hrat01 =g_hrcr[l_ac].hrcr02
                OPEN i058_bcl USING g_hrcr_hd.hrcr01,g_hrcr[l_ac].hrcr02
                IF STATUS THEN
                   CALL cl_err("OPEN i058_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i058_bcl INTO g_hrcr[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrcr_t.hrcr02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i058_hrat_fill(g_hrcr[l_ac].hrcr02)
                   RETURNING  g_hrcr[l_ac].hrat02,
                             g_hrcr[l_ac].hrat03,g_hrcr[l_ac].hrat03_name,
                             g_hrcr[l_ac].hrat04,g_hrcr[l_ac].hrat04_name, 
                             g_hrcr[l_ac].hrat05,g_hrcr[l_ac].hrat05_name,
                             g_hrcr[l_ac].hrat25
                   LET g_hrcr[l_ac].hrcr02 = g_hrcr_t.hrcr02
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrcr[l_ac].* TO NULL
            LET g_hrcr_t.* = g_hrcr[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcr[l_ac].hrcr02
            SELECT hratid INTO l_hratid_hrcr05 FROM hrat_file WHERE hrat01 = g_hrcr_hd.hrcr05
             INSERT INTO hrcr_file(hrcr01,hrcr02,hrcr03,hrcr04,hrcr05,hrcr06,hrcr07, 
                                 hrcr08,hrcr09,hrcr10,hrcr11,hrcr12,hrcr13,
                                 hrcr14,hrcr15,hrcr16,hrcr17,hrcr18,hrcr19,
                                  hrcruser,hrcrgrup,hrcrmodu,hrcrdate,hrcroriu,hrcrorig,hrcrconf)
                  VALUES(g_hrcr_hd.hrcr01,l_hratid,
                        # g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,l_hrcrid_hrcr05,g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr07,
                        g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,l_hratid_hrcr05,g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr07, 
                         g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr12,
                         g_hrcr_hd.hrcr13,
                         g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                         g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                         g_user,g_grup,g_hrcr_hd.hrcrmodu,g_today,g_user,g_grup,'N')

            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","hrcr_file",g_hrcr_hd.hrcr01,g_hrcr_t.hrcr02,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
                   MESSAGE 'INSERT O.K'
                   SELECT COUNT(*) INTO g_rec_b FROM hrcr_file
                          WHERE hrcr01 = g_hrcr_hd.hrcr01
 
                   DISPLAY g_rec_b TO FORMONLY.idx
                   #CHI-B20009 add --start--
                   SELECT hrcruser,hrcrgrup,hrcrmodu,hrcrdate 
                     INTO g_hrcr_hd.hrcruser,g_hrcr_hd.hrcrgrup,g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate
                     FROM hrcr_file
                    WHERE hrcr01 = g_hrcr_hd.hrcr01
                   DISPLAY g_hrcr_hd.hrcruser,g_hrcr_hd.hrcrgrup,g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate
                        TO hrcruser,hrcrgrup,hrcrmodu,hrcrdate 
            END IF
 
        AFTER FIELD hrcr02
            IF NOT cl_null(g_hrcr[l_ac].hrcr02) THEN
               IF  cl_null(g_hrcr[l_ac].hrcr02) THEN
	                 NEXT FIELD hrcr02
               END IF
               SELECT COUNT(*) INTO l_count FROM hrat_file
                WHERE hratconf ='Y' AND hrat01 = g_hrcr[l_ac].hrcr02
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN
                  CALL cl_err('','mfg1312',1)
                  NEXT FIELD hrcr02
               END IF
               SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcr[l_ac].hrcr02
               CALL i058_hrat_fill(l_hratid) 
                   RETURNING g_hrcr[l_ac].hrat02,
                             g_hrcr[l_ac].hrat03,g_hrcr[l_ac].hrat03_name,
                             g_hrcr[l_ac].hrat04,g_hrcr[l_ac].hrat04_name , 
                             g_hrcr[l_ac].hrat05,g_hrcr[l_ac].hrat05_name,
                             g_hrcr[l_ac].hrat25
               DISPLAY BY NAME g_hrcr[l_ac].hrat02,
                             g_hrcr[l_ac].hrat03,g_hrcr[l_ac].hrat03_name,
                             g_hrcr[l_ac].hrat04,g_hrcr[l_ac].hrat04_name , 
                             g_hrcr[l_ac].hrat05,g_hrcr[l_ac].hrat05_name,
                             g_hrcr[l_ac].hrat25
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_hrcr_t.hrcr02) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrcr_t.hrcr02
                DELETE FROM hrcr_file             #刪除該筆單身資料
                 WHERE hrcr01 = g_hrcr_hd.hrcr01
                   AND hrcr02 = l_hratid
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","hrcr_file",g_hrcr_hd.hrcr01,g_hrcr_t.hrcr02,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.idx
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrcr[l_ac].* = g_hrcr_t.*
               CLOSE i058_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrcr[l_ac].hrcr02,-263,1)
               LET g_hrcr[l_ac].* = g_hrcr_t.*
            ELSE
               UPDATE hrcr_file
                  SET hrcr02 = l_hratid
                 WHERE CURRENT OF i058_bcl
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrcr_file",g_hrcr[l_ac].hrcr02,'',SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_hrcr[l_ac].* = g_hrcr_t.*
                   ROLLBACK WORK
               ELSE
                  #CHI-B20009 add --start--
                  UPDATE hrcr_file
                     SET hrcrmodu = g_user,
                         hrcrdate = g_today
                   WHERE hrcr01 = g_hrcr_hd.hrcr01
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","hrcr_file",g_hrcr[l_ac].hrcr02,'',SQLCA.sqlcode,"","",1) 
                      LET g_hrcr[l_ac].* = g_hrcr_t.*
                      ROLLBACK WORK
                  ELSE
                  #CHI-B20009 add --end--
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                     #CHI-B20009 add --start--
                     SELECT hrcrmodu,hrcrdate
                       INTO g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate
                       FROM hrcr_file
                      WHERE hrcr01 = g_hrcr_hd.hrcr01 AND ROWRUM=1
                     DISPLAY g_hrcr_hd.hrcrmodu,g_hrcr_hd.hrcrdate 
                          TO hrcrmodu,hrcrdate 
                     #CHI-B20009 add --end--
                  END IF #CHI-B20009 add
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_hrcr[l_ac].* = g_hrcr_t.*
               END IF
               CLOSE i058_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i058_bcl
            COMMIT WORK
        ON ACTION CONTROLP  
         CASE     
           WHEN INFIELD(hrcr02)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_hrat01"
              IF p_cmd = 'a' THEN
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL i058_multi_hrcr02()
                 CALL i058_b_fill(" 1=1")
                 CALL i058_show()
                 CALL i058_b()
                 EXIT INPUT
              ELSE 
                 LET g_qryparam.default1 = g_hrcr[l_ac].hrcr02
                 CALL cl_create_qry() RETURNING g_hrcr[l_ac].hrcr02
                 DISPLAY BY NAME g_hrcr[l_ac].hrcr02
                 NEXT FIELD hrcr02 
              END IF
         END CASE
        ON ACTION CONTROLN
            CALL i058_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(hrcr03) AND l_ac > 1 THEN
                LET g_hrcr[l_ac].* = g_hrcr[l_ac-1].*
                NEXT FIELD hrcr03
            END IF
 
        ON ACTION CONTROLZ
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
 
#No.FUN-6B0033 --START
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END
 
        END INPUT
 
    CLOSE i058_bcl
    COMMIT WORK
    CALL i058_delall()
END FUNCTION
 
FUNCTION i058_delall()
    SELECT COUNT(*)
      INTO g_cnt
      FROM hrcr_file
     WHERE hrcr01 = g_hrcr_hd.hrcr01
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM hrcr_file
         WHERE hrcr01 = g_hrcr_hd.hrcr01
    END IF
END FUNCTION
 
#單身重查
FUNCTION i058_b_askkey()
DEFINE
    l_wc2  LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON hrcr03, hrcr06, hrcr07
         FROM s_hrcr[1].hrcr03, s_hrcr[1].hrcr06, s_hrcr[1].hrcr07
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i058_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i058_b_fill(p_wc2)            #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(200) 
    l_cnt    LIKE type_file.num5       #No.FUN-680061 SMALLINT
    LET g_sql =
        "SELECT hrcr02,'','','','','','','',''",
        "  FROM hrcr_file,hrat_file a,hrat_file b",
        " WHERE a.hratid = hrcr05 AND b.hratid = hrcr02 AND hrcr01 ='", g_hrcr_hd.hrcr01, "' ",
        "   AND ", p_wc2 CLIPPED
    PREPARE i058_pb
       FROM g_sql
    DECLARE i058_bcs                             #SCROLL CURSOR
     CURSOR FOR i058_pb
 
    CALL g_hrcr.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i058_bcs INTO g_hrcr[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL i058_hrat_fill(g_hrcr[g_cnt].hrcr02)   #show
                   RETURNING g_hrcr[g_cnt].hrat02,
                             g_hrcr[g_cnt].hrat03,g_hrcr[g_cnt].hrat03_name,
                             g_hrcr[g_cnt].hrat04,g_hrcr[g_cnt].hrat04_name, 
                             g_hrcr[g_cnt].hrat05,g_hrcr[g_cnt].hrat05_name,
                             g_hrcr[g_cnt].hrat25
        SELECT hrat01 INTO g_hrcr[g_cnt].hrcr02 FROM hrat_file WHERE hratid =g_hrcr[g_cnt].hrcr02
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_hrcr.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i058_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_hrcr TO s_hrcr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #NO.TQC-630274
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
            ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
      ON ACTION confirm                         
         LET g_action_choice='confirm'
         EXIT DISPLAY 
      ON ACTION undo_confirm                  
         LET g_action_choice='undo_confirm'
         EXIT DISPLAY
      ON ACTION first
         CALL i058_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION previous
         CALL i058_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION jump
         CALL i058_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION next
         CALL i058_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION last
         CALL i058_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
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
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0033 --START
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i058_hrcr05(p_cmd,l_hrcr05)           #顯示對應的品名及規格
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_hrcr05   LIKE hrcr_file.hrcr05,
           p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02, ima021 INTO l_ima02, l_ima021
      FROM ima_file
     WHERE ima01 = l_hrcr05
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
                                  LET l_ima02 = NULL
                                  LET l_ima021= NULL
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
        DISPLAY l_ima02, l_ima021 TO FORMONLY.ima02, FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION i058_hrcr08(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE hrcr_file.hrcr08,
        l_fac     LIKE pml_file.pml09,  #NO.FUN-680061 DEC(16,8)
        p_cmd     LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
#依參數取得單價預設值
FUNCTION i058_hrat_fill(p_hrcr02)
  DEFINE p_hrcr02    LIKE hrcr_file.hrcr02
  DEFINE l_key       LIKE type_file.chr1
  DEFINE l_hrat03_name  LIKE type_file.chr50
  DEFINE l_hrat04_name  LIKE type_file.chr50 
  DEFINE l_hrat05_name  LIKE type_file.chr50
  DEFINE l_hrat RECORD LIKE hrat_file.*
  SELECT hrat03,hrat04,hrat05,hrat25 
    INTO l_hrat.hrat03,l_hrat.hrat04,l_hrat.hrat05,l_hrat.hrat25
    FROM hrat_file
   WHERE hratid = p_hrcr02 AND hratconf ='Y'
  SELECT hraa02 INTO l_hrat03_name FROM hraa_file WHERE hraa01 = l_hrat.hrat03 AND hraaacti = 'Y'
  SELECT hrao02 INTO l_hrat04_name FROM hrao_file WHERE hrao01 = l_hrat.hrat04 AND hrao00 = l_hrat.hrat03 AND hraoacti = 'Y' 
  SELECT hrap02 INTO l_hrat05_name FROM hrap_file WHERE hrap01 = l_hrat.hrat04 AND hrap05 = l_hrat.hrat05 AND hrapacti = 'Y'
  SELECT hrat02 INTO l_hrat.hrat02 FROM hrat_file WHERE hratconf ='Y' AND hratid = p_hrcr02
  RETURN  l_hrat.hrat02,
         l_hrat.hrat03,l_hrat03_name,
         l_hrat.hrat04,l_hrat04_name, 
         l_hrat.hrat05,l_hrat05_name,
         l_hrat.hrat25  
    
END FUNCTION
 
#-----------------------No:CHI-B60093 add----------------------
FUNCTION i058_auto_hrcr01()
   DEFINE l_yy                 SMALLINT
   DEFINE l_mm                 SMALLINT
   DEFINE l_dd,i                 SMALLINT
   DEFINE ls_date              STRING
   DEFINE l_max_no             LIKE hrcr_file.hrcr01
   DEFINE ls_max_no            STRING
   DEFINE ls_format            STRING
   DEFINE ls_max_pre           STRING
   DEFINE li_max_num           LIKE type_file.num20
   DEFINE li_max_comp          LIKE type_file.num20
   DEFINE l_hrcr01             LIKE hrcr_file.hrcr01
   DEFINE l_sql                STRING
   LET ls_max_pre = '9999999999'    #marked by yeap  NO.130826
  # LET ls_max_pre = '999999999999'   #added by yeap  NO.130826
   LET li_max_num=0
   LET li_max_comp= 0
   LET l_yy   = YEAR(g_today)
   LET l_mm   = MONTH(g_today)
   LET l_dd   = DAY(g_today)
   LET ls_date = l_yy USING "&&&&",l_mm USING "&&",l_dd USING "&&" 
   LET ls_date = ls_date.substring(3,8)   #marked by yeap  NO.130826

   LET l_sql ="SELECT MAX(hrcr01) FROM hrcr_file ",
              " WHERE hrcr01 LIKE '",ls_date CLIPPED,"%'"
   PREPARE auto_no_pre FROM l_sql
   EXECUTE auto_no_pre INTO l_max_no

   IF l_max_no IS NULL THEN
      LET l_hrcr01 = ls_date CLIPPED,'0001'
   ELSE
      LET ls_max_no = l_max_no[7,10]   #marked by yeap  NO.130826
#      LET ls_max_no = l_max_no[9,12]    #added by yeap  NO.130826 
      LET li_max_num = ls_max_pre.subString(1,4)  #最大編號值
      FOR i=1 TO 4
          LET ls_format = ls_format,"&"
      END FOR
      LET li_max_comp = ls_max_no + 1
      IF li_max_comp > li_max_num THEN
         CALL cl_err("","sub-518",1)
      ELSE
         LET l_hrcr01 = ls_date CLIPPED,li_max_comp USING ls_format
      END IF
    END IF    
    RETURN l_hrcr01
END FUNCTION

FUNCTION i058_multi_hrcr02()
   DEFINE   tok         base.StringTokenizer 
   DEFINE   l_hrcr      RECORD LIKE hrcr_file.*
   DEFINE   l_count     LIKE type_file.num5
   DEFINE   l_hratid    LIKE hrat_file.hratid
   DEFINE   l_hratid_hrcr05    LIKE hrat_file.hratid
   LET tok = base.StringTokenizer.create(g_qryparam.multiret,"|")
   WHILE tok.hasMoreTokens()
      LET l_hrcr.hrcr02 = tok.nextToken()
      SELECT COUNT(*) INTO l_count FROM hrat_file
       WHERE hratconf ='Y' AND hrat01 = l_hrcr.hrcr02
      IF cl_null(l_count) THEN LET l_count = 0  END IF
      IF l_count <=0 THEN
         CALL cl_err3("ins","hrcr_file",'',l_hrcr.hrcr02,'ghr-081',"","",1)
         CONTINUE WHILE 
      END IF 
      SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = l_hrcr.hrcr02
      SELECT hratid INTO l_hratid_hrcr05 FROM hrat_file WHERE hrat01 = g_hrcr_hd.hrcr05
      INSERT INTO hrcr_file(hrcr01,hrcr02,hrcr03,hrcr04,hrcr05,hrcr06,hrcr07, 
                                 hrcr08,hrcr09,hrcr10,hrcr11,hrcr12,hrcr13,
                                 hrcr14,hrcr15,hrcr16,hrcr17,hrcr18,hrcr19,
                                  hrcruser,hrcrgrup,hrcrmodu,hrcrdate,hrcroriu,hrcrorig,hrcrconf)
                  VALUES(g_hrcr_hd.hrcr01,l_hratid,
                         g_hrcr_hd.hrcr03,g_hrcr_hd.hrcr04,l_hratid_hrcr05,g_hrcr_hd.hrcr06,g_hrcr_hd.hrcr07,
                         g_hrcr_hd.hrcr08,g_hrcr_hd.hrcr09,g_hrcr_hd.hrcr10,g_hrcr_hd.hrcr11,g_hrcr_hd.hrcr12,
                         g_hrcr_hd.hrcr13,
                         g_hrcr_hd.hrcr14,g_hrcr_hd.hrcr15,g_hrcr_hd.hrcr16,g_hrcr_hd.hrcr17,
                         g_hrcr_hd.hrcr18,g_hrcr_hd.hrcr19,
                         g_user,g_grup,g_hrcr_hd.hrcrmodu,g_today,g_user,g_grup,'N')
    IF STATUS THEN
        CALL cl_err3("ins","hrcr_file",'',l_hrcr.hrcr02,'ghr-080',"","",1)
        CONTINUE WHILE
    ELSE
        UPDATE hrcr_file
           SET hrcrmodu = g_user,
               hrcrdate = g_today
         WHERE hrcr01 = g_hrcr_hd.hrcr01
    END IF           
  END WHILE
END FUNCTION
