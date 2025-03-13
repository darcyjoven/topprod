# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: amri500.4gl
# Descriptions...: MPS計劃 維護作業
# Date & Author..: 96/05/25 By Roger
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0042 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510046 05/01/24 By pengu 報表轉XML
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工 
# Modify ........: No.FUN-5B0098 05/11/18 By kim 報表改成100Column以內
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0041 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(amri500)、(接下頁)、(結束)等表尾字樣
# Modify.........: No.MOD-690039 06/12/08 By pengu 不能by 單身CONSTRUCT條件顯示資料
# Modify.........: No.TQC-720056 07/03/01 By Judy 結案后仍可以刪除
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/15 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770005 07/07/02 By wujie page頁簽不可以查詢 
# Modify.........: NO.FUN-6B0045 07/08/08 by Yiting 增加msa05
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-830007 08/03/20 By Pengu 取銷單身自動產生的ACTION功能
# Modify.........: No.FUN-840068 08/04/22 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-880210 08/08/26 By Pengu 當主件料號有資料時列印說明異常
# Modify.........: No.MOD-890105 08/09/18 By Pengu  一人key新增單頭後進單身，另一user再新增時會出現cursor被鎖住
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0109 09/12/17 By sherry 執行"取消結案"，此時的確認碼圖檔應該要為"確"，但目前為空
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40106 10/04/20 By Sarah i500_show(),判斷g_wc2是否為NULL,若是給予預設值" 1=1"
# Modify.........: No:FUN-A80150 10/09/07 By sabrina 單身新增"計劃批號"(msb919)欄位
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-B30006 11/03/02 By destiny 新增時字段oriu沒顯示
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.TQC-B80220 11/08/29 By houlia msaoriu,msaorig 添加查詢功能

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30190 12/03/21 By yangxf 将老报表转换为CR报表
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C50246 12/06/01 By ck2yuan 修改對料是否存在於BOM的控卡
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80110 12/08/17 By qiull 修改報錯信息
# Modify.........: No.CHI-C80041 13/02/06 By bart 無單身刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D30064 13/03/08 By ck2ayun 按F1新增後，再按取消，該空白行會留著。

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_msa   RECORD LIKE msa_file.*,
    g_msa_t RECORD LIKE msa_file.*,
    g_msa_o RECORD LIKE msa_file.*,
    g_msa01_t LIKE msa_file.msa01,
    b_msb   RECORD LIKE msb_file.*,
    g_ima   RECORD LIKE ima_file.*,
     g_wc,g_wc2,g_sql   STRING,                #No.FUN-580092 HCN  
     g_wc3              STRING,                #FUN-C30190 add
    g_msb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        msb02           LIKE msb_file.msb02,
        msb03           LIKE msb_file.msb03,
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        ima55           LIKE ima_file.ima55,
        msb04           LIKE msb_file.msb04,
        msb07           LIKE msb_file.msb07,
        msb05           LIKE msb_file.msb05,
        msb919          LIKE msb_file.msb919,   #FUN-A80150 add
     #  sfb08           INTEGER,
        sfb08           LIKE sfb_file.sfb08, #No.FUN-680082 INTEGER
     #  nopen           INTEGER,
        nopen           LIKE sfb_file.sfb08, #No.FUN-680082 INTEGER
        msb06           LIKE msb_file.msb06,
        msb08           LIKE msb_file.msb08,
        #FUN-840068 --start---
        msbud01         LIKE msb_file.msbud01,
        msbud02         LIKE msb_file.msbud02,
        msbud03         LIKE msb_file.msbud03,
        msbud04         LIKE msb_file.msbud04,
        msbud05         LIKE msb_file.msbud05,
        msbud06         LIKE msb_file.msbud06,
        msbud07         LIKE msb_file.msbud07,
        msbud08         LIKE msb_file.msbud08,
        msbud09         LIKE msb_file.msbud09,
        msbud10         LIKE msb_file.msbud10,
        msbud11         LIKE msb_file.msbud11,
        msbud12         LIKE msb_file.msbud12,
        msbud13         LIKE msb_file.msbud13,
        msbud14         LIKE msb_file.msbud14,
        msbud15         LIKE msb_file.msbud15
        #FUN-840068 --end--
                    END RECORD,
    g_msb_t         RECORD                 #程式變數 (舊值)
        msb02           LIKE msb_file.msb02,
        msb03           LIKE msb_file.msb03,
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        ima55           LIKE ima_file.ima55,
        msb04           LIKE msb_file.msb04,
        msb07           LIKE msb_file.msb07,
        msb05           LIKE msb_file.msb05,
        msb919          LIKE msb_file.msb919,   #FUN-A80150 add
      # sfb08           INTEGER,
      # nopen           INTEGER,
        sfb08           LIKE sfb_file.sfb08, #No.FUN-680082 INTEGER 
        nopen           LIKE sfb_file.sfb08, #No.FUN-680082 INTEGER 
        msb06           LIKE msb_file.msb06,
        msb08           LIKE msb_file.msb08,
        #FUN-840068 --start---
        msbud01         LIKE msb_file.msbud01,
        msbud02         LIKE msb_file.msbud02,
        msbud03         LIKE msb_file.msbud03,
        msbud04         LIKE msb_file.msbud04,
        msbud05         LIKE msb_file.msbud05,
        msbud06         LIKE msb_file.msbud06,
        msbud07         LIKE msb_file.msbud07,
        msbud08         LIKE msb_file.msbud08,
        msbud09         LIKE msb_file.msbud09,
        msbud10         LIKE msb_file.msbud10,
        msbud11         LIKE msb_file.msbud11,
        msbud12         LIKE msb_file.msbud12,
        msbud13         LIKE msb_file.msbud13,
        msbud14         LIKE msb_file.msbud14,
        msbud15         LIKE msb_file.msbud15
        #FUN-840068 --end--
                    END RECORD,
    msb05t,msb08t,sfb08t,nopent LIKE type_file.num10,   #NO.FUN-680082 INTEGER
    g_buf           LIKE type_file.chr1000,  #No.FUN-680082 VARCHAR(78)
  # g_argv1         VARCHAR(16),                     #No.FUN-560060
    g_argv1         LIKE type_file.chr20,     #No.FUN-680082 VARCHAR(16)
  # l_sfb09         INTEGER,
    l_sfb09         LIKE sfb_file.sfb09,     #No.FUN-680082 INTEGER
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-680082 SMALLINT 
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT  #No.FUN-680082 SMALLINT
  # l_sl            SMALLINT                 #目前處理的SCREEN LINE
    l_sl            LIKE type_file.num5      #No.FUN-680082 SMALLINT  
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE g_chr               LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_i                 LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_curs_index        LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_jump              LIKE type_file.num10    #No.FUN-680082 INTEGER 
DEFINE mi_no_ask           LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE g_t1                LIKE oay_file.oayslip  #no.FUN-6B0045
DEFINE g_str               STRING                 #FUN-C30190 add
DEFINE l_table             STRING                 #FUN-C30190 add
DEFINE g_void              LIKE type_file.chr1  #CHI-C80041

MAIN
#   DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0076
    DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AMR")) THEN
       EXIT PROGRAM
    END IF
 
 
    LET g_argv1=ARG_VAL(1)
#FUN-C30190 add begin ---
    LET g_sql = "msa01.msa_file.msa01,",
                "msb02.msb_file.msb02,",
                "msb03.msb_file.msb03,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ima55.ima_file.ima55,",
                "msb04.msb_file.msb04,",
                "msb07.msb_file.msb07,",
                "msb05.msb_file.msb05,",
                "l_sfb08.sfb_file.sfb08"
    LET l_table = cl_prt_temptable('amri500',g_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF
#FUN-C30190 add end ---
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    LET p_row = 1 LET p_col = 2
    OPEN WINDOW i500_w AT p_row,p_col
        WITH FORM "amr/42f/amri500" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible('msb919',g_sma.sma1421='Y')      #FUN-A80150 add
 
 
    CALL i500()
    CLOSE WINDOW i500_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i500()
    INITIALIZE g_msa.* TO NULL
    INITIALIZE g_msa_t.* TO NULL
    INITIALIZE g_msa_o.* TO NULL
    CALL i500_lock_cur()
    CALL i500_menu()
END FUNCTION
 
FUNCTION i500_lock_cur()
 
    LET g_forupd_sql = "SELECT * FROM msa_file WHERE msa01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION i500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_msb.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INITIALIZE g_msa.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
              #msa01, msa02, msa03, msa04,msauser,msadate,msamodu,msamodd      #No.TQC-770005 
              #msa01, msa02, msa03, msa05, msa04, msauser,msadate,msamodu,msamodd      #No.TQC-770005   #NO.FUN-6B0045
             #msa01, msa02, msa08,msa03, msa05, msa04, msauser,msadate,msamodu,msamodd,    #TQC-B80220 mark  #No.TQC-770005   #NO.FUN-6B0045   #NO.FUN-6B0045
              msa01, msa02, msa08,msa03, msa05, msa04, msauser,msadate,msamodu,msamodd,msaoriu,msaorig, #TQC-B80220 add      #No.TQC-770005   #NO.FUN-6B0045   #NO.FUN-6B0045
              #FUN-840068   ---start---
              msaud01,msaud02,msaud03,msaud04,msaud05,
              msaud06,msaud07,msaud08,msaud09,msaud10,
              msaud11,msaud12,msaud13,msaud14,msaud15
              #FUN-840068    ----end----
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
#NO.FUN-6B0045 start----------------
       ON ACTION controlp
          CASE WHEN INFIELD(msa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_msa" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO msa01 
                  NEXT FIELD msa01 
              OTHERWISE EXIT CASE
          END CASE
#NO.FUN-6B0045 end-------------------
 
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('msauser', 'msagrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON msb02,msb03,msb04,msb07,msb05,msb919,msb06,msb08         #FUN-A80150 add msb919
              #No.FUN-840068 --start--
              ,msbud01,msbud02,msbud03,msbud04,msbud05
              ,msbud06,msbud07,msbud08,msbud09,msbud10
              ,msbud11,msbud12,msbud13,msbud14,msbud15
              #No.FUN-840068 ---end---
            FROM s_msb[1].msb02,s_msb[1].msb03,s_msb[1].msb04,
                 s_msb[1].msb07,s_msb[1].msb05,s_msb[1].msb919,s_msb[1].msb06,s_msb[1].msb08    #FUN-A80150 add msb919
                 #No.FUN-840068 --start--
                 ,s_msb[1].msbud01,s_msb[1].msbud02,s_msb[1].msbud03
                 ,s_msb[1].msbud04,s_msb[1].msbud05,s_msb[1].msbud06
                 ,s_msb[1].msbud07,s_msb[1].msbud08,s_msb[1].msbud09
                 ,s_msb[1].msbud10,s_msb[1].msbud11,s_msb[1].msbud12
                 ,s_msb[1].msbud13,s_msb[1].msbud14,s_msb[1].msbud15
                 #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(msb03)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form  = "q_ima"
                 #  LET g_qryparam.state = "c"  
                 #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO msb03
                   NEXT FIELD msb03
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND msauser = '",g_user,"'"
    #    END IF
    
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT msa01 FROM msa_file ",
                      " WHERE ",g_wc CLIPPED, " ORDER BY msa01"
       ELSE LET g_sql="SELECT msa01",
                      "  FROM msa_file,msb_file ",
                      " WHERE msa01=msb01",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY msa01"
    END IF
    PREPARE i500_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i500_cs SCROLL CURSOR WITH HOLD FOR i500_prepare
   #----------No.MOD-690039 modify
   #LET g_sql= "SELECT COUNT(*) FROM msa_file WHERE ",g_wc CLIPPED
    IF g_wc2=' 1=1' THEN
       LET g_sql= "SELECT COUNT(*) FROM msa_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(*) FROM msa_file,msb_file ",
                  "WHERE msa01=msb01 ",
                  " AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF   
   #----------No.MOD-690039 end
    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION
 
FUNCTION i500_menu()
 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i500_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i500_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i500_u()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL i500_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL i500_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i500_out('o')
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msb),'','')
             END IF
         #--
 
         WHEN "close_the_case" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL i500_x()
            END IF
            #圖形顯示
            #CALL cl_set_field_pic("","","",g_msa.msa03,"","")          #TQC-9C0109
            CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,"","")  #TQC-9C0109
#NO.FUN-6B0045 start---
         WHEN "confirm" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL i500_y()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,"","")
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN 
               CALL i500_z()
            END IF
            CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,"","")
#NO.FUN-6B0045 end-----
         #No.FUN-6B0041-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_msa.msa01 IS NOT NULL THEN
                 LET g_doc.column1 = "msa01"
                 LET g_doc.value1 = g_msa.msa01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0041-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i500_v()
               CALL i500_v(1)   #CHI-D20010
               IF g_msa.msa05 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,g_void,"")
            END IF
         #CHI-C80041---end
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i500_v(2)
               IF g_msa.msa05 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
               CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,g_void,"")
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
      CLOSE i500_cs
END FUNCTION
 
FUNCTION i500_a()
DEFINE li_result   LIKE type_file.num5      #NO.FUN-6B0045
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_msb.clear()
    INITIALIZE g_msa.* LIKE msa_file.*
    LET g_msa01_t = NULL
    LET g_msa.msa03   = 'N'
    LET g_msa.msa05   = 'N'      #NO.FUN-6B0045
    LET g_msa.msa08   = g_today  #no.FUN-6B0045
    LET g_msa.msauser = g_user
    LET g_msa.msadate = g_today
    LET g_msa.msaplant = g_plant #FUN-980004 
    LET g_msa.msalegal = g_legal #FUN-980004 
    LET g_msa.msaorig=g_grup     #TQC-B30006
    LET g_msa.msaoriu=g_user     #TQC-B30006
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i500_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_msa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_msb.clear()
            EXIT WHILE
        END IF
        IF g_msa.msa01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7829
        CALL s_auto_assign_no("asf",g_msa.msa01,g_msa.msa08,"K","msa_file","msa01","","","")
             RETURNING li_result,g_msa.msa01
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_msa.msa01
        LET g_msa.msaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_msa.msaorig = g_grup      #No.FUN-980030 10/01/04
        let g_msa.msagrup = g_grup      #darcy:2023/03/28 add
        INSERT INTO msa_file VALUES(g_msa.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0) #No.FUN-660107
            CALL cl_err3("ins","msa_file",g_msa.msa01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
           ROLLBACK WORK      #No.MOD-890105 add
           CONTINUE WHILE
        ELSE
           COMMIT WORK      #No.MOD-890105 add
           LET g_msa_t.* = g_msa.*               # 保存上筆資料
           SELECT msa01 INTO g_msa.msa01 FROM msa_file
                  WHERE msa01 = g_msa.msa01
        END IF
        CALL g_msb.clear()
         LET g_rec_b=0     #MOD-480039
        CALL i500_b('0')
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
   
FUNCTION i500_i(p_cmd)
DEFINE li_result   LIKE type_file.num5      #NO.FUN-6B0045
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入   #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680082 SMALLINT
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    #no.FUN-6B0045 start---
    DISPLAY BY NAME
           g_msa.msa01, g_msa.msa02, g_msa.msa08,g_msa.msa03, g_msa.msa05,g_msa.msa04,  #NO.FUN-6B0045 add msa05    #NO.FUN-6B0045
           g_msa.msauser, g_msa.msadate, g_msa.msamodu, g_msa.msamodd,
           g_msa.msaorig,g_msa.msaoriu #TQC-B30006
    #no.FUN-6B0045 end-----
       
    INPUT BY NAME
           #g_msa.msa01, g_msa.msa02, g_msa.msa03, g_msa.msa04
           g_msa.msa01, g_msa.msa02, g_msa.msa08,g_msa.msa03, g_msa.msa04,   #NO.FUN-6B0045
           #g_msa.msauser, g_msa.msadate, g_msa.msamodu, g_msa.msamodd  #NO.FUN-6B0045
           #FUN-840068     ---start---
           g_msa.msaud01,g_msa.msaud02,g_msa.msaud03,g_msa.msaud04,
           g_msa.msaud05,g_msa.msaud06,g_msa.msaud07,g_msa.msaud08,
           g_msa.msaud09,g_msa.msaud10,g_msa.msaud11,g_msa.msaud12,
           g_msa.msaud13,g_msa.msaud14,g_msa.msaud15 
           #FUN-840068     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i500_set_entry(p_cmd)
            CALL i500_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
       {
        BEFORE FIELD msa01
            IF p_cmd='u' THEN NEXT FIELD msa02 END IF
       }
        AFTER FIELD msa01
#NO.FUN-6B0045 start-----
           #IF p_cmd = "a" THEN   #FUN-B50026 mark
              IF NOT cl_null(g_msa.msa01) THEN
                CALL s_check_no("asf",g_msa.msa01,g_msa01_t,"K","msa_file","msa01","")
                RETURNING li_result,g_msa.msa01
                DISPLAY BY NAME g_msa.msa01
                IF (NOT li_result) THEN
                  NEXT FIELD msa01
                END IF
              END IF
           #END IF   #FUN-B50026 mark
 
#            IF NOT cl_null(g_msa.msa01) THEN
#               IF (g_msa.msa01 != g_msa01_t) OR (g_msa01_t IS NULL) THEN
#                   SELECT count(*) INTO g_cnt FROM msa_file
#                       WHERE msa01 = g_msa.msa01
#                   IF g_cnt > 0 THEN                   # 資料重複
#                       CALL cl_err('count>1:',-239,0)
#                       LET g_msa.msa01 = g_msa01_t
#                       DISPLAY BY NAME g_msa.msa01
#                       NEXT FIELD msa01
#                   END IF
#               END IF
#            END IF
#NO.FUN-6B0045 end------
        AFTER FIELD msa03
            IF g_msa_t.msa04 IS NULL AND
               g_msa_t.msa03 = 'N' AND g_msa.msa03 = 'Y' THEN
               LET g_msa.msa04 = TODAY
               DISPLAY BY NAME g_msa.msa04
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD msaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_msa.msauser = s_get_data_owner("msa_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
        
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msa01) THEN
        #        LET g_msa.* = g_msa_t.*
        #        CALL i500_show()
        #        NEXT FIELD msa01
        #    END IF
        #MOD-650015 --end
 
#NO.FUN-6B0045 start-----------------------
        ON ACTION controlp
            CASE
               WHEN INFIELD(msa01)
                   LET g_t1 = s_get_doc_no(g_msa.msa01) 
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','K') RETURNING g_t1
                   LET g_msa.msa01=g_t1   
                   DISPLAY BY NAME g_msa.msa01
                   NEXT FIELD msa01
           END CASE
#NO.FUN-6B0045 end---------------------------
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
FUNCTION i500_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("msa01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("msa01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msa.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i500_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_msb.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        INITIALIZE g_msa.* TO NULL
    ELSE
        CALL i500_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i500_fetch(p_flmsa)
    DEFINE
      # p_flmsa          VARCHAR(1),
        p_flmsa         LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10     #No.FUN-680082 INTEGER
 
    CASE p_flmsa
        WHEN 'N' FETCH NEXT     i500_cs INTO g_msa.msa01
        WHEN 'P' FETCH PREVIOUS i500_cs INTO g_msa.msa01
        WHEN 'F' FETCH FIRST    i500_cs INTO g_msa.msa01
        WHEN 'L' FETCH LAST     i500_cs INTO g_msa.msa01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i500_cs INTO g_msa.msa01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        INITIALIZE g_msa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_msa.* FROM msa_file       # 重讀DB,因TEMP有不被更新特性
       WHERE msa01 = g_msa.msa01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("sel","msa_file",g_msa.msa01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE                                      #FUN-4C0042權限控管
        LET g_data_owner=g_msa.msauser
       # LET g_data_group=g_msa.msagrup
        CALL i500_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i500_show()
    LET g_msa_t.* = g_msa.*
    DISPLAY BY NAME
           g_msa.msa01, g_msa.msa02, g_msa.msa08,g_msa.msa03, g_msa.msa05,g_msa.msa04,  #NO.FUN-6B0045 add msa05    #NO.FUN-6B0045
           #g_msa.msa01, g_msa.msa02, g_msa.msa03, g_msa.msa05,g_msa.msa04,  #NO.FUN-6B0045 add msa05
           g_msa.msauser, g_msa.msadate, g_msa.msamodu, g_msa.msamodd,
           g_msa.msaorig,g_msa.msaoriu,  #TQC-B30006
           #FUN-840068     ---start---
           g_msa.msaud01,g_msa.msaud02,g_msa.msaud03,g_msa.msaud04,
           g_msa.msaud05,g_msa.msaud06,g_msa.msaud07,g_msa.msaud08,
           g_msa.msaud09,g_msa.msaud10,g_msa.msaud11,g_msa.msaud12,
           g_msa.msaud13,g_msa.msaud14,g_msa.msaud15 
           #FUN-840068     ----end----
 
    #CALL cl_set_field_pic("","","",g_msa.msa03,"","")
    #CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,"","")  #NO.FUN-6B0045 #CHI-C80041
    IF g_msa.msa05 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,g_void,"")  #CHI-C80041
   #--------No.MOD-690039 modify
    IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF   #MOD-A40106 add
   #CALL i500_b_fill(' 1=1')
    CALL i500_b_fill(g_wc2)
   #--------No.MOD-690039 end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i500_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_msa.msa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #-->已結案不可修改
    IF g_msa.msa03 = 'Y' THEN CALL cl_err('','amr-100',0) RETURN END IF
    IF g_msa.msa05 = 'Y' THEN CALL cl_err('','aap-005',0) RETURN END IF   #NO.FUN-6B0045
    IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i500_cl USING g_msa.msa01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_msa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE i500_cl
        RETURN
    END IF
    LET g_msa01_t = g_msa.msa01
    LET g_msa_o.*=g_msa.*
    LET g_msa.msamodu = g_user
    LET g_msa.msamodd = g_today                  #修改日期
    CALL i500_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_msa.*=g_msa_t.*
            CALL i500_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msa_file SET msa_file.* = g_msa.*    # 更新DB
            WHERE msa01 = g_msa.msa01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msa_file",g_msa01_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_r()
    DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
           l_cnt   LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_msa.msa01) THEN CALL cl_err('',-400,0) RETURN END IF
#TQC-720056.....begin
    IF g_msa.msa03 = 'Y' THEN
       CALL cl_err('','amr-918',0)
       RETURN
    END IF
#TQC-720056.....end
#no.FUN-6B0045 start----
    IF g_msa.msa05 = 'Y' THEN
      #CALL cl_err('','anm-015',0)         #TQC-C80110
       CALL cl_err('','alm-028',0)         #TQC-C80110
       RETURN
    END IF
    IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041
#no.FUN-6B0045 end------
    BEGIN WORK
 
    OPEN i500_cl USING g_msa.msa01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_msa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE i500_cl
        RETURN
    END IF
    CALL i500_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msa.msa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM msa_file WHERE msa01=g_msa.msa01
        IF STATUS THEN 
#        CALL cl_err('del msa:',STATUS,0)  #No.FUN-660107
         CALL cl_err3("del","msa_file",g_msa.msa01,"",STATUS,"","del msa:",1)       #NO.FUN-660107
        RETURN END IF
        DELETE FROM msb_file WHERE msb01 = g_msa.msa01
        IF STATUS THEN 
#        CALL cl_err('del msb:',STATUS,0) #No.FUN-660107
         CALL cl_err3("del","msb_file",g_msa.msa01,"",STATUS,"","del msb:",1)       #NO.FUN-660107
        RETURN END IF
        INITIALIZE g_msa.* TO NULL
        CLEAR FORM
        CALL g_msb.clear()
        OPEN i500_count
        #FUN-B50063-add-start--
        IF STATUS THEN
           CLOSE i500_cs
           CLOSE i500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50063-add-end-- 
        FETCH i500_count INTO g_row_count
        #FUN-B50063-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i500_cs
           CLOSE i500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50063-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i500_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i500_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i500_fetch('/')
        END IF
    END IF
    CLOSE i500_cl
    COMMIT WORK
END FUNCTION
   
FUNCTION i500_x()
   IF s_shut(0) THEN RETURN END IF
 
   IF g_msa.msa05='N'      THEN
      CALL cl_err('','9026',0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i500_cl USING g_msa.msa01
   IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i500_cl INTO g_msa.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i500_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_msa.msa01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_close(0,0,g_msa.msa03)   THEN
        LET g_chr=g_msa.msa03  
        IF g_msa.msa03 ='N' THEN
            LET g_msa.msa03='Y'
            LET g_msa.msa04=g_today
        ELSE
            LET g_msa.msa03='N'
            LET g_msa.msa04=null
        END IF
        UPDATE msa_file                
            SET msa03=g_msa.msa03,
                msa04=g_msa.msa04,
                msamodu=g_user,
                msamodd=g_today
            WHERE msa01  =g_msa.msa01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msa_file",g_msa.msa01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            LET g_msa.msa03=g_chr
        END IF
        DISPLAY BY NAME g_msa.msa03,g_msa.msa04  
   END IF 
    CLOSE i500_cl  
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_out(p_cmd)
  DEFINE msa    RECORD LIKE msa_file.*
  DEFINE msb    RECORD LIKE msb_file.*
  DEFINE l_sql  STRING                           #FUN-C30190 add
  DEFINE l_sfb08        LIKE sfb_file.sfb08      #FUN-C30190 add
  DEFINE l_sfb09        LIKE sfb_file.sfb09      #FUN-C30190 add
   DEFINE p_cmd         LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000,  #No.FUN-680082 VARCHAR(400)
        # l_za05        VARCHAR(40),
          l_za05        LIKE type_file.chr1000,  #No.FUN-680082 VARCHAR(40)
        # l_name        VARCHAR(40)
          l_name        LIKE type_file.chr20     #No.FUN-680082 VARCHAR(40)
 #FUN-C30190 add begin ---
 DEFINE sr   RECORD
                msa01   LIKE msa_file.msa01,
                msb02   LIKE msb_file.msb02,
                msb03   LIKE msb_file.msb03,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                ima55   LIKE ima_file.ima55,
                msb04   LIKE msb_file.msb04,
                msb07   LIKE msb_file.msb07,
                msb05   LIKE msb_file.msb05,
                sfb08   LIKE sfb_file.sfb08
             END RECORD
 #FUN-C30190 add end -----
   LET g_pdate = TODAY
   IF cl_null(g_wc) THEN
      LET g_wc=" msa01='",g_msa.msa01,"'"
   END IF
   IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_err('',-400,0) END IF
   CALL cl_wait()
#FUN-C30190 add begin ---
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#FUN-C30190 add end ----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT * FROM msa_file,msb_file",
             " WHERE msa01=msb01 AND ",g_wc CLIPPED
   PREPARE i500_out_p FROM g_sql
   DECLARE i500_out_c CURSOR FOR i500_out_p
#  CALL cl_outnam('amri500') RETURNING l_name                #FUN-C30190 MARK
#  START REPORT i500_rep TO l_name                           #FUN-C30190 MARK
   FOREACH i500_out_c INTO msa.*, msb.*
#     OUTPUT TO REPORT i500_rep (msa.*, msb.*)               #FUN-C30190 MARK
#FUN-C30190 add begin ---
     LET sr.msa01 = msa.msa01
     LET sr.msb02 = msb.msb02
     LET sr.msb03 = msb.msb03
     LET sr.msb04 = msb.msb04
     LET sr.msb05 = msb.msb05
     LET sr.msb07 = msb.msb07
     SELECT ima02,ima021,ima55 INTO sr.ima02,sr.ima021,sr.ima55
       FROM ima_file
      WHERE ima01=msb.msb03
     SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
            WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
              AND sfb04 != '8' AND sfb87!='X'  #未結案者, 以開工量為準
     IF l_sfb08 IS NULL THEN LET l_sfb08=0 END IF
     SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
            WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
              AND sfb04  = '8' AND sfb87!='X'   #已結案者, 以完工量為準
     IF l_sfb09 IS NULL THEN LET l_sfb09=0 END IF
     LET l_sfb08 = l_sfb08 + l_sfb09
     LET sr.sfb08 = l_sfb08
     EXECUTE  insert_prep  USING sr.*
#FUN-C30190 add end ----
   END FOREACH
#  FINISH REPORT i500_rep                                    #FUN-C30190 MARK
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)               #FUN-C30190 MARK
#FUN-C30190 add begin ---
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'msa01')
      RETURNING g_wc
   END IF
   CALL cl_wcchp(g_wc,'rme01,rme02,rme03') RETURNING g_wc3
   LET g_str = g_wc3
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY msa01,msb02"
   CALL cl_prt_cs3('amri500','amri500',l_sql,g_str)
#FUN-C30190 add end ----
   ERROR ' '
END FUNCTION
 
#FUN-C30190 MARK begin -----
#REPORT i500_rep(msa, msb)
#  DEFINE msa              RECORD LIKE msa_file.*
#  DEFINE msb              RECORD LIKE msb_file.*
#  DEFINE l_ima02          LIKE ima_file.ima02  #FUN-5B0098
#  DEFINE l_ima021         LIKE ima_file.ima021 #FUN-5B0098
#  DEFINE l_ima55          LIKE ima_file.ima55  #FUN-5B0098
#  DEFINE l_sfb08,l_nopen  LIKE sfb_file.sfb08 
#  DEFINE l_last_sw        LIKE type_file.chr1  #TQC-6B0011 add
# 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY msa.msa01, msb.msb02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#     #FUN-5B0098...............begin
#     #PRINT g_dash[1,g_len]
#     #PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#     #      g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#     #      g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#     #      ,g_x[43] CLIPPED
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33]
#      PRINTX name=H2 g_x[44],g_x[34]
#      PRINTX name=H3 g_x[45],g_x[35]
#      PRINTX name=H4 g_x[46],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#     #FUN-5B0098...............end
#      PRINT g_dash1
#      LET l_last_sw='n'   #TQC-6B0011 add
# 
#   BEFORE GROUP OF msa.msa01
#     #PRINT COLUMN g_c[31],msa.msa01; #FUN-5B0098
#      PRINTX name=D1 COLUMN g_c[31],msa.msa01; #FUN-5B0098
# 
#   ON EVERY ROW
#    LET l_ima02=NULL LET l_ima021=NULL LET l_ima55=NULL
#    SELECT ima02,ima021,ima55 INTO l_ima02,l_ima021,l_ima55 FROM ima_file 
#     WHERE ima01=msb.msb03
#    SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
#           WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
#             AND sfb04 != '8' AND sfb87!='X'  #未結案者, 以開工量為準
#    IF l_sfb08 IS NULL THEN LET l_sfb08=0 END IF
#    SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
#           WHERE sfb22=msb.msb01 AND sfb221=msb.msb02
#             AND sfb04  = '8' AND sfb87!='X'   #已結案者, 以完工量為準
#    IF l_sfb09 IS NULL THEN LET l_sfb09=0 END IF
#    LET l_sfb08 = l_sfb08 + l_sfb09
#    LET l_nopen = msb.msb05 - l_sfb08
#     #FUN-5B0098...............begin
#     #PRINT COLUMN g_c[32],msb.msb02 USING '####',
#     #      COLUMN g_c[33],msb.msb03[1,12],
#     #      COLUMN g_c[34],l_ima02,
#     #      COLUMN g_c[35],l_ima021,
#     #      COLUMN g_c[36],l_ima55,
#     #      COLUMN g_c[37],msb.msb04,
#     #      COLUMN g_c[38], msb.msb07,
#     #      COLUMN g_c[39],cl_numfor(msb.msb05,39,0), 
#     #      COLUMN g_c[41],cl_numfor(l_sfb08,41,0),
#     #      COLUMN g_c[43],cl_numfor(l_nopen,43,2)  
#     # IF NOT cl_null(msb.msb06) THEN
#     #      PRINT COLUMN g_c[31],g_x[20],COLUMN g_c[33],msb.msb06
#     #      ELSE PRINT
#     # END IF
#      PRINTX name=D1 COLUMN g_c[32],msb.msb02 USING '####',
#                     COLUMN g_c[33],msb.msb03 CLIPPED
#      PRINTX name=D2 COLUMN g_c[34],l_ima02 CLIPPED
#      PRINTX name=D3 COLUMN g_c[35],l_ima021 CLIPPED
#      PRINTX name=D4 COLUMN g_c[36],l_ima55,
#                     COLUMN g_c[37],msb.msb04,
#                     COLUMN g_c[38],msb.msb07,
#                     COLUMN g_c[39],cl_numfor(msb.msb05,39,0), 
#                     COLUMN g_c[41],cl_numfor(l_sfb08,41,0),
#                     COLUMN g_c[43],cl_numfor(l_nopen,43,2)  
#      IF NOT cl_null(msb.msb06) THEN
#          #----------No.MOD-880210 modify
#          #PRINT COLUMN g_c[31],g_x[20],COLUMN g_c[33],msb.msb06
#           PRINT COLUMN g_c[31],g_x[11],COLUMN g_c[33],msb.msb06
#          #----------No.MOD-880210 end
#           ELSE PRINT
#      END IF
#     #FUN-5B0098...............end
# 
#   AFTER GROUP OF msa.msa01
#      PRINT g_dash2
# 
#  #start TQC-6B0011 add
#   ON LAST ROW
#      LET l_last_sw = 'y'
#  #end TQC-6B0011 add
# 
#   PAGE TRAILER
#      PRINT g_dash
#     #start TQC-6B0011 add
#      IF l_last_sw= 'n' THEN
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#      ELSE
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#      END IF
#     #end TQC-6B0011 add
#      PRINT g_x[20] CLIPPED,
#            COLUMN 20,g_x[21] CLIPPED,
#            COLUMN 40,g_x[22] CLIPPED,
#            COLUMN 60,g_x[23] CLIPPED,
#            COLUMN 80,g_x[24] CLIPPED
# 
#END REPORT
#FUN-C30190 MARK end -----
 
FUNCTION i500_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,     #NO.FUN-680082  VARCHAR(1)  #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY  CNT #No.FUN-680082 SMALLINT 
    l_n             LIKE type_file.num5,     #檢查重複用         #No.FUN-680082 SMALLINT
    l_n1            LIKE type_file.num5,     #MOD-C50246 add
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否         #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態           #No.FUN-680082 VARCHAR(1)
  # l_sfb38         DATE,
    l_sfb38         LIKE sfb_file.sfb38,     #No.FUN-680082  DATE
    l_allow_insert  LIKE type_file.num5,     #可新增否           #No.FUN-680082 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否           #No.FUN-680082 SMALLINT

 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_msa.msa01 IS NULL THEN RETURN END IF
    #-->已結案不可修改
    IF g_msa.msa03 = 'Y' THEN CALL cl_err('','amr-100',0) RETURN END IF
    IF g_msa.msa05 = 'Y' THEN CALL cl_err('','anm-105',0) RETURN END IF  #NO.FUN-6B0045
    IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT msb02, msb03, '', '', '', msb04, ",
                       " msb07, msb05, msb919,0,0, msb06, msb08, ",            #FUN-A80150 add msb919
                       #No.FUN-840068 --start--
                       "        msbud01,msbud02,msbud03,msbud04,msbud05,",
                       "        msbud06,msbud07,msbud08,msbud09,msbud10,",
                       "        msbud11,msbud12,msbud13,msbud14,msbud15", 
                       #No.FUN-840068 ---end---
                       " FROM msb_file ",
                       " WHERE msb01=? ",
                       "   AND msb02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_msb WITHOUT DEFAULTS FROM s_msb.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
    OPEN i500_cl USING g_msa.msa01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_msa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE i500_cl
        RETURN
    END IF
 
    IF g_rec_b>=l_ac THEN
    #IF g_msb_t.msb02 IS NOT NULL THEN
        LET p_cmd='u'
        LET g_msb_t.* = g_msb[l_ac].*  #BACKUP
        OPEN i500_bcl USING g_msa.msa01,g_msb_t.msb02
        IF STATUS THEN
           CALL cl_err("OPEN i500_bcl:", STATUS, 1)
           CLOSE i500_bcl
           ROLLBACK WORK
           RETURN
        ELSE
           FETCH i500_bcl INTO g_msb[l_ac].*
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_msb_t.msb02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
           END IF
           LET g_msb[l_ac].sfb08 = g_msb_t.sfb08
           LET g_msb[l_ac].nopen = g_msb_t.nopen
           CALL i500_msb03('d') 
        END IF
        CALL cl_show_fld_cont()     #FUN-550037(smin)
    END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_msb.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            IF cl_null(g_msb[l_ac].msb03) THEN    #重要欄位空白,無效
                INITIALIZE g_msb[l_ac].* TO NULL
            END IF
            INSERT INTO msb_file
                   (msb01,msb02,msb03,msb04,msb05,msb919,msb06,msb07,msb08,         #FUN-A80150 add msb919
                    #FUN-840068 --start--
                    msbud01,msbud02,msbud03,msbud04,msbud05,msbud06,
                    msbud07,msbud08,msbud09,msbud10,msbud11,msbud12,
                    msbud13,msbud14,msbud15,msbplant,msblegal) #FUN-980004 add msbplant,msblegal
                    #FUN-840068 --end--
             VALUES(g_msa.msa01,
                    g_msb[l_ac].msb02,g_msb[l_ac].msb03,
                    g_msb[l_ac].msb04,g_msb[l_ac].msb05,g_msb[l_ac].msb919,        #FUN-A80150 add msb919
                    g_msb[l_ac].msb06,g_msb[l_ac].msb07,g_msb[l_ac].msb08,
                    #FUN-840068 --start--
                    g_msb[l_ac].msbud01,g_msb[l_ac].msbud02,
                    g_msb[l_ac].msbud03,g_msb[l_ac].msbud04,
                    g_msb[l_ac].msbud05,g_msb[l_ac].msbud06,
                    g_msb[l_ac].msbud07,g_msb[l_ac].msbud08,
                    g_msb[l_ac].msbud09,g_msb[l_ac].msbud10,
                    g_msb[l_ac].msbud11,g_msb[l_ac].msbud12,
                    g_msb[l_ac].msbud13,g_msb[l_ac].msbud14,
                    g_msb[l_ac].msbud15,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
                    #FUN-840068 --end--
             IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_msb[l_ac].msb02,SQLCA.sqlcode,0) #No.FUN-660107
                  CALL cl_err3("ins","msb_file",g_msa.msa01,g_msb[l_ac].msb02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                 CANCEL INSERT
             ELSE
                 MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2  
                 COMMIT WORK
             END IF
             CALL i500_b_tot()
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                INITIALIZE g_msb[l_ac].* TO NULL      #900423
                LET g_msb[l_ac].msb05 = 0
                LET g_msb[l_ac].msb08 = 0
                LET g_msb[l_ac].sfb08 = 0
                LET g_msb[l_ac].nopen = 0
            LET g_msb_t.* = g_msb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD msb02
 
        BEFORE FIELD msb02                        #default 序號
            IF g_msb[l_ac].msb02 IS NULL OR
               g_msb[l_ac].msb02 = 0 THEN
                SELECT max(msb02)+1 INTO g_msb[l_ac].msb02
                   FROM msb_file
                   WHERE msb01 = g_msa.msa01
                IF g_msb[l_ac].msb02 IS NULL THEN
                    LET g_msb[l_ac].msb02 = 1
                END IF
            END IF
 
        AFTER FIELD msb02                        #check 序號是否重複
            IF NOT cl_null(g_msb[l_ac].msb02) THEN 
               IF g_msb[l_ac].msb02 != g_msb_t.msb02 OR
                  g_msb_t.msb02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM msb_file
                       WHERE msb01 = g_msa.msa01
                         AND msb02 = g_msb[l_ac].msb02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_msb[l_ac].msb02 = g_msb_t.msb02
                       NEXT FIELD msb02
                   END IF
               END IF
            END IF
 
        AFTER FIELD msb03
           IF NOT cl_null(g_msb[l_ac].msb03) THEN
             #FUN-AA0059 --------------------add start-------------
              IF NOT s_chk_item_no(g_msb[l_ac].msb03,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD msb03
              END IF
             #FUN-AA059 ---------------------add end------------------    
             #MOD-C50246 str add-----
              LET l_n1 = 0
              SELECT COUNT(*)  INTO l_n1 FROM bma_file WHERE bma01 = g_msb[l_ac].msb03
                                          AND bmaacti = 'Y'
              IF l_n1 = 0 THEN
                      CALL cl_err('','amr-002',0)
                      NEXT FIELD msb03
              END IF
             #MOD-C50246 end add-----
               #MOD-480039
              CALL i500_msb03('a') 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD msb03 
              END IF  
              #--
           END IF
 
        AFTER FIELD msb04
            IF p_cmd ='a' THEN
               LET g_msb[l_ac].msb07 = g_msb[l_ac].msb04
               DISPLAY g_msb[l_ac].msb07 TO msb07
            END IF
           
        AFTER FIELD msb05
            #No.TQC-750041  --BEGIN--
            IF NOT cl_null(g_msb[l_ac].msb05) THEN
               IF g_msb[l_ac].msb05<0 THEN
                  CALL cl_err(g_msb[l_ac].msb05,'mfg5034',0)
                  NEXT FIELD msb05
               END IF
            END IF
            #No.TQC-750041  --END--
            IF p_cmd ='a' THEN
               LET g_msb[l_ac].msb08 = g_msb[l_ac].msb05
            END IF
            LET g_msb[l_ac].nopen=g_msb[l_ac].msb05-g_msb[l_ac].sfb08
            DISPLAY g_msb[l_ac].nopen TO nopen
            DISPLAY g_msb[l_ac].sfb08 TO sfb08
        AFTER FIELD msb06
            IF g_msb[l_ac].msb06 IS NOT NULL THEN
               SELECT MAX(bmb04) INTO g_msb[l_ac].msb07
                 FROM bmb_file
                WHERE bmb01=g_msb[l_ac].msb03
                  AND bmb03=g_msb[l_ac].msb06
               IF STATUS OR g_msb[l_ac].msb07 IS NULL THEN
#                  CALL cl_err('sel bmb',100,1) #No.FUN-660107
                   CALL cl_err3("sel","bmb_file",g_msb[l_ac].msb03,g_msb[l_ac].msb06,100,"","sel bmb",1)       #NO.FUN-660107
                   NEXT FIELD msb06
               END IF
            END IF

       #MOD-C50246 str add-----
        AFTER FIELD msb07
           IF g_msb[l_ac].msb07 IS NOT NULL THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM bmb_file WHERE bmb01=g_msb[l_ac].msb03
                                                        AND (bmb04 IS NULL OR bmb04 <= g_msb[l_ac].msb07)
                                                        AND (bmb05 IS NULL OR bmb05 >= g_msb[l_ac].msb07)
              IF l_n1=0 THEN
                  CALL cl_err('','amr-008',1)
                  NEXT FIELD msb07
              END IF
           END IF
       #MOD-C50246 end add----- 

        #No.FUN-840068 --start--
        AFTER FIELD msbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD msbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_msb_t.msb02 > 0 AND g_msb_t.msb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM msb_file
                    WHERE msb01 = g_msa.msa01
                      AND msb02 = g_msb_t.msb02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_msb_t.msb02,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("del","msb_file",g_msa.msa01,g_msb_t.msb02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
                CALL i500_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_msb[l_ac].* = g_msb_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msb[l_ac].msb02,-263,1)
               LET g_msb[l_ac].* = g_msb_t.*
            ELSE
               IF cl_null(g_msb[l_ac].msb03) THEN    #重要欄位空白,無效
                   INITIALIZE g_msb[l_ac].* TO NULL
               END IF
               UPDATE msb_file SET
                     msb02=g_msb[l_ac].msb02,
                     msb03=g_msb[l_ac].msb03,
                     msb04=g_msb[l_ac].msb04,
                     msb05=g_msb[l_ac].msb05,
                     msb919=g_msb[l_ac].msb919,    #FUN-A80150 add
                     msb06=g_msb[l_ac].msb06,
                     msb07=g_msb[l_ac].msb07,
                     msb08=g_msb[l_ac].msb08,
                     #FUN-840068 --start--
                     msbud01 = g_msb[l_ac].msbud01,
                     msbud02 = g_msb[l_ac].msbud02,
                     msbud03 = g_msb[l_ac].msbud03,
                     msbud04 = g_msb[l_ac].msbud04,
                     msbud05 = g_msb[l_ac].msbud05,
                     msbud06 = g_msb[l_ac].msbud06,
                     msbud07 = g_msb[l_ac].msbud07,
                     msbud08 = g_msb[l_ac].msbud08,
                     msbud09 = g_msb[l_ac].msbud09,
                     msbud10 = g_msb[l_ac].msbud10,
                     msbud11 = g_msb[l_ac].msbud11,
                     msbud12 = g_msb[l_ac].msbud12,
                     msbud13 = g_msb[l_ac].msbud13,
                     msbud14 = g_msb[l_ac].msbud14,
                     msbud15 = g_msb[l_ac].msbud15
                     #FUN-840068 --end-- 
               WHERE msb01=g_msa.msa01
                 AND msb02=g_msb_t.msb02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                   CALL cl_err(g_msb[l_ac].msb02,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("upd","msb_file",g_msa.msa01,g_msb_t.msb02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                   LET g_msb[l_ac].* = g_msb_t.*
                   DISPLAY g_msb[l_ac].* TO s_msb[l_sl].*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
               CALL i500_b_tot()
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msb[l_ac].* = g_msb_t.*
              #MOD-D30064 add
               ELSE  
                  CALL g_msb.deleteElement(l_ac)   #取消 Array Element
                  IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
              #MOD-D30064
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i500_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(msb02) AND l_ac > 1 THEN
                LET g_msb[l_ac].* = g_msb[l_ac-1].*
                LET g_msb[l_ac].msb02 = 0
                NEXT FIELD msb02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       #---------No.MOD-830007 mark
       #ON ACTION create_body
       #    CALL i500_g()
       #    CALL i500_b_fill('1=1')
       #    EXIT INPUT
       #---------No.MOD-830007 end
 
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(msb03)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form     = "q_ima"
                 #  LET g_qryparam.default1 = g_msb[l_ac].msb03
                 #  CALL cl_create_qry() RETURNING g_msb[l_ac].msb03
#                #   CALL FGL_DIALOG_SETBUFFER( g_msb[l_ac].msb03 )
                    CALL q_sel_ima(FALSE, "q_ima", "", g_msb[l_ac].msb03, "", "", "", "" ,"",'' )  RETURNING g_msb[l_ac].msb03
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_msb[l_ac].msb03           #No.MOD-490371
                   NEXT FIELD msb03
           END CASE
 
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   END INPUT
 
  #start FUN-5A0029
   LET g_msa.msamodu = g_user
   LET g_msa.msamodd = g_today
   UPDATE msa_file SET msamodu = g_msa.msamodu,msamodd = g_msa.msamodd
    WHERE msa01 =  g_msa.msa01
   DISPLAY BY NAME g_msa.msamodu,g_msa.msamodd
  #end FUN-5A0029
 
   CALL i500_b_tot()
 
   CLOSE i500_bcl
   COMMIT WORK
   CALL i500_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i500_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_msa.msa01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM msa_file ",
                  "  WHERE msa01 LIKE '",l_slip,"%' ",
                  "    AND msa01 > '",g_msa.msa01,"'"
      PREPARE i500_pb1 FROM l_sql 
      EXECUTE i500_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i500_v()    #CHI-D20010
         CALL i500_v(1)   #CHI-D20010
         IF g_msa.msa05 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM msa_file  WHERE msa01 =  g_msa.msa01
         INITIALIZE g_msa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i500_msb03(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
     # l_imaacti   VARCHAR(1)
       l_imaacti   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
 
   LET g_errno = ''
   SELECT ima02,ima021,ima55,imaacti 
     INTO g_msb[l_ac].ima02,g_msb[l_ac].ima021,g_msb[l_ac].ima55,l_imaacti
     FROM ima_file
    WHERE ima01=g_msb[l_ac].msb03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'   #MOD-480039
                                  LET g_msb[l_ac].ima02 ='' 
                                  LET g_msb[l_ac].ima021='' 
                                  LET g_msb[l_ac].ima55 ='' 
         WHEN l_imaacti='N' LET g_errno = '9028'
     #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------         
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN 
       DISPLAY g_msb[l_ac].ima02  TO ima02
       DISPLAY g_msb[l_ac].ima021 TO ima021
       DISPLAY g_msb[l_ac].ima55  TO ima55
    END IF
END FUNCTION
 
#------------------No.MOD-830007 mrk
#FUNCTION i500_g()
#   DEFINE l_no  LIKE bma_file.bma01              #NO.MOD-490217 
#   DEFINE l_msb RECORD LIKE msb_file.*
 
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT "P/NO:" FOR l_no
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#         CONTINUE PROMPT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  
#  END PROMPT
#  LET g_msg="SELECT bma01 FROM bma_file WHERE bma01 MATCHES '",l_no,"'"
#  PREPARE i500_g_p FROM g_msg
#  DECLARE i500_g_c CURSOR FOR i500_g_p
#  SELECT MAX(msb02) INTO l_msb.msb02 FROM msb_file WHERE msb01=g_msa.msa01
#  IF l_msb.msb02 IS NULL THEN LET l_msb.msb02 = 0 END IF
#  FOREACH i500_g_c INTO l_no
#    LET l_msb.msb01=g_msa.msa01
#    LET l_msb.msb02=l_msb.msb02+1
#    LET l_msb.msb03=l_no
#    LET l_msb.msb04=TODAY
#    LET l_msb.msb07=TODAY
#    LET l_msb.msb05=100
#    INSERT INTO msb_file VALUES(l_msb.*)
#  END FOREACH
#END FUNCTION
#------------------No.MOD-830007 end
 
FUNCTION i500_b_tot()
DEFINE l_sfb08 like sfb_file.sfb08
 
   SELECT SUM(msb08),SUM(msb05) INTO msb08t,msb05t
          FROM msb_file
         WHERE msb01 = g_msa.msa01
   SELECT SUM(sfb08) INTO l_sfb08
           FROM sfb_file
           WHERE sfb22=g_msa.msa01 
             AND sfb04 != '8' AND sfb87!='X'   #未結案者, 以開工量為準
        IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
        SELECT SUM(sfb09) INTO l_sfb09
           FROM sfb_file
           WHERE sfb22=g_msa.msa01 
             AND sfb04  = '8' AND sfb87!='X'  #已結案者, 以完工量為準
        IF l_sfb09 IS NULL THEN LET l_sfb09 = 0 END IF
        LET sfb08t=l_sfb08+l_sfb09
        LET nopent=msb05t-sfb08t
 
   IF msb05t IS NULL THEN LET msb05t = 0 END IF
   IF msb08t IS NULL THEN LET msb08t = 0 END IF
   IF sfb08t IS NULL THEN LET sfb08t = 0 END IF
   IF nopent IS NULL THEN LET nopent = 0 END IF
   DISPLAY BY NAME msb05t
   DISPLAY BY NAME msb08t
   DISPLAY BY NAME sfb08t
   DISPLAY BY NAME nopent
END FUNCTION
 
FUNCTION i500_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680082 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON msb02,msb03,msb04
                       #No.FUN-840068 --start--
                       ,msbud01,msbud02,msbud03,msbud04,msbud05
                       ,msbud06,msbud07,msbud08,msbud09,msbud10
                       ,msbud11,msbud12,msbud13,msbud14,msbud15
                       #No.FUN-840068 ---end---
            FROM s_msb[1].msb02,s_msb[1].msb03,s_msb[1].msb04
                 #No.FUN-840068 --start--
                 ,s_msb[1].msbud01,s_msb[1].msbud02,s_msb[1].msbud03
                 ,s_msb[1].msbud04,s_msb[1].msbud05,s_msb[1].msbud06
                 ,s_msb[1].msbud07,s_msb[1].msbud08,s_msb[1].msbud09
                 ,s_msb[1].msbud10,s_msb[1].msbud11,s_msb[1].msbud12
                 ,s_msb[1].msbud13,s_msb[1].msbud14,s_msb[1].msbud15
                 #No.FUN-840068 ---end---
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i500_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000    #No.FUN-680082 VARCHAR(200)
 
# genero  script marked     IF g_msb_sarrno = 0 THEN RETURN END IF
    LET g_sql =
        "SELECT msb02, msb03, ima02, ima021, ima55, msb04,",
        " msb07, msb05, msb919,0, 0, msb06, msb08, ",           #FUN-A80150 add msb919
        #No.FUN-840068 --start--
        "       msbud01,msbud02,msbud03,msbud04,msbud05,",
        "       msbud06,msbud07,msbud08,msbud09,msbud10,",
        "       msbud11,msbud12,msbud13,msbud14,msbud15", 
        #No.FUN-840068 ---end---
        " FROM msb_file LEFT OUTER JOIN ima_file ON msb_file.msb03=ima_file.ima01",
        " WHERE msb01 ='",g_msa.msa01,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身 #No.MOD-690039 add
        " ORDER BY 1"
    PREPARE i500_pb FROM g_sql
    DECLARE msb_curs CURSOR FOR i500_pb
 
    CALL g_msb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET msb05t=0 LET msb08t=0 LET sfb08t=0 LET nopent=0
    FOREACH msb_curs INTO g_msb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT SUM(sfb08) INTO g_msb[g_cnt].sfb08
           FROM sfb_file
           WHERE sfb22=g_msa.msa01 AND sfb221=g_msb[g_cnt].msb02
             AND sfb04 != '8' AND sfb87!='X'   #未結案者, 以開工量為準
        IF g_msb[g_cnt].sfb08 IS NULL THEN LET g_msb[g_cnt].sfb08 = 0 END IF
        SELECT SUM(sfb09) INTO l_sfb09
           FROM sfb_file
           WHERE sfb22=g_msa.msa01 AND sfb221=g_msb[g_cnt].msb02
             AND sfb04  = '8' AND sfb87!='X'  #已結案者, 以完工量為準
        IF l_sfb09 IS NULL THEN LET l_sfb09 = 0 END IF
        LET g_msb[g_cnt].sfb08=g_msb[g_cnt].sfb08+l_sfb09
        LET g_msb[g_cnt].nopen=g_msb[g_cnt].msb05-g_msb[g_cnt].sfb08
        LET msb05t=msb05t+g_msb[g_cnt].msb05
        LET msb08t=msb08t+g_msb[g_cnt].msb08
        LET sfb08t=sfb08t+g_msb[g_cnt].sfb08
        LET nopent=nopent+g_msb[g_cnt].nopen
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    CALL g_msb.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3 
    DISPLAY BY NAME msb05t
    DISPLAY BY NAME msb08t
    DISPLAY BY NAME sfb08t
    DISPLAY BY NAME nopent
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msb TO s_msb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
         #圖形顯示
         #CALL cl_set_field_pic("","","",g_msa.msa03,"","")
         #CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,"","")  #NO.FUN-6B0045  #CHI-C80041
         IF g_msa.msa05 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_msa.msa05,"","",g_msa.msa03,g_void,"")  #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 結案
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
#NO.FUN-6B0045 start-----
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
#NO.FUN-6B0045 end-------
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
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
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
   
     ON ACTION related_document                #No.FUN-6B0041  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i500_copy() 
 # DEFINE old_msa01     VARCHAR(16)                #No.FUN-560060
   DEFINE old_msa01     LIKE msa_file.msa01     #No.FUN-680082 VARCHAR(16)
 # DEFINE new_msa01     VARCHAR(16)                #No.FUN-560060
   DEFINE new_msa01     LIKE msa_file.msa01     #No.FUN-680082 VARCHAR(16)
 # DEFINE new_msb04     DATE
   DEFINE new_msb04     LIKE msb_file.msb04     #No.FUN-680082 DATE
 # DEFINE new_msb07     DATE
   DEFINE new_msb07     LIKE msb_file.msb07     #No.FUN-680082 DATE
 # DEFINE i             INTEGER
   DEFINE i             LIKE type_file.num10    #No.FUN-680082 INTEGER
   DEFINE l_msa         RECORD LIKE msa_file.*
   DEFINE l_msb         RECORD LIKE msb_file.*
 
   OPEN WINDOW i500_c_w AT 12,24 WITH FORM "amr/42f/amri500_c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amri500_c")
 
       
   IF STATUS THEN CALL cl_err('open window i500_c:',STATUS,0) RETURN END IF
   LET old_msa01 = g_msa.msa01
   LET new_msa01 = NULL
   LET new_msb04 = NULL
   LET new_msb07 = NULL
   INPUT BY NAME old_msa01, new_msa01, new_msb04, new_msb07 WITHOUT DEFAULTS
      AFTER FIELD old_msa01
        IF NOT cl_null(old_msa01) THEN 
           SELECT msa01 FROM msa_file WHERE msa01=old_msa01
           IF STATUS THEN 
#              CALL cl_err('sel msa:',STATUS,0) #No.FUN-660107
               CALL cl_err3("sel","msa_file",old_msa01,"",STATUS,"","sel msa",1)       #NO.FUN-660107
              NEXT FIELD old_msa01
           END IF
        END IF
      AFTER FIELD new_msa01
        IF NOT cl_null(new_msa01) THEN 
           SELECT msa01 FROM msa_file WHERE msa01=new_msa01
           IF STATUS=0 THEN 
#              CALL cl_err('sel msa:',-239,0) #No.FUN-660107
               CALL cl_err3("sel","msa_file",new_msa01,"",-239,"","sel msa:",1)       #NO.FUN-660107
              NEXT FIELD new_msa01
           END IF
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   CLOSE WINDOW i500_c_w
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   BEGIN WORK LET g_success='Y'
   SELECT * INTO l_msa.* FROM msa_file WHERE msa01=old_msa01
   IF STATUS THEN
#   CALL cl_err('sel msa:',STATUS,1)  #No.FUN-660107
    CALL cl_err3("sel","msa_file",old_msa01,"",STATUS,"","sel msa:",1)       #NO.FUN-660107
   LET g_success='N' END IF
   LET l_msa.msa01  =new_msa01
   LET l_msa.msa03  ='N'
   LET l_msa.msa04  =NULL
   LET l_msa.msa05  ='N'   #NO.FUN-6B0045
   LET l_msa.msauser=g_user
   LET l_msa.msagrup=g_grup #darcy:2023/03/28 add
   LET l_msa.msadate=TODAY
   LET l_msa.msamodu=NULL
   LET l_msa.msamodd=NULL
   LET l_msa.msaplant=g_plant #FUN-980004 add
   LET l_msa.msalegal=g_legal #FUN-980004 add
   LET l_msa.msaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_msa.msaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO msa_file VALUES(l_msa.*)
   IF STATUS THEN 
#   CALL cl_err('ins msa:',STATUS,1) #No.FUN-660107
    CALL cl_err3("ins","msa_file",l_msa.msa01,"",STATUS,"","ins msa:",1)       #NO.FUN-660107
   LET g_success='N' END IF
   DECLARE i500_c CURSOR FOR SELECT * FROM msb_file WHERE msb01=old_msa01
   LET i = 0
   FOREACH i500_c INTO l_msb.*
      LET i = i+1
      LET l_msb.msb01 = new_msa01
      IF new_msb04 IS NOT NULL THEN LET l_msb.msb04 = new_msb04 END IF
      IF new_msb07 IS NOT NULL THEN LET l_msb.msb07 = new_msb07 END IF
      LET l_msb.msbplant = g_plant #FUN-980004 add
      LET l_msb.msblegal = g_legal #FUN-980004 add
      INSERT INTO msb_file VALUES(l_msb.*)
      IF STATUS THEN 
#      CALL cl_err('ins msb:',STATUS,1)  #No.FUN-660107
       CALL cl_err3("ins","msb_file",l_msb.msb01,l_msb.msb02,STATUS,"","ins msb:",1)       #NO.FUN-660107
      LET g_success='N' END IF
   END FOREACH
   IF g_success='Y'
      THEN COMMIT WORK   MESSAGE i,' rows copied!'
      ELSE ROLLBACK WORK MESSAGE 'rollback work!'
   END IF
END FUNCTION
 
#NO.FUN-6B0045 START---------------------
FUNCTION i500_y()
DEFINE   l_cnt   LIKE type_file.num5   
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 --------- add --------- begin
   IF g_msa.msa05='Y'      THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041

   IF g_msa.msa03='Y' THEN
      CALL cl_err('','axr-013',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
   THEN
       IF NOT cl_confirm('axm-108') THEN
          LET g_success = "N"
          RETURN
       END IF
   END IF
#CHI-C30107 --------- add --------- end
   SELECT * INTO g_msa.* FROM msa_file WHERE msa01 = g_msa.msa01
   IF cl_null(g_msa.msa01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_msa.msa05='Y'      THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041
 
   IF g_msa.msa03='Y' THEN
      CALL cl_err('','axr-013',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM msb_file
    WHERE msb01=g_msa.msa01
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-008',0)
      LET g_success = 'N'
      RETURN
   END IF
#CHI-C30107 --------- mark ----------- begin
#  IF g_action_choice CLIPPED = "confirm"       #按「確認」時
#  THEN
#      IF NOT cl_confirm('axm-108') THEN 
#         LET g_success = "N" 
#         RETURN
#      END IF
#  END IF
#CHI-C30107 --------- mark ----------- end
 
   BEGIN WORK
 
   OPEN i500_cl USING g_msa.msa01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK 
      RETURN
   END IF
   FETCH i500_cl INTO g_msa.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
      CLOSE i500_cl
      ROLLBACK WORK  
      RETURN
   END IF
 
   UPDATE msa_file SET msa05='Y' WHERE msa01=g_msa.msa01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","msa_file",g_msa.msa01,"",SQLCA.SQLCODE,"","upd msa05:",1)
       LET g_success='N'
       ROLLBACK WORK  
       RETURN        
   END IF
 
   IF g_success='Y' THEN
      LET g_msa.msa05='Y'
      COMMIT WORK   
      CALL cl_flow_notify(g_msa.msa01,'Y')
      DISPLAY BY NAME g_msa.msa05
   ELSE
      LET g_msa.msa05='N'
      LET g_success = 'N'
      ROLLBACK WORK   
   END IF
 
END FUNCTION
 
FUNCTION i500_z()
DEFINE   l_cnt   LIKE type_file.num5   
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_msa.* FROM msa_file WHERE msa01 = g_msa.msa01
   IF cl_null(g_msa.msa01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_msa.msa05='N'      THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_msa.msa05 = 'X' THEN RETURN END IF  #CHI-C80041
 
   IF g_msa.msa03='Y' THEN
      CALL cl_err('','axr-013',0)
      RETURN
   END IF
 
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM msb_file
    WHERE msb01=g_msa.msa01
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-008',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_action_choice CLIPPED = "undo_confirm"    
   THEN
       IF NOT cl_confirm('aim-304') THEN 
          LET g_success = "N" 
          RETURN
       END IF
   END IF
 
   BEGIN WORK
 
   OPEN i500_cl USING g_msa.msa01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK 
      RETURN
   END IF
   FETCH i500_cl INTO g_msa.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)
      CLOSE i500_cl
      ROLLBACK WORK  
      RETURN
   END IF
 
   UPDATE msa_file SET msa05='N' WHERE msa01=g_msa.msa01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","msa_file",g_msa.msa01,"",SQLCA.SQLCODE,"","upd msa05:",1)
       LET g_success='N'
       ROLLBACK WORK  
       RETURN        
   END IF
 
   IF g_success='Y' THEN
      LET g_msa.msa05='N'
      COMMIT WORK   
      DISPLAY BY NAME g_msa.msa05
   ELSE
      LET g_msa.msa05='N'
      LET g_success = 'N'
      ROLLBACK WORK   
   END IF
 
END FUNCTION
#NO.FUN-6B0045 end----------------
#CHI-C80041---begin
#FUNCTION i500_v()  #CHI-D20010
FUNCTION i500_v(p_type)  #CHI-D20010
DEFINE l_chr  LIKE type_file.chr1
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_msa.msa01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_msa.msa05 ='X' THEN RETURN END IF
   ELSE
      IF g_msa.msa05 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end 

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i500_cl USING g_msa.msa01
   IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i500_cl INTO g_msa.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_msa.msa01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i500_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_msa.msa05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_msa.msa05 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_msa.msa05) THEN #CHI-D20010
   IF cl_void(0,0,l_flag) THEN      #CHI-D20010
        LET l_chr=g_msa.msa05
       #IF g_msa.msa05='N' THEN    #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010
            LET g_msa.msa05='X' 
        ELSE
            LET g_msa.msa05='N'
        END IF
        UPDATE msa_file
            SET msa05=g_msa.msa05,  
                msamodu=g_user,
                msadate=g_today
            WHERE msa01=g_msa.msa01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","msa_file",g_msa.msa01,"",SQLCA.sqlcode,"","",1)  
            LET g_msa.msa05=l_chr 
        END IF
        DISPLAY BY NAME g_msa.msa05
   END IF
 
   CLOSE i500_cl
   COMMIT WORK
   CALL cl_flow_notify(g_msa.msa01,'V')
 
END FUNCTION
#CHI-C80041---end
