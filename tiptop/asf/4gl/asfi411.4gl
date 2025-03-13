# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfi411.4gl
# Descriptions...: 料表批號資料維護作業
# Date & Author..: 92/10/14 By Keith
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號放大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-5B0327 05/12/05 By kim sfd01 碼數不夠,會被截掉
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/23 By sherry  報表改由Crystal Report輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A80054 10/09/14 by jan GP5.25 工單間合拼
# Modify.........: No.FUN-A90035 10/09/17 By vealxu 按了列印之後，ring menu提供兩action"列印PBI明細"和"列印PBI製程料件明"
# Modify.........: No.FUN-A80060 10/09/27 by jan GP5.25 工單間合拼(程式調整)
# Modify.........: No.MOD-AB0021 10/11/02 by zhangll 调用asfi410错误
# Modify.........: No.MOD-AC0325 10/12/25 by sabrina 新增時不呼叫s_check_no()，因單據號碼在asfi410已做過檢查
# Modify.........: No.FUN-B10056 11/02/14 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B30091 11/03/15 By destiny 非制程工单不能审核
# Modify.........: No.TQC-B50079 11/05/23 By zhangll 控管存在作废的工单不允许审核
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤 
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B60137 11/06/16 By xianghui 修改BUG新增後點審核後單身資料不顯示
# Modify.........: No.TQC-B60139 11/06/16 By xianghui sfb01開窗時p_qry裏加有效碼的判斷,並在AFTER FIELD sfb01後加控管
# Modify.........: No.TQC-B60138 11/06/16 By jan 取消確認時，若為工單間合拼才須一併取消工單確認
# Modify.........: No.TQC-BA0194 11/11/02 By lixh1 不走平行工藝時，隱藏合拼版號欄位和相關ACTION
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No.MOD-C90245 12/10/12 By Elise 修改AFTER FIELD sfd03中CHI-C60023修改的sql條件 
# Modify.........: No.MOD-CB0170 13/01/07 By Elise 工單合併功能只限於sfd09=2才檢核
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:CHI-C60001 13/03/08 By Alberti 作廢時,update sfb85='' 取消作廢控卡不能存在其他PBI中,並UPDATE sfb85
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti,sfdoriu,sfdorig，並增加資料權限控管
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D60217 13/06/27 By suncx 審核時判斷使用以查處資料的地方錯誤
# Modify.........: No.FUN-D70031 13/07/05 By xianghui 合併類型為2的PBI明細資料審核時一自動審核工單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_sfd01         LIKE sfd_file.sfd01,   #料表批號
        g_sfd01_t       LIKE sfd_file.sfd01,   #
        g_sfd08         LIKE sfd_file.sfd08,   #FUN-A80054
        g_sfdconf       LIKE sfd_file.sfdconf, #FUN-A80054
        g_sfd09         LIKE sfd_file.sfd09,   #CHI-C60023
        
    g_sfd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sfd02       LIKE sfd_file.sfd02,   #項次
        sfd03       LIKE sfd_file.sfd03,   #工單編號
        sfb05       LIKE sfb_file.sfb05,   #生產料件
        ima02       LIKE ima_file.ima02,   #生產料件
        ima021      LIKE ima_file.ima021,  #生產料件
        sfb04       LIKE sfb_file.sfb04,   #FUN-A80054
        sfd04       LIKE sfd_file.sfd04,   #FUN-A80054
        sfd05       LIKE sfd_file.sfd05,   #FUN-A80054
        sfd06       LIKE sfd_file.sfd06,   #FUN-A80054
        sfd07       LIKE sfd_file.sfd07,   #FUN-A80054
        sfb40       LIKE sfb_file.sfb40,   #優先順序
        sfb13       LIKE sfb_file.sfb13,   #開工日期
        sfb15       LIKE sfb_file.sfb15,    #完工日期  #FUN-D10127 ,
        sfduser     LIKE sfd_file.sfduser,  #FUN-D10127
        sfdgrup     LIKE sfd_file.sfdgrup,  #FUN-D10127 
        sfdmodu     LIKE sfd_file.sfdmodu,  #FUN-D10127
        sfddate     LIKE sfd_file.sfddate,  #FUN-D10127
        sfdoriu     LIKE sfd_file.sfdoriu,  #FUN-D10127
        sfdorig     LIKE sfd_file.sfdorig   #FUN-D10127
        
                    END RECORD,
    g_sfd_t         RECORD                 #程式變數 (舊值)
        sfd02       LIKE sfd_file.sfd02,   #項次
        sfd03       LIKE sfd_file.sfd03,   #工單編號
        sfb05       LIKE sfb_file.sfb05,   #生產料件
        ima02       LIKE ima_file.ima02,   #生產料件
        ima021      LIKE ima_file.ima021,  #生產料件
        sfb04       LIKE sfb_file.sfb04,   #FUN-A80054
        sfd04       LIKE sfd_file.sfd04,   #FUN-A80054
        sfd05       LIKE sfd_file.sfd05,   #FUN-A80054
        sfd06       LIKE sfd_file.sfd06,   #FUN-A80054
        sfd07       LIKE sfd_file.sfd07,   #FUN-A80054
        sfb40       LIKE sfb_file.sfb40,   #優先順序
        sfb13       LIKE sfb_file.sfb13,   #開工日期
        sfb15       LIKE sfb_file.sfb15,    #完工日期  #FUN-D10127 ,
        sfduser     LIKE sfd_file.sfduser,  #FUN-D10127
        sfdgrup     LIKE sfd_file.sfdgrup,  #FUN-D10127 
        sfdmodu     LIKE sfd_file.sfdmodu,  #FUN-D10127
        sfddate     LIKE sfd_file.sfddate,  #FUN-D10127
        sfdoriu     LIKE sfd_file.sfdoriu,  #FUN-D10127
        sfdorig     LIKE sfd_file.sfdorig   #FUN-D10127
        
                    END RECORD,
        g_sfcuser       LIKE sfc_file.sfcuser,
        g_sfcgrup       LIKE sfc_file.sfcgrup,
        g_sfcmodu       LIKE sfc_file.sfcmodu,
        g_sfcdate       LIKE sfc_file.sfcdate,
        g_sfcacti       LIKE sfc_file.sfcacti,
        g_ss                LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        g_t1                LIKE oay_file.oayslip,            #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
        g_del_pt            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_flag              LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        g_delete            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        g_wc,g_sql          string,  #No.FUN-580092 HCN
        g_rec_b         LIKE type_file.num5,                  #單身筆數        #No.FUN-680121 SMALLINT
        l_ac            LIKE type_file.num5,                  #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0090
        g_argv1         LIKE sfd_file.sfd01,     # 料表批號
        g_argv2         STRING,                  # 執行功能     #TQC-630068
        g_argv3         LIKE sfd_file.sfd02      # 供應商編號   #TQC-630068 將供應商編號從g_argv2->g_argv3
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
#FUN-760085--start                                                              
   DEFINE  l_table    STRING                                                    
   DEFINE  l_sql      STRING
   DEFINE  g_str      STRING                                                    
#FUN-760085--end               
DEFINE   g_chr          LIKE type_file.chr1

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0090
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT
 
  #start TQC-630068
   LET g_argv1=ARG_VAL(1)   #料表批號
   LET g_argv2=ARG_VAL(2)   #執行功能
   LET g_argv3=ARG_VAL(3)   #供應商編號
  #end TQC-630068

  
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090 #FUN-BB0047
#No.FUN-760085---Begin
#  LET g_sql = "sfd01.sfd_file.sfd01,",    #FUN-A90035 mark
#              "sfc02.sfc_file.sfc02,",    #FUN-A90035 mark
#              "sfd02.sfd_file.sfd02,",    #FUN-A90035 mark
#              "sfd03.sfd_file.sfd03,"     #FUN-A90035 mark
 #FUN-A90035 -------------add start---------------------------
   LET g_sql = "sfd01.sfd_file.sfd01,",
               "sfc02.sfc_file.sfc02,",  
               "sfd08.sfd_file.sfd08,",
               "sfdconf.sfd_file.sfdconf,",
               "sfd02.sfd_file.sfd02,",
               "sfd03.sfd_file.sfd03,",
               "sfb05.sfb_file.sfb05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "sfb04.sfb_file.sfb04,",
               "sfb40.sfb_file.sfb40,",
               "sfd04.sfd_file.sfd04,", 
               "sfd05.sfd_file.sfd05,",
               "sfd06.sfd_file.sfd06,",
               "sfd07.sfd_file.sfd07,",
               "sfb13.sfb_file.sfb13,",
               "sfb15.sfb_file.sfb15, ",
               "sfd09.sfd_file.sfd09," ,     #CHI-C60023  #FUN-D10127 ,
               "sfduser.sfd_file.sfduser," ,              #FUN-D10127 
               "sfdgrup.sfd_file.sfdgrup," ,              #FUN-D10127 
               "sfdmodu.sfd_file.sfdmodu," ,              #FUN-D10127 
               "sfddate.sfd_file.sfddate," ,              #FUN-D10127 
               "sfdoriu.sfd_file.sfdoriu," ,              #FUN-D10127
               "sfdorig.sfd_file.sfdorig"                 #FUN-D10127
#FUN-A90035 ---------------add end---------------------------------
   LET l_table = cl_prt_temptable('asfi411',g_sql) CLIPPED                     
   IF l_table = -1 THEN EXIT PROGRAM END IF                                    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                       
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,   ?,?,?,? ) "    #FUN-A90035 add 13? #CHI-C60023       #FUN-D10127 add 6?                      
   PREPARE insert_prep FROM g_sql                                              
   IF STATUS THEN                                                              
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
   END IF                                                                      
#No.FUN-760085---End      

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
    LET g_forupd_sql = "SELECT * FROM sfd_file WHERE sfd01 = ? AND sfd02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i411_crl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 1 LET p_col = 18
 
    OPEN WINDOW i411_w AT p_row,p_col WITH FORM "asf/42f/asfi411"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("sfd07",g_sma.sma541='Y')  #FUN-A80054

#TQC-BA0194 -----------------Begin--------------
    IF g_sma.sma541='Y' THEN
       CALL cl_set_comp_visible("sfd04,sfd05,sfd06,sfd08",TRUE)
       CALL cl_set_act_visible("pbi_form,sel_report",TRUE)
    ELSE
       CALL cl_set_comp_visible("sfd04,sfd05,sfd06,sfd08",FALSE)
       CALL cl_set_act_visible("pbi_form,sel_report",FALSE)
    END IF
#TQC-BA0194 -----------------End----------------

   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i411_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i411_a()
             END IF
          OTHERWISE          #TQC-660067 add
             CALL i411_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068
 
    LET g_sfd01 = NULL
    LET g_delete= 'N'
 
    CALL i411_menu()
 
    CLOSE WINDOW i411_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
#QBE 查詢資料
FUNCTION i411_cs()
    CLEAR FORM                             #清除畫面
    CALL g_sfd.clear()
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " sfd01 = '",g_argv1,"'"
  ELSE
 #end TQC-630068 
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
   INITIALIZE g_sfd01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON sfd01,sfd08,sfdconf,sfd02,sfd03,sfd04,sfd05,sfd06,sfd07,sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig   #FUN-A80054 #FUN-D10127 add sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig
         FROM sfd01,sfd08,sfdconf,s_sfd[1].sfd02,s_sfd[1].sfd03,s_sfd[1].sfd04,s_sfd[1].sfd05,s_sfd[1].sfd06,s_sfd[1].sfd07   #FUN-A80054
              ,s_sfd[1].sfduser,s_sfd[1].sfdgrup,s_sfd[1].sfdmodu,s_sfd[1].sfddate,s_sfd[1].sfdoriu,s_sfd[1].sfdorig                   #FUN-D10127
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp         #查詢批號
          CASE
            WHEN INFIELD(sfd01)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     ="q_sfc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfd01
               NEXT FIELD sfd01
            #FUN-A80054--begin--add---------------
            WHEN INFIELD(sfd08)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     ="q_eda"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfd08
               NEXT FIELD sfd08
            WHEN INFIELD(sfd07)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
             # LET g_qryparam.form     ="q_ecm_1"      #FUN-B10056 makr
               LET g_qryparam.form     ="q_ecb012_1"   #FUN-B10056
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfd07
               NEXT FIELD sfd07
            #FUN-A80054--end--add----------------
          END CASE
 
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
  END IF   #TQC-630068
 
    IF INT_FLAG THEN  RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sfcuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sfcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sfcgrup IN ",cl_chk_tgrup_list()
    #    END IF
    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfcuser', 'sfcgrup') #FUN-D10127 mark
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfduser', 'sfdgrup') #FUN-D10127 
    #End:FUN-980030
 
    LET g_sql= "SELECT UNIQUE sfd01 FROM sfd_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1 "
    PREPARE i411_prepare FROM g_sql      #預備一下
    DECLARE i411_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i411_prepare
 
#因主鍵值有兩個故所抓出資料筆數有誤
    LET g_sql="SELECT  COUNT(DISTINCT sfd01) ",
              " FROM sfd_file WHERE ", g_wc CLIPPED
    PREPARE i411_precount FROM g_sql
    DECLARE i411_count CURSOR FOR i411_precount
END FUNCTION
 
FUNCTION i411_menu()
DEFINE l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i411_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i411_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i411_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i411_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i411_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i411_out()
            END IF

#FUN-A80054--begin--add-------------------------            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i411_confirm()
               CALL i411_show()
            END IF
        
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i411_z()
               CALL i411_show()
            END IF
            
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i411_x()      #CHI-D20010
               CALL i411_x(1)     #CHI-D20010
               CALL i411_show()
            END IF

        #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i411_x(2)
               CALL i411_show()
            END IF
         #CHI-D20010---end
         
        WHEN "PBI_Form"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
             IF l_ac >0 THEN                                                                                          
               LET l_cmd = "asfi412 "," '",g_sfd01,"'",                                                                             
                           " '",g_sfd[l_ac].sfd02,"' "                                                                             
               CALL cl_cmdrun(l_cmd)                                                                                                
             END IF                                                                                                                 
            END IF
            
        WHEN "WO_Detail"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
             IF l_ac >0 THEN                                                                                          
               IF s_industry('slk') THEN
                  LET l_cmd = "asfi301_slk "," '",g_sfd[l_ac].sfd03,"'"                                                                                                                                                        
               ELSE
                  LET l_cmd = "asfi301 "," '",g_sfd[l_ac].sfd03,"'"                                                                                                                                                        
               END IF
               CALL cl_cmdrun(l_cmd)                                                                                                
             END IF                                                                                                                 
            END IF
#FUN-A80054--end--add-------------------------
                
        #FUN-A80060--begin--add------------------
        WHEN "sel_report"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
             IF l_ac >0 THEN                                                                                          
               LET l_cmd = "asft700 '' 'query' '' '' '' '",g_sfd[l_ac].sfd03,"'" clipped 
               CALL cl_cmdrun(l_cmd)                                                                                                
             END IF                                                                                                                 
            END IF
        #FUN-A80060--end--add---------------------

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfd),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sfd01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfd01"
                 LET g_doc.value1 = g_sfd01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i411_a()
DEFINE li_result LIKE type_file.num5               #No.FUN-550067        #No.FUN-680121 SMALLINT
 
    MESSAGE ""
    CLEAR FORM
    CALL g_sfd.clear()
    LET g_sfd01  = ' '
    LET g_sfd01_t  = ' '
    LET g_sfd08=''    #FUN-A80054
    LET g_sfdconf='N' #FUN-A80054
    LET g_sfd09='1'   #CHI-C60023
    CALL cl_opmsg('a')
    WHILE TRUE
       #start TQC-630068
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_sfd01 = g_argv1
        END IF
       #end TQC-630068
        CALL i411_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            LET g_sfd01  = NULL
         #  CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        BEGIN WORK   #No:7829
        #No.FUN-550067  --start
       #CALL s_auto_assign_no("asf",g_sfd01,g_today,"8","sfd_file","sfd01","","","") #FUN-A80054
       #  RETURNING li_result,g_sfd01     #FUN-A80054
       #IF (NOT li_result) THEN           #FUN-A80054
       #   ROLLBACK WORK                  #FUN-A80054
       #   CONTINUE WHILE                 #FUN-A80054
       #END IF                            #FUN-A80054
        DISPLAY g_sfd01 TO sfd01
#        IF g_smy.smyauno='Y' THEN
#           CALL s_mfgauno(g_sfd01) RETURNING g_i,g_sfd01
#           IF g_i THEN #有問題
#              ROLLBACK WORK   #No:7829
#              CONTINUE WHILE
#           END IF
#           DISPLAY g_sfd01 TO sfd01
#        END IF
        #No.FUN-550067  --end
        COMMIT WORK  #No:7829
 
        CALL cl_flow_notify(g_sfd01,'I')
 
        LET g_rec_b=0                   #No.FUN-680064 
        CALL i411_b_fill('1=1')         #單身
        CALL i411_b()                   #輸入單身
#       INSERT INTO sfd_file VALUES(g_sfd01,g_sfd[l_ac].sfd02,
#              g_sfd[l_ac].sfd03,' ', ' ',' ',' ',' ') # DISK WRITE
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_sfd01,SQLCA.sqlcode,0)    #MOD-480349
            #CONTINUE WHILE                          #MOD-480349
        ELSE
            LET g_sfd01_t = g_sfd01                # 保存上筆資料
            SELECT sfd01 INTO g_sfd01 FROM sfd_file
                WHERE sfd01 = g_sfd01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i411_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(70)
    l_n,l_cnt       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_desc     LIKE smy_file.smydesc,
    l_sfc02    LIKE sfc_file.sfc02,
    l_str           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
    li_result       LIKE type_file.num5,                 #No.FUN-550067        #No.FUN-680121 SMALLINT
    l_sfcacti       LIKE sfc_file.sfcacti         #TQC-B60139  add
 
    LET g_ss='Y'  
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031 
    
    DISPLAY g_sfdconf TO sfdconf   #FUN-A80054 
    INPUT g_sfd09,g_sfd01,g_sfd08 WITHOUT DEFAULTS FROM sfd09,sfd01,sfd08   #FUN-A80054 #CHI-C60023
 
        #MOD-5B0327...............begin
        BEFORE INPUT
            CALL cl_set_docno_format("sfd01")
        #MOD-5B0327...............end
        AFTER FIELD sfd01                   #料表批號
            SELECT count(*) INTO g_cnt FROM sfd_file
                   WHERE sfd01 = g_sfd01
            IF g_cnt > 0 THEN
               CALL cl_err('','asf-421',0)
               NEXT FIELD sfd01
            END IF
            IF g_sfd01 IS NULL OR g_sfd01 = ' ' THEN
                NEXT FIELD sfd01
            END IF
            #No.B638 010713 by linda check必須存在asfi410檔案中
            SELECT sfc02 INTO l_sfc02
              FROM sfc_file
             WHERE sfc01 = g_sfd01
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660128
               CALL cl_err3("sel","sfc_file",g_sfd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
               NEXT FIELD sfd01
            END IF
            #No.B638 end----
            #No.FUN-550067  --start
           #MOD-AC0325---mark---start---
           #CALL s_check_no("asf",g_sfd01,g_sfd01_t,"8","sfd_file","sfd01","")
           #  RETURNING li_result,g_sfd01
           #DISPLAY BY NAME g_sfd01
           #IF (NOT li_result) THEN
    	   #   NEXT FIELD sfd01
           #END IF
           #MOD-AC0325---mark---end---
           # LET g_t1=g_sfd01[1,3]
           # IF cl_null(g_sfd01[5,10]) THEN
           #    CALL s_mfgslip(g_t1,'asf','8')       #檢查單別
           #    IF NOT cl_null(g_errno) THEN         #抱歉, 有問題
           #        CALL cl_err(g_t1,g_errno,0)
           #        NEXT FIELD sfd01
           #    END IF
           # END IF
            #NO.FUN-550067 --end
            SELECT sfc02 INTO l_sfc02 FROM sfc_file
                   WHERE sfc01 = g_sfd01
            DISPLAY l_sfc02 TO sfc02
            #TQC-B60139-add-str--
            IF NOT cl_null(g_sfd01) THEN 
               SELECT sfcacti INTO l_sfcacti FROM sfc_file WHERE sfc01=g_sfd01
               IF l_sfcacti = 'N' THEN
                  CALL cl_err(g_sfd01,9028,0)
                  NEXT FIELD sfd01
               END IF
            END IF
            #TQC-B60139-add-end--
         
        #FUN-A80054--begin--add---------------   
        AFTER FIELD sfd08
          IF NOT cl_null(g_sfd08) THEN
             LET l_cnt=0
             SELECT count(*) INTO l_cnt FROM eda_file
              WHERE eda01=g_sfd08
                AND edaconf='Y'
             IF l_cnt = 0 THEN
                CALL cl_err(g_sfd08,'aec-057',1)
                NEXT FIELD sfd08
             END IF
          END IF
          #FUN-A80054--end--add---------------
 
        AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION controlp         #查詢批號
          CASE
            WHEN INFIELD(sfd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_sfc"
               LET g_qryparam.default1 = g_sfd01
               CALL cl_create_qry() RETURNING g_sfd01
#               CALL FGL_DIALOG_SETBUFFER( g_sfd01 )
               IF g_sfd01 IS NULL THEN
                  DISPLAY g_sfd01_t TO sfd01
               ELSE
                  DISPLAY g_sfd01 TO sfd01
               END IF
             #FUN-A80054--begin--add---------
             WHEN INFIELD(sfd08)
                CALL cl_init_qry_var()
                LET g_qryparam.form     ="q_eda"
                LET g_qryparam.default1 = g_sfd08
                CALL cl_create_qry() RETURNING g_sfd08
                DISPLAY g_sfd08 TO sfd08
             #FUN-A80054--end--add------------
          END CASE
 
        ON ACTION mntn_pbi                  #建立批號資料
              #LET l_cmd="asfi410" clipped            #TQC-630068 mark
              #Mod No.MOD-AB0021
              #LET l_cmd="asfi410"," '' ''" clipped   #TQC-630068
               IF s_industry('slk') THEN
                  LET l_cmd="asfi410_slk"," '' ''" clipped   #TQC-630068
               ELSE
                  LET l_cmd="asfi410"," '' ''" clipped   #TQC-630068
               END IF
              #End Mod No.MOD-AB0021
               CALL cl_cmdrun(l_cmd)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfd01 TO NULL               #No.FUN-6A0164
    INITIALIZE g_sfd08 TO NULL               #FUN-A80054
    INITIALIZE g_sfd09 TO NULL               #CHI-C60023
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_sfd.clear()
    CALL i411_cs()                           #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i411_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sfd01 TO NULL
    ELSE
        CALL i411_fetch('F')                 #讀出TEMP第一筆並顯示
        OPEN i411_count
        FETCH i411_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680121 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i411_b_cs INTO g_sfd01
        WHEN 'P' FETCH PREVIOUS i411_b_cs INTO g_sfd01
        WHEN 'F' FETCH FIRST    i411_b_cs INTO g_sfd01
        WHEN 'L' FETCH LAST     i411_b_cs INTO g_sfd01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i411_b_cs INTO g_sfd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_sfd01,SQLCA.sqlcode,0)
        INITIALIZE g_sfd01 TO NULL  #TQC-6B0105
    ELSE
        OPEN i411_count
        FETCH i411_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i411_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i411_show()
  DEFINE
      l_sfc02   LIKE sfc_file.sfc02,
      l_desc    LIKE smy_file.smydesc
 
    SELECT DISTINCT sfd08,sfdconf,sfd09 INTO g_sfd08,g_sfdconf,g_sfd09 FROM sfd_file WHERE sfd01=g_sfd01  #FUN-A80054 #CHI-C60023
    DISPLAY g_sfd01 TO sfd01               #單頭
    DISPLAY g_sfd08 TO sfd08       #FUN-A80054
    DISPLAY g_sfdconf TO sfdconf   #FUN-A80054
    DISPLAY g_sfd09 TO sfd09       #CHI-C60023
    SELECT sfc02 INTO l_sfc02 FROM sfc_file WHERE sfc01 = g_sfd01
    IF SQLCA.sqlcode THEN LET l_sfc02 = ' ' END IF
    DISPLAY l_sfc02 TO sfc02
    CALL i411_b_fill(g_wc)              #單身
    CALL i411_show_pic()                #FUN-A80054
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION i411_r()
  DEFINE
    l_sfd03      LIKE sfd_file.sfd03
    IF s_shut(0) THEN RETURN END IF
    IF g_sfd01 IS NULL OR g_sfd01 = ' ' THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #FUN-A80054--begin--add------------
    IF g_sfdconf = 'Y' OR g_sfdconf = 'X' THEN
       CALL cl_err('','apc-138',0) 
       RETURN
    END IF
    #FUN-A80054--end--add---------------
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfd01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DECLARE sfdcur CURSOR FOR SELECT sfd03 FROM sfd_file
                 WHERE sfd01 = g_sfd01
        FOREACH sfdcur INTO l_sfd03
           UPDATE sfb_file set(sfb85) = (' ')
                     WHERE sfb01 = l_sfd03
        END FOREACH
        DELETE FROM sfd_file WHERE sfd01 = g_sfd01
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("del","sfd_file",g_sfd01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660128
        ELSE
            DELETE FROM edg_file WHERE edg01=g_sfd01  #FUN-A80054
            DELETE FROM edh_file WHERE edh01=g_sfd01  #FUN-A80054
            CLEAR FORM
            CALL g_sfd.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i411_count
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i411_b_cs
               CLOSE i411_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i411_count INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i411_b_cs
               CLOSE i411_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i411_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i411_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i411_fetch('/')
            END IF
 
        END IF
    END IF
 
    COMMIT WORK
    CALL cl_flow_notify(g_sfd01,'D')
 
END FUNCTION
 
#單身
FUNCTION i411_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(70)
    l_str           LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
    l_sfb39         LIKE sfb_file.sfb39,
    l_sfb85         LIKE sfb_file.sfb85,
    l_sfb02         LIKE sfb_file.sfb02,
    l_sfb04         LIKE sfb_file.sfb04,
    l_pt            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sfa06         LIKE sfa_file.sfa06,
    l_sfa061        LIKE sfa_file.sfa061,
    rtn_sfd03       LIKE sfd_file.sfd03,
    l_acti          LIKE sfb_file.sfbacti,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
DEFINE i,l_cnt    LIKE type_file.num5    #FUN-A80054
DEFINE l_sfd05    LIKE sfd_file.sfd05    #FUN-A80054

    LET g_action_choice = ""
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_sfd01 IS NULL OR g_sfd01 = ' '  THEN
        RETURN
    END IF
 
    IF g_sfdconf='Y' OR g_sfdconf='X' THEN RETURN END IF #FUN-A80054

    SELECT sfcacti INTO l_acti
           FROM sfc_file WHERE sfc01 = g_sfd01
    IF l_acti = 'N'  OR l_acti = 'n' THEN
           LET l_str = g_sfd01 CLIPPED
           CALL cl_err(l_str,'mfg1000',0)
    END IF
 
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql = "SELECT sfd02,sfd03,'','','','',sfd04,sfd05,sfd06,sfd07,'','','' FROM sfd_file ", #FUN-A80054
                       " WHERE sfd01=  ? AND sfd02 = ? AND sfd03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i411_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    #CKP
    IF g_rec_b=0 THEN CALL g_sfd.clear() END IF
 
    INPUT ARRAY g_sfd WITHOUT DEFAULTS FROM s_sfd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #FUN-A80054--begin--add-----------
            IF NOT cl_null(g_sfd08) THEN
               CALL cl_set_comp_required('sfd04',TRUE)
            ELSE
               CALL cl_set_comp_required('sfd04',FALSE)
            END IF
            #FUN-A80054--end--add-------------
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sfd_t.* = g_sfd[l_ac].*  #BACKUP
                OPEN i411_bcl USING g_sfd01,g_sfd_t.sfd02,g_sfd_t.sfd03
                IF STATUS THEN
                   CALL cl_err("OPEN i411_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i411_bcl INTO g_sfd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sfd_t.sfd03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                      #LET g_sfd_t.*=g_sfd[l_ac].*  #FUN-A80054
                       SELECT sfb05,sfb40,sfb13,sfb15,sfb04,ima02,ima021   #FUN-A80054   
                         INTO g_sfd[l_ac].sfb05,g_sfd[l_ac].sfb40,
                              g_sfd[l_ac].sfb13,g_sfd[l_ac].sfb15,g_sfd[l_ac].sfb04, #FUN-A80054
                              g_sfd[l_ac].ima02,g_sfd[l_ac].ima021
                         FROM sfb_file,ima_file
                        WHERE sfb01=g_sfd[l_ac].sfd03
                          AND ima01=sfb05
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            BEGIN WORK
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sfd[l_ac].* TO NULL      #900423
            LET g_sfd[l_ac].sfd05=1               #FUN-A80054
            LET g_sfd_t.* = g_sfd[l_ac].*         #新輸入資料
            LET g_sfd[l_ac].sfduser = g_user                      #FUN-D10127
            LET g_sfd[l_ac].sfdgrup = g_grup                      #FUN-D10127
           # LET g_sfd[l_ac].sfdmodu = g_user                     #FUN-D10127
            LET g_sfd[l_ac].sfddate = g_today                     #FUN-D10127
            LET g_sfd[l_ac].sfdoriu = g_user                      #FUN-D10127
            LET g_sfd[l_ac].sfdorig = g_today                     #FUN-D10127
            
            
           
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sfd02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT sfb39,sfb04 INTO l_sfb39,l_sfb04 FROM sfb_file
             WHERE g_sfd[l_ac].sfd03 = sfb01
            IF g_sfd09='2' THEN    #MOD-CB0170 add
               IF l_sfb04  MATCHES '[1]' THEN   #FUN-A80054
                  # 單身新增
                  SELECT sfb85 INTO l_sfb85 FROM sfb_file
                       WHERE sfb01 = g_sfd[l_ac].sfd03
                  IF l_sfb85 IS  NULL OR l_sfb85 = ' ' THEN
                     CALL delsfd()
                  ELSE
                     IF s_delsfd(0,0,'2') THEN  #新工單單號已有批號,INSERT
                        CALL delsfd()
                        LET g_del_pt = "N"
                     ELSE
                        INITIALIZE g_sfd[l_ac].* TO NULL
                        NEXT FIELD sfd02
                     END IF
                  END IF
               ELSE
                  SELECT COUNT(*) INTO g_cnt FROM sfd_file WHERE sfd01 = g_sfd01
                  IF g_sfd[l_ac].sfd03 != g_sfd_t.sfd03 AND
                     g_cnt = 0 and l_sfb04  MATCHES '[1]' THEN   #FUN-A80054
                     IF s_delsfd(0,0,'3') THEN  #新工單單號無批號,UPDATE!
                        CALL delsfd2()
                        LET g_del_pt = "N"
                     ELSE
                        INITIALIZE g_sfd[l_ac].* TO NULL
                     END IF
                  END IF
               END IF
           #MOD-CB0170---S
            ELSE
               SELECT sfb85 INTO l_sfb85 FROM sfb_file
                    WHERE sfb01 = g_sfd[l_ac].sfd03
               IF l_sfb85 IS  NULL OR l_sfb85 = ' ' THEN
                  CALL delsfd()
               ELSE
                  IF s_delsfd(0,0,'2') THEN  #新工單單號已有批號,INSERT
                     CALL delsfd()
                     LET g_del_pt = "N"
                  ELSE
                     INITIALIZE g_sfd[l_ac].* TO NULL
                     NEXT FIELD sfd02
                  END IF
               END IF
               SELECT COUNT(*) INTO g_cnt FROM sfd_file WHERE sfd01 = g_sfd01
               IF g_sfd[l_ac].sfd03 != g_sfd_t.sfd03 AND g_cnt = 0 THEN
                  IF s_delsfd(0,0,'3') THEN  #新工單單號無批號,UPDATE!
                     CALL delsfd2()
                     LET g_del_pt = "N"
                  ELSE
                     INITIALIZE g_sfd[l_ac].* TO NULL
                  END IF
               END IF
           #MOD-CB0170---E
            END IF
 
        BEFORE FIELD sfd02                        # dgeeault 序號
 
            IF g_sfd[l_ac].sfd02 IS NULL OR g_sfd[l_ac].sfd02 = 0 THEN
                SELECT max(sfd02)+1 INTO g_sfd[l_ac].sfd02 FROM sfd_file
                    WHERE sfd01 = g_sfd01 {AND sfd03 = g_sfd03 }
                IF g_sfd[l_ac].sfd02 IS NULL THEN
                    LET g_sfd[l_ac].sfd02 = 1
                END IF
            END IF
 
        AFTER FIELD sfd02
            IF NOT cl_null(g_sfd[l_ac].sfd02) THEN
               IF g_sfd[l_ac].sfd02 != g_sfd_t.sfd02 OR
                  g_sfd_t.sfd02 IS NULL THEN
 
                  SELECT count(*) INTO l_n FROM sfd_file
                   WHERE sfd01 = g_sfd01 AND g_sfd[l_ac].sfd02 = sfd02
 
                  IF l_n > 0 THEN
                     CALL cl_err('','asf-406',0)
                     LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02
                     NEXT FIELD sfd02
                  END IF
 
               END IF
            END IF
 
        AFTER FIELD sfd03
            IF NOT cl_null(g_sfd[l_ac].sfd03) THEN
               #CHI-C60023---begin
               IF g_sfd09 = '1' THEN 
                  LET l_cnt=0
                  SELECT count(*) INTO l_cnt FROM sfb_file
                   WHERE sfb01=g_sfd[l_ac].sfd03
                    #AND sfb04='2'           #MOD-C90245 mark
                     AND sfb04 IN ('2','3')  #MOD-C90245 
                     AND sfbacti='Y'
                     AND sfb87 = 'Y'
                  IF l_cnt = 0 THEN CALL cl_err('','asf-608',1) NEXT FIELD sfd03 END IF
               ELSE  #IF g_sfd09 = '2' THEN  
               #CHI-C60023---end
                  #FUN-A80054--begin--add------------------
                  LET l_cnt=0
                  SELECT count(*) INTO l_cnt FROM sfb_file
                   WHERE sfb01=g_sfd[l_ac].sfd03
                     #AND sfb04='1'                   #CHI-C60023
                     AND sfbacti='Y' #AND sfb87<>'X'  #CHI-C60023
                     AND sfb87 = 'N'
                  IF l_cnt = 0 THEN CALL cl_err('','asf-600',1) NEXT FIELD sfd03 END IF
               #FUN-A80054--end--add-------------------
               END IF  #CHI-C60023
               LET g_del_pt = "Y"
               IF (g_sfd[l_ac].sfd02 IS NOT NULL OR g_sfd[l_ac].sfd02 != 0) AND
                  (g_sfd[l_ac].sfd03 IS NOT NULL OR g_sfd[l_ac].sfd03 != ' ') THEN
                  #批號,項次,工單單號不可重覆
                   SELECT count(*) INTO l_n FROM sfd_file
                    WHERE sfd01 = g_sfd01 AND g_sfd[l_ac].sfd02 = sfd02
                      AND sfd03 = g_sfd[l_ac].sfd03
                   IF l_n > 0 THEN
                      IF NOT (g_sfd[l_ac].sfd02 = g_sfd_t.sfd02 AND
                         g_sfd[l_ac].sfd03 = g_sfd_t.sfd03) THEN
                         CALL cl_err('','asf-407',0)
                        #LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02  #FUN-A80054
                         LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                         NEXT FIELD sfd02
                      END IF
                   END IF
 
                  #批號,工單單號不可重覆
                   SELECT count(*) INTO l_n FROM sfd_file
                       WHERE sfd01 = g_sfd01 AND g_sfd[l_ac].sfd03 = sfd03
                   IF l_n > 0 THEN
                       IF (g_sfd[l_ac].sfd02 != g_sfd_t.sfd02 OR cl_null(g_sfd_t.sfd02)) AND   #FUN-A80054
                          (g_sfd[l_ac].sfd03 != g_sfd_t.sfd03 OR cl_null(g_sfd_t.sfd03)) THEN  #FUN-A80054
                          CALL cl_err('','asf-408',0)
                         #LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02   #FUN-A80054
                          LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                          NEXT FIELD sfd03
                       END IF
                   END IF
 
                  #工單單號不可重覆
                   SELECT count(*) INTO l_n FROM sfd_file
                    WHERE sfd03 = g_sfd[l_ac].sfd03
 
                   IF l_n > 0 THEN
                      IF (g_sfd[l_ac].sfd02 <> g_sfd_t.sfd02 OR cl_null(g_sfd_t.sfd02)) AND      #FUN-A80054
                         (g_sfd[l_ac].sfd03 <> g_sfd_t.sfd03 OR cl_null(g_sfd_t.sfd03)) THEN     #FUN-A80054
                         IF s_delsfd(0,0,'1') THEN #新工單單號原已有批號,UPDATE!
                            CALL delsfd1()
                            LET g_del_pt =  "N"
                         ELSE
                            CALL cl_err('','asf-409',0)
                           #LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02  #FUN-A80054
                            LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                            NEXT FIELD sfd03
                         END IF
                      END IF
                   END IF
 
                   SELECT sfb05,sfb40,sfb13,sfb15,sfb04,ima02,ima021  #FUN-A80054    
                     INTO g_sfd[l_ac].sfb05,g_sfd[l_ac].sfb40,
                          g_sfd[l_ac].sfb13,g_sfd[l_ac].sfb15,g_sfd[l_ac].sfb04,  #FUN-A80054
                          g_sfd[l_ac].ima02,g_sfd[l_ac].ima021       
                     FROM sfb_file,ima_file
                    WHERE sfb01=g_sfd[l_ac].sfd03
                      AND ima01=sfb05
                   DISPLAY g_sfd[l_ac].ima02 TO FORMONLY.ima02
                   DISPLAY g_sfd[l_ac].ima021 TO FORMONLY.ima021
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_sfd[l_ac].sfb05
                   DISPLAY BY NAME g_sfd[l_ac].sfb40
                   DISPLAY BY NAME g_sfd[l_ac].sfb13
                   DISPLAY BY NAME g_sfd[l_ac].sfb15
                   DISPLAY BY NAME g_sfd[l_ac].ima02
                   DISPLAY BY NAME g_sfd[l_ac].ima021
                   #------MOD-5A0095 END------------
                   DISPLAY BY NAME g_sfd[l_ac].sfduser  #FUN-D10127
                   DISPLAY BY NAME g_sfd[l_ac].sfdgrup  #FUN-D10127
                   DISPLAY BY NAME g_sfd[l_ac].sfdmodu  #FUN-D10127
                   DISPLAY BY NAME g_sfd[l_ac].sfddate  #FUN-D10127
                   DISPLAY BY NAME g_sfd[l_ac].sfdoriu  #FUN-D10127
                   DISPLAY BY NAME g_sfd[l_ac].sfdorig  #FUN-D10127
               END IF
 
              #SELECT sfbacti,count(*) INTO l_acti,l_n             #FUN-A80054
              #     FROM sfb_file                                  #FUN-A80054
              #     WHERE sfb01 = g_sfd[l_ac].sfd03 AND sfb87!='X' #FUN-A80054
              #     GROUP BY sfbacti                               #FUN-A80054  
              #IF l_n = 0 THEN                #檢查工單檔是否存在  #FUN-A80054 
              #   CALL cl_err('','asf-410',0)                      #FUN-A80054
              #   LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02            #FUN-A80054  
              #   LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03            #FUN-A80054
              #   NEXT FIELD sfd02                                 #FUN-A80054
              #END IF                                              #FUN-A80054  
 
               SELECT sfb39,sfb04 INTO l_sfb39,l_sfb04 FROM sfb_file
                      WHERE g_sfd[l_ac].sfd03 = sfb01
               IF (g_sfd_t.sfd03 IS  NULL OR g_sfd_t.sfd03 = ' ') THEN
                  IF g_sfd09='2' THEN  #MOD-CB0170 add
                     IF l_sfb39 = "1" THEN    #在發料狀態下
                        IF l_sfb04 NOT MATCHES '[1]' THEN   #FUN-A80054
                           INITIALIZE g_sfd[l_ac].* TO NULL
                           CALL cl_err('','asf-418',0)
                           NEXT FIELD sfd02
                        END IF
                     END IF
 
                     IF l_sfb39 = "2" THEN    #在領料狀態下
                        IF l_sfb04 NOT MATCHES '[1]' THEN  #FUN-A80054
                           INITIALIZE g_sfd[l_ac].* TO NULL
                           CALL cl_err('','asf-419',0)
                           NEXT FIELD sfd02
                        END IF
                     END IF
                  END IF  #MOD-CB0170 add
               END IF
 
             # IF l_acti = "N" OR l_acti = "n" THEN  #是否為有效碼 #FUN-A80054
             #    CALL cl_err('','asf-411',0)        #FUN-A80054
             #    LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02 #FUN-A80054
             #    LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03 #FUN-A80054
             #    NEXT FIELD sfd03
             # END IF
               LET g_cnt = g_cnt + 1
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_sfd[l_ac].sfd02
               DISPLAY BY NAME g_sfd[l_ac].sfd03
               # ------MOD-5A0095 END------------
               #FUN-A80054--begin--add-----------
               IF g_sfd[l_ac].sfd03<>g_sfd_t.sfd03 OR cl_null(g_sfd_t.sfd03) THEN
                  IF NOT cl_null(g_sfd08) THEN
                     CALL i411_sfd03()
                  END IF
               END IF
               #FUN-A80054--end--add-------------
            END IF
 
        #FUN-A80054--begin--add---------------------  
        AFTER FIELD sfd04
          IF NOT cl_null(g_sfd[l_ac].sfd04) THEN
             IF g_sfd[l_ac].sfd04<>g_sfd_t.sfd04 OR
                cl_null(g_sfd_t.sfd04) THEN
                IF g_sfd[l_ac].sfd04 < 0 THEN
                   CALL cl_err('','aim-223',1)
                   NEXT FIELD sfd04
                END IF
                SELECT count(*) INTO l_cnt FROM sfd_file
                 WHERE sfd01=g_sfd01
                   AND sfd04=g_sfd[l_ac].sfd04
                IF l_cnt > 0 THEN
                   CALL cl_err('','afa-132',1)
                   NEXT FIELD sfd04
                END IF
             END IF
          END IF               
              
        AFTER FIELD sfd05                                                                                                           
            IF NOT cl_null(g_sfd[l_ac].sfd05) THEN                                                                                  
               IF g_sfd[l_ac].sfd05 < 0 THEN                                                                                        
                  CALL cl_err(g_sfd[l_ac].sfd05,'aec-020',0)                                                                        
                  NEXT FIELD sfd05                                                                                                  
               END IF                                                                                                               
            END IF
            
       AFTER FIELD sfd07 
         IF NOT cl_null(g_sfd[l_ac].sfd07) THEN                                                                      
            LET l_cnt=0  
            SELECT count(*) INTO l_cnt FROM ecm_file                                                                                      
            WHERE ecm01=g_sfd[l_ac].sfd03
              AND ecm012=g_sfd[l_ac].sfd07 
            IF l_cnt=0 THEN
               CALL cl_err('','abm-214',1)
               NEXT FIELD sfd07
            END IF
         END IF
        #FUN-A80054--end--add------------------------
 
        BEFORE DELETE                            #是否取消單身
            IF g_sfd_t.sfd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM sfd_file
                 WHERE sfd01 = g_sfd01 AND sfd02 = g_sfd_t.sfd02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sfd_t.sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
                   CALL cl_err3("del","sfd_file",g_sfd01,g_sfd_t.sfd02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                UPDATE sfb_file SET sfb85='' WHERE sfb01=g_sfd_t.sfd03    #FUN-A80054
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
#NO.FUN-6B0031--BEGIN    
      ON ACTION controls
            CALL cl_set_head_visible("","AUTO")  
#NO.FUN-6B0031--END            
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sfd[l_ac].* = g_sfd_t.*
               CLOSE i411_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfd[l_ac].sfd02,-263,1)
               LET g_sfd[l_ac].* = g_sfd_t.*
            ELSE
               SELECT sfb39,sfb04 INTO l_sfb39,l_sfb04 FROM sfb_file
                WHERE g_sfd[l_ac].sfd03 = sfb01
               IF l_sfb39 = "1" THEN    #在發料狀態下
                  IF l_sfb04 NOT MATCHES '[1]' THEN   #FUN-A80054
                     CALL cl_err('','asf-412',0)
                     LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02
                     LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                     NEXT FIELD sfd02
                  ELSE
                     DECLARE sfa_cur CURSOR FOR SELECT sfa06
                        FROM sfa_file WHERE sfa01 = g_sfd[l_ac].sfd03
                         AND sfaacti IN ('Y','y')
                     LET l_pt = "N"
                     FOREACH sfa_cur INTO l_sfa06
                        IF l_sfa06 IS NOT NULL AND l_sfa06 > 0 THEN
                           LET l_pt = "Y"
                           EXIT FOREACH
                        END IF
                        IF l_sfa06 IS NULL OR l_sfa06 = 0 THEN
                           CONTINUE FOREACH
                        END IF
                     END FOREACH
                     IF l_pt = "Y" THEN
                        CALL cl_err('','asf-413',0)
                        LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02
                        LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                        NEXT FIELD sfd03
                     END IF
                  END IF
               END IF
               IF l_sfb39 = "2" THEN      #在領料狀態下
                  IF l_sfb04 NOT MATCHES '[1]' THEN  #FUN-A80054
                     CALL cl_err('','asf-414',0)
                     LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02
                     LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                     NEXT FIELD sfd03
                  ELSE
                     DECLARE sfa_cur1 CURSOR FOR
                        SELECT sfa061 FROM sfa_file
                         WHERE sfa01 = g_sfd[l_ac].sfd03
                           AND sfaacti IN ('Y','y')
                     LET l_pt = "N"
                     FOREACH sfa_cur1 INTO l_sfa061
                       IF l_sfa061 IS NOT NULL AND l_sfa061 > 0 THEN
                          LET l_pt = "Y"
                          EXIT FOREACH
                       END IF
                       IF l_sfa061 IS NULL OR l_sfa061 = 0 THEN
                          CONTINUE FOREACH
                       END IF
                     END FOREACH
                     IF l_pt = "Y" THEN
                        CALL cl_err('','asf-415',0)
                        LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02
                        LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                        NEXT FIELD sfd03
                     END IF
                  END IF
               END IF
 
#暫時不要殺,測試無誤再砍,以便修改用 92/10/21
              IF ( g_sfd[l_ac].sfd03 != g_sfd_t.sfd03) AND g_del_pt = "Y" THEN 
                   IF NOT s_delsfd(0,0,'1') THEN 
                      LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02  #FUN-A80054
                      LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03  #FUN-A80054
                      
                      ROLLBACK WORK  #FUN-A80054
                   END IF #FUN-A80054
              END IF  #FUN-A80054

              LET g_sfd[l_ac].sfdmodu = g_user  #FUN-D10127 
              UPDATE sfd_file SET sfd02=g_sfd[l_ac].sfd02,
                                  sfd03=g_sfd[l_ac].sfd03,
                                  sfd04=g_sfd[l_ac].sfd04,  #FUN-A80054
                                  sfd05=g_sfd[l_ac].sfd05,  #FUN-A80054
                                  sfd06=g_sfd[l_ac].sfd06,  #FUN-A80054
                                  sfd07=g_sfd[l_ac].sfd07,   #FUN-A80054
                                  sfdmodu=g_sfd[l_ac].sfdmodu #FUN-D10127
                                  
               WHERE sfd01= g_sfd01
                 AND sfd02 = g_sfd_t.sfd02
                 AND sfd03=g_sfd_t.sfd03

               
                   
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
#                 CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("upd","sfd_file",g_sfd01,g_sfd_t.sfd02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  LET g_sfd[l_ac].* = g_sfd_t.*
                  ROLLBACK WORK    #FUN-A80054
               END IF
 
              IF ( g_sfd[l_ac].sfd03 != g_sfd_t.sfd03) AND g_del_pt = "Y" THEN 
                 UPDATE sfb_file SET(sfb85) = (' ')
                  WHERE sfb01 = g_sfd_t.sfd03
 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
#                   CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
                    CALL cl_err3("upd","sfb_file",g_sfd_t.sfd03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
                    LET g_sfd[l_ac].* = g_sfd_t.*
                    ROLLBACK WORK    #FUN-A80054
                 END IF
 
                 UPDATE sfb_file set(sfb85) = (g_sfd01)
                        WHERE sfb01 = g_sfd[l_ac].sfd03  
          
 
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
#                   CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
                    CALL cl_err3("upd","sfb_file",g_sfd[l_ac].sfd03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
                    LET g_sfd[l_ac].* = g_sfd_t.*
                    ROLLBACK WORK
                 ELSE
                    SELECT sfb05,sfb40,sfb13,sfb15,sfb04
                           INTO g_sfd[l_ac].sfb05,
                           g_sfd[l_ac].sfb40,g_sfd[l_ac].sfb13,
                           g_sfd[l_ac].sfb15,g_sfd[l_ac].sfb04  #FUN-A80054  
                      FROM sfb_file
                     WHERE g_sfd[l_ac].sfd03 = sfb01
                 END IF
              END IF    #FUN-A80054  
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
                 # ELSE                                       #FUN-A80054   
                 #     LET g_sfd[l_ac].sfd02 = g_sfd_t.sfd02  #FUN-A80054
                 #     LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03  #FUN-A80054
                 # END IF                                     #FUN-A80054 
              #END IF  #FUN-A80054
            END IF 
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sfd[l_ac].* = g_sfd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sfd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i411_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i411_bcl
            COMMIT WORK
            
        #FUN-A80054--begin--add-----------------------    
        AFTER INPUT                                                                                                                 
            IF INT_FLAG THEN                                                                                                        
                CALL cl_err('',9001,0)                                                                                              
                LET INT_FLAG = 0                                                                                                    
                ROLLBACK WORK                                                                                                       
                CLOSE i411_bcl                                                                                                      
                EXIT INPUT                                                                                                          
            END IF                                                                                                                  
            SELECT SUM(sfd05) INTO l_sfd05 FROM sfd_file                                                                            
             WHERE sfd01=g_sfd01                                                                                                
            UPDATE sfd_file SET sfd06=l_sfd05                                                                                       
             WHERE sfd01=g_sfd01                                                                                                
            FOR i=1 TO g_rec_b                                                                                                      
                LET g_sfd[i].sfd06=l_sfd05                                                                                          
            END FOR
        #FUN-A80054--end--add--------------------------
 
        ON ACTION controlp
          CASE
            WHEN INFIELD(sfd03)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form      = "q_sfb01"  #FUN-A80054
                 LET g_qryparam.form      = "q_sfb10"  #FUN-A80054
                 LET g_qryparam.default1  = rtn_sfd03
                 IF g_sfd09='2' THEN   #MOD-CB0170 add
                    LET g_qryparam.arg1  = '1'  #FUN-A80054
                #MOD-CB0170 add---S
                 ELSE
                    LET g_qryparam.arg1  = '2'
                 END IF
                #MOD-CB0170 add---E
                 CALL cl_create_qry() RETURNING rtn_sfd03
                 IF rtn_sfd03 IS NOT NULL THEN
                    LET g_sfd[l_ac].sfd03 = rtn_sfd03
                 ELSE
                    LET g_sfd[l_ac].sfd03 = g_sfd_t.sfd03
                 END IF
                 DISPLAY BY NAME g_sfd[l_ac].sfd03     #No.MOD-490371
                 NEXT FIELD sfd03
            #FUN-A80054--begin--add---------------------
            WHEN INFIELD(sfd07)
                 CALL cl_init_qry_var()
               # LET g_qryparam.form = "q_ecm_1"                   #FUN-B10056 mark
                 LET g_qryparam.form = "q_ecb012_1"                #FUN-B10056  
               # LET g_qryparam.arg1 = g_sfd[l_ac].sfd03           #FUN-B10056 mark
               # LET g_qryparam.arg2 = g_sfd[l_ac].sfb05           #FUN-B10056 mark
                 LET g_qryparam.arg1 = g_sfd[l_ac].sfd03           #FUN-B10056
                 LET g_qryparam.default1  = g_sfd[l_ac].sfd07
                 CALL cl_create_qry() RETURNING g_sfd[l_ac].sfd07
                 DISPLAY BY NAME g_sfd[l_ac].sfd07    
                 NEXT FIELD sfd07
            #FUN-A80054--end--add-----------------------
          END CASE
 
        ON ACTION mntn_wo
               SELECT sfb02,sfb04 into l_sfb02,l_sfb04 from sfb_file
                       where sfb01 = g_sfd[l_ac].sfd03
                  LET l_cmd="asfi301"," '",g_sfd[l_ac].sfd03,"'"
               CALL cl_cmdrun(l_cmd)
 
#       ON ACTION CONTROLN
#          CALL i411_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sfd02) AND l_ac > 1 THEN
              LET g_sfd[l_ac].* = g_sfd[l_ac-1].*
              DISPLAY g_sfd[l_ac].* TO s_sfd[l_ac].*
              NEXT FIELD sfd02
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
 
    END INPUT
 
    #FUN-5B0113-begin
     UPDATE sfc_file SET sfcmodu = g_user,sfcdate = g_today
      WHERE sfc01 = g_sfd01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd sfc',SQLCA.SQLCODE,1)   #No.FUN-660128
        CALL cl_err3("upd","sfc_file",g_sfd01_t,"",SQLCA.sqlcode,"","upd sfc",1)  #No.FUN-660128
     END IF
    #FUN-5B0113-end
 
 
    CLOSE i411_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION delsfd()
 
    DELETE FROM sfd_file WHERE sfd03 = g_sfd[l_ac].sfd03
    UPDATE sfb_file SET(sfb85) = (g_sfd01)
     WHERE sfb01 = g_sfd[l_ac].sfd03
    IF cl_null(g_sfd[l_ac].sfd07) THEN LET g_sfd[l_ac].sfd07=' ' END IF  #FUN-A80054
    INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfd04,sfd05,sfd06,sfd07,sfd08,sfdconf,sfd09,sfduser,sfdgrup,sfdmodu,sfddate,sfdacti,sfdoriu,sfdorig)  #FUN-A80054 #CHI-C60023   #FUN-D10127 add sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig  
                  VALUES(g_sfd01,g_sfd[l_ac].sfd02,g_sfd[l_ac].sfd03,
                         g_sfd[l_ac].sfd04,g_sfd[l_ac].sfd05,g_sfd[l_ac].sfd06,    #FUN-A80054
                         g_sfd[l_ac].sfd07,g_sfd08,g_sfdconf,g_sfd09              #FUN-A80054 #CHI-C60023    
                         ,g_sfd[l_ac].sfduser,g_sfd[l_ac].sfdgrup,g_sfd[l_ac].sfdmodu,g_sfd[l_ac].sfddate,'Y',g_sfd[l_ac].sfdoriu,g_sfd[l_ac].sfdorig)                      #FUN-D10127
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
        CALL cl_err3("ins","sfd_file",g_sfd01,g_sfd[l_ac].sfd02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
        LET g_sfd[l_ac].* = g_sfd_t.*
    ELSE
        SELECT sfb05,sfb40,sfb13,sfb15,sfb04 INTO  #FUN-A80054  
               g_sfd[l_ac].sfb05,g_sfd[l_ac].sfb40,
               g_sfd[l_ac].sfb13,g_sfd[l_ac].sfb15,
               g_sfd[l_ac].sfb04                   #FUN-A80054 
          FROM sfb_file                    
         WHERE sfb01 = g_sfd[l_ac].sfd03
        MESSAGE 'INSERT O.K'
        COMMIT WORK
        LET g_rec_b=g_rec_b+1
        DISPLAY g_rec_b TO FORMONLY.cn2
    END IF
END FUNCTION
 
FUNCTION delsfd1()
 
    DELETE FROM sfd_file WHERE sfd03 = g_sfd[l_ac].sfd03
    UPDATE sfb_file SET(sfb85) = (g_sfd01)
               WHERE sfb01 = g_sfd[l_ac].sfd03
 
    DELETE FROM sfd_file WHERE sfd03 = g_sfd_t.sfd03
    UPDATE sfb_file SET(sfb85) = (' ')
               WHERE sfb01 = g_sfd_t.sfd03
    IF cl_null(g_sfd[l_ac].sfd07) THEN LET g_sfd[l_ac].sfd07=' ' END IF  #FUN-A80054
    INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfd04,sfd05,sfd06,sfd07,sfd08,sfdconf,sdf09,sfduser,sfdgrup,sfdmodu,sfddate,sfdacti,sfdoriu,sfdorig) #FUN-A80054 #CHI-C60023   #FUN-D10127 add sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig  

    VALUES(g_sfd01,
           g_sfd[l_ac].sfd02,g_sfd[l_ac].sfd03,
           g_sfd[l_ac].sfd04,g_sfd[l_ac].sfd05,g_sfd[l_ac].sfd06,    #FUN-A80054
           g_sfd[l_ac].sfd07,g_sfd08,g_sfdconf,g_sfd09                      #FUN-A80054 #CHI-C60023
           ,g_sfd[l_ac].sfduser,g_sfd[l_ac].sfdgrup,g_sfd[l_ac].sfdmodu,g_sfd[l_ac].sfddate,'Y',g_sfd[l_ac].sfdoriu,g_sfd[l_ac].sfdorig)               #FUN-D10127                         
           
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
        CALL cl_err3("ins","sfd_file",g_sfd01,g_sfd[l_ac].sfd02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
        LET g_sfd[l_ac].* = g_sfd_t.*
    ELSE
        SELECT sfb05,sfb40,sfb13,sfb15,sfb04 INTO   #FUN-A80054 
        g_sfd[l_ac].sfb05,g_sfd[l_ac].sfb40,
        g_sfd[l_ac].sfb13,g_sfd[l_ac].sfb15,g_sfd[l_ac].sfb04  #FUN-A80054 
          FROM sfb_file                 
         WHERE sfb01 = g_sfd[l_ac].sfd03
       #MESSAGE 'INSERT O.K'              #FUN-A80054
       #COMMIT WORK                       #FUN-A80054
       #LET g_rec_b=g_rec_b+1             #FUN-A80054
       #DISPLAY g_rec_b TO FORMONLY.cn2   #FUN-A80054
    END IF
 
END FUNCTION
 
FUNCTION delsfd2()
    DELETE FROM sfd_file WHERE sfd03 = g_sfd_t.sfd03
    UPDATE sfb_file SET(sfb85) = (g_sfd01)
               WHERE sfb01 = g_sfd[l_ac].sfd03
    IF cl_null(g_sfd[l_ac].sfd07) THEN LET g_sfd[l_ac].sfd07=' ' END IF  #FUN-A80054
    INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfd04,sfd05,sfd06,sfd07,sfd08,sfdconf,sfd09,sfduser,sfdgrup,sfdmodu,sfddate,sfdacti,sfdoriu,sfdorig)  #FUN-A80054 #CHI-C60023   #FUN-D10127 add sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig     
    VALUES(g_sfd01,g_sfd[l_ac].sfd02,g_sfd[l_ac].sfd03,
           g_sfd[l_ac].sfd04,g_sfd[l_ac].sfd05,g_sfd[l_ac].sfd06,    #FUN-A80054
           g_sfd[l_ac].sfd07,g_sfd08,g_sfdconf,g_sfd09                      #FUN-A80054 #CHI-C60023
           ,g_sfd[l_ac].sfduser,g_sfd[l_ac].sfdgrup,g_sfd[l_ac].sfdmodu,g_sfd[l_ac].sfddate,'Y',g_sfd[l_ac].sfdoriu,g_sfd[l_ac].sfdorig)                                       #FUN-D10127
         
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sfd[l_ac].sfd02,SQLCA.sqlcode,0)   #No.FUN-660128
        CALL cl_err3("ins","sfd_file",g_sfd01,g_sfd[l_ac].sfd02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
        LET g_sfd[l_ac].* = g_sfd_t.*
    ELSE
        SELECT sfb05,sfb40,sfb13,sfb15,sfb04 INTO  #FUN-A80054   
        g_sfd[l_ac].sfb05,g_sfd[l_ac].sfb40,
        g_sfd[l_ac].sfb13,g_sfd[l_ac].sfb15,g_sfd[l_ac].sfb04  #FUN-A80054 
          FROM sfb_file                           
         WHERE sfb01 = g_sfd[l_ac].sfd03
        MESSAGE 'INSERT O.K'
        COMMIT WORK
        LET g_rec_b=g_rec_b+1
        DISPLAY g_rec_b TO FORMONLY.cn2
    END IF
END FUNCTION
 
FUNCTION i411_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc ON sfd02,sfd03,sfd04,sfd05,sfd06,sfd07,sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig    #螢幕上取條件  #FUN-A80054 #FUN-D10127  add sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig     
       FROM s_sfd[1].sfd02,s_sfd[1].sfd03,s_sfd[1].sfd04, #FUN-A80054
            s_sfd[1].sfd05,s_sfd[1].sfd06,s_sfd[1].sfd07  #FUN-A80054
            ,s_sfd[1].sfduser,s_sfd[1].sfdgrup,s_sfd[1].sfdmodu,s_sfd[1].sfddate,s_sfd[1].sfdoriu,s_sfd[1].sfdorig     #FUN-D10127       
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
    IF INT_FLAG THEN RETURN END IF
    CALL i411_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i411_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    #TQC-B60137-add-str--
    IF cl_null(p_wc) THEN
        LET p_wc= '1=1'
    END IF
    #TQC-B60137-add-end--
    LET g_sql =
       "SELECT sfd02,sfd03,sfb05,'','',sfb04,sfd04,sfd05,sfd06,sfd07,sfb40,sfb13,sfb15,sfduser,sfdgrup,sfdmodu,sfddate,sfdoriu,sfdorig,''",  #FUN-A80054   #FUN-D10127
       " FROM sfd_file LEFT OUTER JOIN sfb_file ON sfb01 = sfd03 ",
       " WHERE sfd01 = '",g_sfd01,"'",
       " AND ",p_wc CLIPPED ,
       " ORDER BY 1"
 
    PREPARE i411_prepare2 FROM g_sql      #預備一下
    DECLARE sfd_cs CURSOR FOR i411_prepare2
 
    CALL g_sfd.clear()
 
    LET g_cnt = 1
 
    FOREACH sfd_cs INTO g_sfd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021
          INTO g_sfd[g_cnt].ima02,g_sfd[g_cnt].ima021
          FROM ima_file
         WHERE ima01 = g_sfd[g_cnt].sfb05
 
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sfd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfd TO s_sfd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END             
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      #FUN-A80054--begin--add------------------           
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
        
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
            
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
       
      ON ACTION PBI_Form
         LET g_action_choice="PBI_Form"
         EXIT DISPLAY
         
      ON ACTION WO_Detail
         LET g_action_choice="WO_Detail"
         EXIT DISPLAY
#FUN-A80054--end--add-------------------------
      ON ACTION sel_report                #FUN-A80060
         LET g_action_choice="sel_report" #FUN-A80060
         EXIT DISPLAY                     #FUN-A80060
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
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-A80054--begin--add------------------
FUNCTION i411_sfd03()
DEFINE l_sfb05    LIKE sfb_file.sfb05
DEFINE l_sfb06    LIKE sfb_file.sfb06

 SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file WHERE sfb01=g_sfd[l_ac].sfd03
 DECLARE edb_cus CURSOR FOR
   SELECT edb02,edb05,edb07 FROM edb_file WHERE edb01=g_sfd08 AND edb03=l_sfb05 AND edb04=l_sfb06
 FOREACH edb_cus INTO g_sfd[l_ac].sfd04,g_sfd[l_ac].sfd05,g_sfd[l_ac].sfd07
    EXIT FOREACH
 END FOREACH
  
END FUNCTION

FUNCTION i411_confirm()
DEFINE l_msg        STRING
DEFINE l_sfb01    	LIKE sfb_file.sfb01
DEFINE l_cnt        LIKE type_file.num5     #TQC-B30091
DEFINE l_cnt1       LIKE type_file.num5     #FUN-D70031

   #IF cl_null(g_sfd01) IS NULL THEN  #MOD-D60217 mark  
    IF cl_null(g_sfd01) THEN          #MOD-D60217 add 
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
#CHI-C30107 ---------------- add ---------------- begin
    IF g_sfdconf="Y" THEN    
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sfdconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF    
    IF NOT cl_confirm('aap-222') THEN RETURN END IF
    SELECT g_sfdconf INTO g_sfdconf FROM sfd_file WHERE sfd01 = g_sfd01
#CHI-C30107 ---------------- add ---------------- end
    IF g_sfdconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    
    IF g_sfdconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF                                                                                                                          
    #TQC-B50079 add
    SELECT COUNT(*) INTO l_cnt FROM sfb_file,sfd_file
     WHERE sfd03=sfb01
       AND (sfb87='X' OR sfb43='9')
       AND sfd01 = g_sfd01
    IF l_cnt > 0 THEN
       CALL cl_err('','asf-947',0)
       RETURN
    END IF
    #TQC-B50079 add-end
#   IF cl_confirm('aap-222') THEN  #CHI-C30107 mark                                                                                             
       BEGIN WORK   
#若工單需要合拼，則處理邏輯如下：
#  依照PBI單身的模數(sfd05)比例，檢查此PBI單的所有工單生產數量比例是否符合，若不符合的話修正,
#  如有異動生產數量的工單，需重新產生備料及製程追蹤或Runcard製程追蹤,
#  需依據合拼版的資料更新備料和製程追蹤的資料，
#  並將所有合拼的工單及PBI資料做確認
       LET g_success='Y'
       IF g_sfd09 = '2' THEN   #CHI-C60023
          #TQC-B30091--begin
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=g_sfd01 AND (sfd07 IS NOT NULL AND sfd07 <> ' ') 
          SELECT COUNT(*) INTO l_cnt1 FROM sfd_file WHERE sfd01=g_sfd01   #FUN-D70031
         #IF l_cnt>0 THEN
          IF l_cnt1>0 THEN    #FUN-D70031
          #TQC-B30091--end 
             CALL i301sub_sfb85(g_sfd01)
             IF g_success='Y' AND l_cnt > 0 THEN    #FUN-D70031 add l_cnt 判斷
                CALL i301sub_selsfd(g_sfd01)
             END IF
             IF g_success='Y' THEN
                DECLARE firm_cs CURSOR FOR
                SELECT DISTINCT sfd03 FROM sfd_file WHERE sfd01=g_sfd01 AND sfdconf='N'
                LET g_b_confirm='Y'
                FOREACH firm_cs INTO l_sfb01
                   CALL i301sub_firm1_chk(l_sfb01,TRUE)
                   IF g_success='N' THEN EXIT FOREACH END IF #FUN-A80060
                   IF g_success='Y' THEN
                      CALL i301sub_firm1_upd(l_sfb01,g_action_choice,TRUE)
                      IF g_success='N' THEN EXIT FOREACH END IF #FUN-A80060
                   END IF
                END FOREACH
                LET g_b_confirm='N'
             END IF
          END IF  #TQC-B30091
       END IF  #CHI-C60023
        
       IF g_success = 'Y' THEN 
          UPDATE sfd_file SET sfdconf = 'Y' WHERE sfd01=g_sfd01 
          IF SQLCA.sqlcode THEN                                                                                                       
             CALL cl_err3("upd","sfd_file",g_sfd01,'',SQLCA.sqlcode,"","sfdconf",1)                                            
             ROLLBACK WORK
          ELSE
             COMMIT WORK 
             LET g_sfdconf="Y"                                                                                                 
             DISPLAY g_sfdconf TO FORMONLY.sfdconf
          END IF
       ELSE
          ROLLBACK WORK
       END IF
#   END IF #CHI-C30107 mark
END FUNCTION

FUNCTION i411_z()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_sfb01  LIKE sfb_file.sfb01

    IF cl_null(g_sfd01) THEN                                                                                                      
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF
    IF g_sfdconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_sfdconf="N" THEN                                                                                  
        CALL cl_err("",'atm-365',1)                                                                                                 
        RETURN
    END IF
    LET l_cnt=0
    SELECT count(*) INTO l_cnt FROM sfd_file,sfb_file
     WHERE sfd01=g_sfd01
       AND sfd03=sfb01
       AND sfb04>='4'
    IF l_cnt > 0 THEN
       CALL cl_err('','asf-528',1)
       RETURN
    END IF
    LET l_cnt=0
    SELECT count(*) INTO l_cnt FROM sfd_file,shb_file
     WHERE sfd01=g_sfd01
       AND sfd03=shb05
       AND shbconf = 'Y' #FUN-A70095
    IF l_cnt > 0 THEN
       CALL cl_err('','asf-164',1)
       RETURN
    END IF
    IF cl_confirm('aap-224') THEN                                                                                                
       BEGIN WORK  
       LET g_success='Y'
       IF g_sfd09 = '2' THEN   #CHI-C60023
          #TQC-B60138(S)
          LET l_cnt=0
         #SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=g_sfd01 AND (sfd07 IS NOT NULL AND sfd07 <> ' ') #FUN-D70031 mark  
          SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=g_sfd01   #FUN-D70031
          IF l_cnt>0 THEN
          #TQC-B60138(E)
             DECLARE firm_cs1 CURSOR FOR 
              SELECT DISTINCT sfd03 FROM sfd_file WHERE sfd01=g_sfd01
             FOREACH firm_cs1 INTO l_sfb01
                CALL i301sub_firm2(l_sfb01,TRUE,'N')
                IF g_success = 'N' THEN EXIT FOREACH END IF
             END FOREACH
          END IF   #TQC-B60138
       END IF  #CHI-C60023
       IF g_success = 'Y' THEN
          UPDATE sfd_file SET sfdconf='N' WHERE sfd01=g_sfd01
          IF SQLCA.sqlcode THEN                                                                                                         
             CALL cl_err3("upd","sfd_file",g_sfd01,'',SQLCA.sqlcode,"","sfdconf",1)                                               
             ROLLBACK WORK
          ELSE
             COMMIT WORK
             LET g_sfdconf="N"                                                                                                    
             DISPLAY g_sfdconf TO FORMONLY.sfdconf
          END IF
       ELSE
         ROLLBACK WORK
       END IF
    END IF                                                                                                       
END FUNCTION

#FUNCTION i411_x()     #CHI-D20010
FUNCTION i411_x(p_type)  #CHI-D20010
DEFINE l_sfb01   LIKE sfb_file.sfb01
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
DEFINE l_cnt     LIKE type_file.num5       #CHI-C60001 add
DEFINE l_sfb85   LIKE sfb_file.sfb85       #CHI-C60001 add
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_sfd01) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
    IF g_sfdconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    

    #CHI-D20010---begin
    IF p_type = 1 THEN
       IF g_sfdconf ='X' THEN RETURN END IF
    ELSE
       IF g_sfdconf <>'X' THEN RETURN END IF
    END IF
    #CHI-D20010---end

    IF g_sfdconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010

     #IF cl_void(0,0,g_sfdconf)   THEN  #CHI-D20010
      IF cl_void(0,0,l_flag)   THEN   #CHI-D20010
         BEGIN WORK
         LET g_success='Y'
         IF g_sfd09 = '2' THEN   #CHI-C60023
            DECLARE firm_cs2 CURSOR FOR 
             SELECT DISTINCT sfd03 FROM sfd_file WHERE sfd01=g_sfd01
           #CHI-C60001 str add-----
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfd_file 
             WHERE sfd01!=g_sfd01 
               AND sfd03 =(SELECT sfd03 FROM sfd_file WHERE sfd01=g_sfd01) 
               AND sfdconf !='X'
            IF l_cnt >0 AND g_sfdconf ='X' THEN 
               LET g_success = 'N' 
               CALL cl_err("",'asf-277',1)
            END IF
            IF g_sfdconf = 'X' THEN
               LET l_sfb85=g_sfd01
            ELSE
               LET l_sfb85=NULL
            END IF 
           #CHI-C60001 end add-----
            FOREACH firm_cs2 INTO l_sfb01
              #CALL i301sub_x(l_sfb01,TRUE,'N')          #CHI-D20010
              #CALL i301sub_x(l_sfb01,TRUE,'N',p_type)   #CHI-D20010   #CHI-C60001 mark
               IF g_success = 'N' THEN EXIT FOREACH END IF
               UPDATE sfb_file SET sfb85=l_sfb85 WHERE sfb01=l_sfb01    #CHI-C60001 add
            END FOREACH
         END IF   #CHI-C60023
         IF g_success = 'Y' THEN
            LET g_chr=g_sfdconf
           #IF g_sfdconf ='N' THEN  #CHI-D20010
            IF p_type = 1 THEN      #CHI-D20010
               LET g_sfdconf='X'
            ELSE
               LET g_sfdconf='N'
            END IF
            UPDATE sfd_file
               SET sfdconf=g_sfdconf
             WHERE sfd01  =g_sfd01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","sfd_file",g_sfd01,"",SQLCA.sqlcode,"","",1) 
               LET g_sfdconf=g_chr
               ROLLBACK WORK
            ELSE
               COMMIT WORK
               DISPLAY g_sfdconf TO FORMONLY.sfdconf
            END IF
         ELSE
            ROLLBACK WORK
         END IF
      END IF
END FUNCTION

FUNCTION i411_show_pic()                                                                                                            
DEFINE l_void    LIKE type_file.chr1
DEFINE l_confirm LIKE type_file.chr1

     LET l_void=NULL
     LET l_confirm=NULL
     IF g_sfdconf MATCHES '[Yy]' THEN
           LET l_confirm='Y'
           LET l_void='N'
     ELSE
        IF g_sfdconf ='X' THEN
              LET l_confirm='N'
              LET l_void='Y'
        ELSE
           LET l_confirm='N'
           LET l_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(l_confirm,"","","",l_void,"")                                                                
END FUNCTION 
#FUN-A80054--end--add--------------------
 
#FUN-A90035 -------------------add start-----------
FUNCTION i411_out()
   DEFINE l_wc string

    IF g_sfd01 IS NULL THEN RETURN END IF

    CLOSE WINDOW screen

    CALL cl_set_act_visible("accept,cancel", TRUE)
    MENU "" 

       ON ACTION print_PBI_detail
          CALL i411_out1()

       ON ACTION print_routing_part
               LET l_wc=' sfd01 ="',g_sfd01,'" AND sfd02 = "',g_sfd[l_ac].sfd02,'"'
               LET g_msg = "asfr412",
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
          CALL cl_cmdrun(g_msg)

       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice="exit"
          EXIT MENU

       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about         
         CALL cl_about()      

      ON ACTION help          
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()     



        -- for Windows close event trapped
        ON ACTION close   
             LET INT_FLAG=FALSE               
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CALL cl_set_act_visible("accept,cancel", FALSE)

END FUNCTION
#FUN-A90035 -------------add end--------------------------

#FUNCTION i411_out()  #FUN-A90035 mark
FUNCTION i411_out1()  #FUN-A90035 add
 
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    sr              RECORD                          
#       sfd01       LIKE sfd_file.sfd01,   #料表批號     #FUN-A90035 mark
#       sfd02       LIKE sfd_file.sfd02,   #項次         #FUN-A90035 mark
#       sfc02       LIKE sfc_file.sfc02,   #描述         #FUN-A90035 mark
#       sfd03       LIKE sfd_file.sfd03    #工單編號     #FUN-A90035 mark
        sfd01       LIKE sfd_file.sfd01,   #料表批號    #FUN-A90035
        sfc02       LIKE sfc_file.sfc02,   #描述        #FUN-A90035
        sfd08       LIKE sfd_file.sfd08,   #合併版號    #FUN-A90035
        sfdconf     LIKE sfd_file.sfdconf, #確認        #FUN-A90035
        sfd02       LIKE sfd_file.sfd02,   #項次        #FUN-A90035
        sfd03       LIKE sfd_file.sfd03,   #工單編號    #FUN-A90035
        sfb05       LIKE sfb_file.sfb05,   #料號        #FUN-A90035
        ima02       LIKE ima_file.ima02,   #品名        #FUN-A90035
        ima021      LIKE ima_file.ima021,  #規格        #FUN-A90035 
        sfb04       LIKE sfb_file.sfb04,   #狀態        #FUN-A90035
        sfb40       LIKE sfb_file.sfb40,   #優先順序    #FUN-A90035
        sfd04       LIKE sfd_file.sfd04,   #合併序      #FUN-A90035
        sfd05       LIKE sfd_file.sfd05,   #模數        #FUN-A90035
        sfd06       LIKE sfd_file.sfd06,   #總模數      #FUN-A90035
        sfd07       LIKE sfd_file.sfd07,   #被取代的制程段號  #FUN-A90035
        sfb13       LIKE sfb_file.sfb13,   #預計開工日        #FUN-A90035
        sfb15       LIKE sfb_file.sfb15,   #預計完工日        #FUN-A90035  
        sfd09       LIKE sfd_file.sfd09    #CHI-C60023
                    END RECORD,                   

    l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_za05          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#    LET l_name = 'asfi411.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
#   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'i411_'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   LET g_sql="SELECT sfd01,sfd02,' ',sfd03",        #FUN-A90035 mark
#             " FROM sfd_file ",  # 組合出 SQL 指令  #FUN-A90035 mark
#             " WHERE  ",g_wc CLIPPED,               #FUN-A90035 mark   
#             " ORDER BY 1,2 "                       #FUN-A90035 mark
    LET g_sql="SELECT sfd01,' ',sfd08,sfdconf,sfd02,sfd03,sfb05,'','',sfb04,sfb40,sfd04,sfd05,sfd06,sfd07,sfb13,sfb15,sfd09",   #FUN-A90035 add #CHI-C60023
              "  FROM sfd_file LEFT OUTER JOIN sfb_file ON sfd03 = sfb01 ",                                               #FUN-A90035 add
              " WHERE  ",g_wc CLIPPED,                                               #FUN-A90035 add
              " ORDER BY sfd01,sfd02"                                                #FUN-A90035 add 
    PREPARE i411_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i411_co                         # SCROLL CURSOR
        CURSOR FOR i411_p1
#No.FUN-760085---Begin
#   CALL cl_outnam('asfi411') RETURNING l_name
#   START REPORT i411_rep TO l_name
    CALL cl_del_data(l_table)
#No.FUN-760085---End
 
    FOREACH i411_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF sr.sfd03 = ' ' OR sr.sfd03 IS NULL THEN
            CONTINUE FOREACH
        END IF
#FUN-9A0035 -------------add start-------------------------------        
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.sfb05
        IF SQLCA.sqlcode THEN
           LET sr.ima02  = ' '
           LET sr.ima021 = ' ' 
        END IF     
#FUN-9A0035 ------------add end-------------------------------- 
#       OUTPUT TO REPORT i411_rep(sr.*)        #No.FUN-760085
#       EXECUTE insert_prep USING sr.sfd01,sr.sfc02,sr.sfd02,sr.sfd03   #No.FUN-760085  #FUN-A90035 mark
        EXECUTE insert_prep USING sr.*                                  #FUN-A90035 add            
    END FOREACH
#No.FUN-760085---Begin 
#   FINISH REPORT i411_rep                     
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'sfd01,sfd02,sfd03')
            RETURNING g_str                                                     
    END IF                                                                      
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
#No.FUN-760085---End     
    CLOSE i411_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)               #No.FUN-760085
#FUN-A90035 ---------------add start-----------------------------
    IF g_sma.sma541  = 'Y' THEN
       CALL cl_prt_cs3('asfi411','asfi411',l_sql,g_str)
    ELSE
       CALL cl_prt_cs3('asfi411','asfi411_1',l_sql,g_str)
    END IF
#FUN-A90035 --------------add end----------------------------------
#   CALL cl_prt_cs3('asfi411','asfi411',l_sql,g_str)  #FUN-A90035 mark
END FUNCTION
 
#No.FUN-760085---Begin
{ 
REPORT i411_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sfcacti       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_acti          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sw            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    sr              RECORD
        sfd01       LIKE sfd_file.sfd01,   #料表批號
        sfd02       LIKE sfd_file.sfd02,   #項次
        sfc02       LIKE sfc_file.sfc02,   #描述
        sfd03       LIKE sfd_file.sfd03    #工單編號
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.sfd01,sr.sfd02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            LET l_trailer_sw = 'y'
            PRINT g_dash
            LET l_sw = 'N'
            PRINTX name=H1 g_x[31],g_x[32]
            PRINTX name=H2 g_x[33],g_x[34]
            PRINT g_dash1
 
        BEFORE GROUP OF sr.sfd01
             SELECT sfc02 INTO sr.sfc02 FROM sfc_file
                      WHERE sfc01 = sr.sfd01
                  PRINTX name=D1 COLUMN g_c[31],sr.sfd01 CLIPPED,
                        COLUMN g_c[32],sr.sfc02
        ON EVERY ROW
             PRINTX name=D2 column g_c[33],sr.sfd02 USING "##########",
                   COLUMN g_c[34],sr.sfd03
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
#Patch....NO.MOD-5A0095 <001,002> #
