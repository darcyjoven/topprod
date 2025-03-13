# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aglt001.4gl
# Descriptions...: 調整與銷除分錄底稿維護作業
# Date & Author..: 01/09/21 By Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-550057 05/06/02 By jackie 單據編號加大
# Modify.........: NO.FUN-560014 05/06/08 By wujie  單據編號修改
# Modify.........: NO.FUN-590062 05/09/13 By Dido 1.[上層公司]/[帳別]透過族群代碼自動代出,不可更改
#                                                 2.增加顯示該帳別的[記帳幣別]
#                                                 3.單身金額輸入按照[記帳幣別]進行取位
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.MOD-6A0037 06/10/14 By Smapmin 單身摘要開窗
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.MOD-6C0011 06/12/04 By Smapmin 調整日期不應再CHECK關帳日期
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By sherry  會計科目加帳套 
# Modify.........: NO.FUN-750076 07/05/18 BY yiting 加入版本欄位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760044 07/06/15 By Sarah 版本(axi21)隱藏,程式寫死塞入00
# Modify.........: No.FUN-770086 07/07/24 By kim axi08 add item 3
# Modify.........: No.FUN-770069 07/08/03 By Sarah 調整期別(axi04)與版本(axi21)的查詢欄位輸入順序
# Modify.........: No.MOD-790102 07/09/20 By Smapmin 單頭取消修改後所有欄位變為空白
# Modify.........: No.MOD-930284 09/04/02 By Sarah 當資料來源為1,調整日期為XX/12/31時,允許進入調整會計年期,年度/期別default為XX/12,年度/期別可改為XX+1/0
# Modify.........: No.TQC-950063 09/05/11 By chenmoyan UPDATE時缺少KEY：
# Modify.........: No.FUN-920070 09/02/11 By jamie 1.單身科目名稱沒有show出 2.單身科目開窗以及檢查用上層公司DB+合併後帳別
# Modify.........: NO.FUN-930144 09/05/21 BY ve007 確認時，自動產生一筆分錄單號，版本為"截止期別" ，其餘資料(單號重取)與00版本相同(年度/期別為current單據) 
#                                         版次不為00的單據在刪除時需檢查是否此單號有存在版次為00的單據的axi13欄位值中，如有，則不可進行刪除，只有版次00的單據可以做刪除動作
#                                         且版次00的單據在取消確認時，要把axi13單號相同and版次=期別的單據刪除 
# Modify.........: No.FUN-930090 09/05/21 By ve007 單頭axi06上層公司開放輸入，應依族群代碼axi05為key,需存在agli002單頭axa02設定，開窗資料/欄位輸入檢查邏輯相同 
# Modify.........: No.FUN-950048 09/05/25 By jan拿掉‘版本’欄位
# Modify.........: NO.FUN-950051 09/05/26 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改 
# Modify.........: NO.FUN-960003 09/05/30 by Yiting 原本在確認時自動產生一張版同不同的單據，功能取消
# Modify.........: NO.FUN-960184 09/07/09 By hongmei 修改新增時取單號錯誤
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/14 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:MOD-9C0458 09/12/31 By Sarah axi00值的應抓合併後帳別aaz641,而不是aaz64
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.CHI-9C0038 10/01/25 By lutingting 科目開放可錄入結轉科目
# Modify.........: No.FUN-A10135 10/01/28 By lutingting 資料來源不為2:資料匯入時開放復制功能
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AGL
# Modify.........: NO.MOD-A40193 10/04/30 by yiting 1.axi21寫死為00
# Modify.........: NO.TQC-A50088 10/05/20 by sabrina 由於執行 aglp002 寫入 axkk07 為必要值,
#                                                    因此請將 axj05 增加判斷,若為 null 時給予 ' '  
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-AA0040 10/10/19 By Carrier gglq002 串查aglt001 & 修改串查条件
# Modify.........: NO.TQC-AB0046 10/11/12 BY Dido 進入單身時重新取 t_azi 
# Modify.........: No.FUN-A90030 11/01/24 By vealxu 增加axi081欄位  
# Modify.........: No.FUN-AA0005 11/01/30 By chenmoyan axi08為空白時,NEXT FIELD axi08
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70003 11/06/28 By lujh 當是大陸版時，只能查询
# Modify.........: No.FUN-B60143 11/07/06 By zhangweib  add itmes axi08_4  axi08_5         
# Modify.........: No.TQC-B80009 11/08/02 By Polly 修正查詢時，因g_aaz641沒有值，而導致科目名稱無法顯示
# Modify.........: No.TQC-B70040 11/08/02 By yinhy 單身錄入時，科目名稱帶入錯誤
# Modify.........: No.MOD-B70103 11/08/09 by yiting 取g_azz641 時有誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.MOD-BB0284 11/11/24 By Sarah 修正FUN-A10135,複製時應排除axi08='2'的才對
# Modify........,: No.MOD-BC0289 11/12/29 By Polly 新增單據取號時出現錯誤，調整傳入參數
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20016 12/02/02 By Polly AFTER FIELD axi06 需檢核是否存在 axb_file.
# Modify.........: No:MOD-C40101 12/04/16 By Elise 新增段時,axi09 預設值給予 'Y',且不可輸入
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70002 12/07/02 By lujh   取消FUN-B70003修改
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C80021 12/08/06 By Polly  開放axi08欄位輸入，再新增/修改/複製時,不可選擇 2:沖銷選項
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.CHI-D20005 13/02/07 By apo 取消針對資料來源"2.沖銷"的傳票進行新增/複製時的控卡
# Modify.........: No:FUN-D20048 13/03/21 By Lori 增加沖銷組別(axj13)
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
DEFINE
    g_axi   RECORD LIKE axi_file.*,
    g_aaa   RECORD LIKE aaa_file.*,
    g_aac   RECORD LIKE aac_file.*,
    g_axi01_o  LIKE axi_file.axi01,
    g_axi01_t  LIKE axi_file.axi01,
    g_axi_o RECORD LIKE axi_file.*,
    g_axi_t RECORD LIKE axi_file.*,
    b_axj   RECORD LIKE axj_file.*,
    g_axj   DYNAMIC ARRAY OF RECORD
            axj13    LIKE axj_file.axj13,   #FUN-D20048 add
            axj02    LIKE axj_file.axj02,
            axj03    LIKE axj_file.axj03,
            aag02    LIKE aag_file.aag02,
            axj04    LIKE axj_file.axj04,
            axj05    LIKE axj_file.axj05,
            axj06    LIKE axj_file.axj06,
            axj07    LIKE axj_file.axj07
 	    END RECORD,
    g_axj_t RECORD
            axj13    LIKE axj_file.axj13,   #FUN-D20048 add
            axj02    LIKE axj_file.axj02,
            axj03    LIKE axj_file.axj03,
            aag02    LIKE aag_file.aag02,
            axj04    LIKE axj_file.axj04,
            axj05    LIKE axj_file.axj05,
            axj06    LIKE axj_file.axj06,
            axj07    LIKE axj_file.axj07
 	    END RECORD,
    g_wc,g_wc1,g_sql STRING,  #No.FUN-580092 HCN       
    g_t1             LIKE aac_file.aac01,         #No.FUN-550057        #No.FUN-680098 VARCHAR(5)
    g_rec_b          LIKE type_file.num5,         #單身筆數        #No.FUN-680098 smallint
    l_ac             LIKE type_file.num5,         #目前處理的ARRAY CNT        #No.FUN-680098 smallint
    l_cmd            LIKE type_file.chr1000,      #No.FUN-680098  VARCHAR(100)
    #No.FUN-AA0040   --Begin                                                       
    #g_argv1         LIKE axi_file.axi01,         #传票编号    #No.FUN-560014  #N
    #g_argv2         LIKE aaa_file.aaa01,         #帐别   #No.FUN-670039         
    g_argv1          LIKE axi_file.axi00,         #帐套                          
    g_argv2          LIKE axi_file.axi03,         #年度                          
    g_argv3          LIKE axi_file.axi04,         #月份                          
    g_argv4          LIKE axi_file.axi21,         #版本号                        
    #No.FUN-AA0040   --End                        
    g_bookno         LIKE aaa_file.aaa01,
    l_azn02          LIKE azn_file.azn02,
    l_azn04          LIKE azn_file.azn04,
    g_axz06          LIKE axz_file.axz06,         #FUN-590062 新增記帳幣別 
    g_before_input_done LIKE type_file.num5,      #No.FUN-680098 smallint
    g_forupd_sql        STRING    
 
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680098 integer
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680098 smallint
DEFINE   g_aaz641       LIKE aaz_file.aaz641         #FUN-920070 add
DEFINE   g_dbs_axz03    LIKE type_file.chr21         #FUN-920070 add
DEFINE   g_plant_axz03  LIKE type_file.chr10         #FUN-980025 add
DEFINE   g_axz03        LIKE axz_file.axz03          #FUN-920070 add
DEFINE   g_axz04        LIKE axz_file.axz04          #FUN-960184 add
DEFINE   g_axa09        LIKE axa_file.axa09          #FUN-960184 add
DEFINE   g_newno        LIKE axi_file.axi01          #FUN-930144 add
DEFINE   g_void         LIKE type_file.chr1      #CHI-C80041
 
MAIN
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680098 smallint
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-AA0040  --Begin                                                      
   #LET g_argv1 = ARG_VAL(2)     #No:MOD-4C0171                                 
   #LET g_argv2 = ARG_VAL(1)     #No:MOD-4C0171                                 
   LET g_argv1 = ARG_VAL(1)                                                     
   LET g_argv2 = ARG_VAL(2)                                                     
   LET g_argv3 = ARG_VAL(3)                                                     
   LET g_argv4 = ARG_VAL(4)                                                     
   #No.FUN-AA0040  --End   
 
   LET p_row = 2 LET p_col = 5
 
   LET g_forupd_sql = " SELECT * FROM axi_file ",
                      " WHERE axi00 = ? AND axi01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t001_w AT p_row,p_col
       WITH FORM "agl/42f/aglt001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF not cl_null(g_argv1) THEN CALL t001_q() END IF
    CALL t001_menu()
    CLOSE WINDOW t001_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION t001_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_axj.clear()
    IF g_argv1<>' ' THEN
       #No.FUN-AA0040  --Begin                                                  
       #LET g_wc=" axi00='",g_argv2,"'",                                        
       #         " AND axi01='",g_argv1,"'"                                     
       LET g_wc = " axi00 = '",g_argv1,"' AND axi03 = ",g_argv2,                
                  " AND axi04 = ",g_argv3," AND axi21 = '",g_argv4,"'"          
       #No.FUN-AA0040  --End       
       LET g_wc1=" 1=1"
    ELSE
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
       INITIALIZE g_axi.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
             axi01,axi02,axi03,axi04,axi05,axi06,axi07,axi10,  #NO.FUN-950048
             axi08,axi081,axi09,axiconf,axi11,axi12,           #FUN-9A0030
             axiuser,axigrup,aximodu,axidate
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(axi01) #單據性質
                   CALL q_aac(TRUE,TRUE,g_axi.axi01,'A','','','AGL') RETURNING g_axi.axi01     #TQC-670008
                   DISPLAY g_axi.axi01 TO axi01
                   NEXT FIELD axi01
                WHEN INFIELD(axi05) #族群編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_axa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axi05
                   NEXT FIELD axi05
                WHEN INFIELD(axi06)  
                   #--FUN-AA0005 start--
                   IF g_axi.axi08 = '1' THEN
                      CALL q_axa4(TRUE,TRUE,g_axi.axi06,g_axi.axi05)
                           RETURNING g_axi.axi06
                      DISPLAY BY NAME g_axi.axi06
                      NEXT FIELD axi06
                   ELSE
                   #---FUN-AA0005 end-- 
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_axa2"     
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO axi06
                      NEXT FIELD axi06
                   END IF        #AA0005
                OTHERWISE EXIT CASE
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
 
          ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axiuser', 'axigrup')
       CONSTRUCT g_wc1 ON axj13,axj02,axj03,axj04,axj05,axj06,axj07                          #FUN-D20048 add axj13
                     FROM s_axj[1].axj13,s_axj[1].axj02,s_axj[1].axj03,s_axj[1].axj04,       #FUN-D20048 add axj13
                          s_axj[1].axj05,s_axj[1].axj06,s_axj[1].axj07
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(axj03)
                   CALL q_m_aag2(TRUE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaz641)  #No.FUN-980025
                        RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO axj03 
                   NEXT FIELD axj03
                WHEN INFIELD(axj04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_aad2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axj04
                   NEXT FIELD axj04
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
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
 
    IF cl_null(g_wc1) OR g_wc1=" 1=1" THEN
       LET g_sql="SELECT axi01,axi00 FROM axi_file ", # 組合出 SQL 指令
           " WHERE ",g_wc CLIPPED, " ORDER BY axi01"
    ELSE
       LET g_sql="SELECT DISTINCT axi_file.axi01,axi_file.axi00 ",
           "  FROM axi_file,axj_file ", # 組合出 SQL 指令
           " WHERE axi01=axj01 AND axi00=axj00",
           "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
           " ORDER BY axi01"
    END IF
    PREPARE t001_pr FROM g_sql           # RUNTIME 編譯
    DECLARE t001_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_pr
 
    IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
       LET g_sql="SELECT COUNT(*) FROM axi_file ",
                 " WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT axi01) FROM axi_file,axj_file ",
                 " WHERE axi00=axj00 AND axi01=axj01",
                 " AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
    END IF
    PREPARE t001_precount FROM g_sql                           # row的個數
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(100)
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
         #FUN-A10135--add--str--
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t001_copy()
            END IF
         #FUN-A10135--add--end
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_z()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_axi.axi01 IS NOT NULL THEN
                  LET g_doc.column1 = "axi00"
                  LET g_doc.value1 = g_axi.axi00
                  LET g_doc.column2 = "axi01"
                  LET g_doc.value2 = g_axi.axi01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axj),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t001_v()
               IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
      CLOSE t001_cs
END FUNCTION
 
FUNCTION t001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axi.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t001_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN 
   END IF
   OPEN t001_count
   FETCH t001_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
      INITIALIZE g_axi.* TO NULL
   ELSE
      CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t001_fetch(p_flaxi)
   DEFINE p_flaxi     LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_abso      LIKE type_file.num10          #No.FUN-680098  integer
 
   CASE p_flaxi
       WHEN 'N' FETCH NEXT     t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'P' FETCH PREVIOUS t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'F' FETCH FIRST    t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'L' FETCH LAST     t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN '/'
           IF (NOT mi_no_ask) THEN
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
           FETCH ABSOLUTE g_jump t001_cs INTO g_axi.axi01,g_axi.axi00
           LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
      INITIALIZE g_axi.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flaxi
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_axi.* FROM axi_file            # 重讀DB,因TEMP有不被更新特性
    WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
   ELSE
      LET g_data_owner = g_axi.axiuser     #No.FUN-4C0048
      LET g_data_group = g_axi.axigrup     #No.FUN-4C0048
      CALL t001_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t001_show()
   DEFINE l_azi02,a,b     LIKE type_file.chr20   #No.FUN-680098 VARCHAR(20)
   DEFINE l_nml02         LIKE type_file.chr1000 #No.FUN-680098 VARCHAR(12)
   DEFINE l_axa09         LIKE axa_file.axa09    #FUN-950051  add   
 
   LET g_axi_t.*=g_axi.*   #MOD-790102
   #--FUN-AA0005 start-
   IF g_axi.axi08 = '1' THEN
      CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
   END IF
   #--FUN-AA0005 end-
   DISPLAY BY NAME g_axi.axioriu,g_axi.axiorig,
      g_axi.axi01,g_axi.axi02,g_axi.axi03,g_axi.axi04,g_axi.axi05,  #NO.FUN-750076 #FUN-950048拿掉axi21
      g_axi.axi06,g_axi.axi07,g_axi.axi09,g_axi.axi08,g_axi.axi081, #No.FUN-A90030
      g_axi.axi10,g_axi.axi11,g_axi.axi12,
      g_axi.axiconf,g_axi.axiuser,g_axi.aximodu,
      g_axi.axigrup,g_axi.axidate
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
    
   SELECT axz06 INTO g_axz06
     FROM axz_file
    WHERE axz01 = g_axi.axi06
   DISPLAY g_axz06 TO FORMONLY.axz06      #單頭
 
   SELECT azi04 INTO t_azi04         #No.CHI-6A0004 g_azi-->t_azi
     FROM azi_file
    WHERE azi01 = g_axz06
  
#FUN-AA0005 --Begin mark
#  SELECT axa09 INTO l_axa09 FROM axa_file 
#   WHERE axa01 = g_axi.axi05
#     AND axa02 = g_axi.axi06
#  IF l_axa09 = 'Y' THEN
#      LET g_axz03=''
#      SELECT axz03 INTO g_axz03    
#        FROM axz_file
#       WHERE axz01 = g_axi.axi06
#      
#       LET g_plant_new = g_axz03        #營運中心 #No.FUN-980025
#       LET g_plant_axz03 = g_axz03      #營運中心
#      CALL s_getdbs()
#      LET g_dbs_axz03 = g_dbs_new    #所屬DB
#      
#     #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
#      LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                  " WHERE aaz00 = '0'"
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#      PREPARE t001_pre_3 FROM g_sql
#      DECLARE t001_cur_3 CURSOR FOR t001_pre_3
#      OPEN t001_cur_3
#      FETCH t001_cur_3 INTO g_aaz641     #合併後帳別
#      IF cl_null(g_aaz641) THEN
#         CALL cl_err(g_axz03,'agl-601',1)
#      END IF
#  ELSE
#      LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  #目前DB 
#      LET g_plant_new = g_plant   #FUN-A50102
#      SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'    
#  END IF 
#FUN-AA0005 --End mark
#--------------------------------No.TQC-B80009--------------------------start
   IF (NOT cl_null(g_axi.axi05) AND NOT cl_null(g_axi.axi06)) THEN   
       CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03  
       CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641                
   END IF   
#--------------------------------No.TQC-B80009----------------------------end
   LET g_t1=s_get_doc_no(g_axi.axi01)        #No.FUN-560014
   CALL t001_b_fill(g_wc1)
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t001_a()           #輸入
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057  #No.FUN-680098 SMALLINT
DEFINE l_cmd       LIKE type_file.chr1000     #No.FUN-680098  VARCHAR(400)
 
   IF s_aglshut(0) THEN RETURN END IF

   #FUN-C70002--mark--str--
   #IF g_aza.aza26=2 THEN              #No.FUN-B70003   當使用功能別是"中國大陸"時，提示用戶無錄入功能      
   #  CALL cl_err('','agl-607',2)
   #  RETURN
   #END IF
   #FUN-C70002--mark--end--

   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_axj.clear()
   INITIALIZE g_axi.* TO NULL
   LET g_axi_t.* = g_axi.*
   LET g_axi.axiconf='N'
   LET g_axi.axi02 = g_today
  #LET g_axi.axi09 = 'N' #MOD-C40101 mark
   LET g_axi.axi09 = 'Y' #MOD-C40101 
   LET g_axi.axi08 = '1'
   LET g_axi.axi081 = '1'     #FUN-A90030
   LET g_axi.axiuser = g_user
   LET g_axi.axioriu = g_user #FUN-980030
   LET g_axi.axiorig = g_grup #FUN-980030
   LET g_axi.axigrup = g_grup               #使用者所屬群
   LET g_axi.axidate = g_today
   LET g_axi.axi11=0
   LET g_axi.axi12=0
   LET g_axi.axilegal= g_legal #FUN-980003 add g_legal
   CALL cl_opmsg('a')
   WHILE TRUE
      BEGIN WORK
      CALL t001_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0 CALL cl_err('',9001,0)
         INITIALIZE g_axi.* TO NULL EXIT WHILE
      END IF
      IF cl_null(g_axi.axi01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
     #CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"","axi_file","axi01",g_plant,"2",g_bookno)    #No.FUN-560014 #FUN-980094 #MOD-BC0289 mark 
      CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"","axi_file","axi01",g_plant,"2",g_axi.axi00) #MOD-BC0289 add
           RETURNING li_result,g_axi.axi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_axi.axi01
 
      INSERT INTO axi_file VALUES (g_axi.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","t001_ins_axi:",1)  #No.FUN-660123
         LET g_success = 'N' RETURN
      END IF
      COMMIT WORK
 
      CALL g_axj.clear()
      LET g_rec_b = 0
      SELECT axi00 INTO g_axi.axi00 FROM axi_file
       WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
      LET g_axi_t.* = g_axi.*
      CALL t001_b()
      MESSAGE ""
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t001_i(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1     #No.FUN-680098 VARCHAR(1)
    DEFINE l_n,l_cnt   LIKE type_file.num5     #No.FUN-680098 smallint
    DEFINE l_flag      LIKE type_file.chr1     #No.FUN-680098 VARCHAR(1)
    DEFINE l_msg       LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(30)
    DEFINE g_t1        LIKE aac_file.aac01     #No.FUN-560014        #No.FUN-680098 VARCHAR(5)
    DEFINE li_result   LIKE type_file.num5     #No.FUN-560014        #No.FUN-680098 smallint
    DEFINE l_axi02     STRING                  #MOD-930284 add
    DEFINE l_i         LIKE type_file.num5     #MOD-930284 add
 
    LET g_axi.axi21 = '00'     #版本,寫死塞入00   #FUN-760044 add #FUN-950048  #MOD-A40193 
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029 
 
   #-------------------------MOD-C80021---------------------(S)
   #----MOD-C80021--mark
   #INPUT BY NAME g_axi.axioriu,g_axi.axiorig,
   #         g_axi.axi01,g_axi.axi02,g_axi.axi03,g_axi.axi04,  #NO.FUN-750076 #FUN-950048 mod
   #         g_axi.axi05,g_axi.axi06,g_axi.axi07,g_axi.axi10,
   #         g_axi.axi08,g_axi.axi081,g_axi.axi09,g_axi.axi11,g_axi.axi12, #FUN-770086   #FUN-A90030
   #         g_axi.axiconf,g_axi.axiuser,g_axi.aximodu,
   #         g_axi.axigrup,g_axi.axidate
   #----MOD-C80021--mark
    INPUT BY NAME
             g_axi.axi01,g_axi.axi02,g_axi.axi03,g_axi.axi04,g_axi.axi08,
             g_axi.axi05,g_axi.axi06,g_axi.axi07,g_axi.axi10,g_axi.axi081,
             g_axi.axi09,g_axi.axi11,g_axi.axi12,g_axi.axiconf,g_axi.axiuser,
             g_axi.aximodu,g_axi.axigrup,g_axi.axidate,g_axi.axioriu,g_axi.axiorig
   #-------------------------MOD-C80021---------------------(E)
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t001_set_entry(p_cmd)
           CALL t001_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("axi01")
           #--FUN-AA0005 start-
           IF g_axi.axi08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           END IF
           #--FUN-AA0005 end-
 
        AFTER FIELD axi01
           IF NOT cl_null(g_axi.axi01) THEN
#             CALL s_check_no(g_sys,g_axi.axi01,g_axi01_t,"*","axi_file","axi01","")
              CALL s_check_no("agl",g_axi.axi01,g_axi01_t,"*","axi_file","axi01","")   #No.FUN-A40041
                   RETURNING li_result,g_axi.axi01
              DISPLAY BY NAME g_axi.axi01
              IF (NOT li_result) THEN
                  LET g_axi.axi01 = g_axi01_t
                  NEXT FIELD axi01
              END IF
 
        END IF
 
        AFTER FIELD axi02
           IF NOT cl_null(g_axi.axi02) THEN
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
               WHERE azn01 = g_axi.axi02
              IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN 
                 CALL cl_err('','agl-022',0) 
                 NEXT FIELD axi02 
              ELSE
                 LET g_axi.axi03 = l_azn02
                 LET g_axi.axi04 = l_azn04
              END IF
              DISPLAY BY NAME g_axi.axi03,g_axi.axi04
              LET g_axi_o.axi02 = g_axi.axi02
           END IF
           CALL t001_set_entry(p_cmd)      #MOD-930284 add
           CALL t001_set_no_entry(p_cmd)   #MOD-930284 add
 
        AFTER FIELD axi03
           IF g_axi.axi08 = '1' THEN
              LET l_axi02 = g_axi.axi02
              LET l_i = l_axi02.getLength()
              IF (l_axi02.subString(l_i-4,l_i-3)='12' AND
                  l_axi02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_axi.axi03 != l_azn02 AND g_axi.axi03 != l_azn02+1 THEN
                    CALL cl_err_msg("","agl-167",l_azn02 CLIPPED|| "|" || l_azn02+1 CLIPPED,0)
                    NEXT FIELD axi03
                 ELSE
                    IF g_axi.axi03 = l_azn02 THEN
                       LET g_axi.axi04 = 12
                    ELSE
                       LET g_axi.axi04 = 0
                    END IF
                    DISPLAY BY NAME g_axi.axi03,g_axi.axi04
                 END IF
              END IF
           END IF
 
        AFTER FIELD axi04
           IF g_axi.axi08 = '1' THEN
              LET l_axi02 = g_axi.axi02
              LET l_i = l_axi02.getLength()
              IF (l_axi02.subString(l_i-4,l_i-3)='12' AND
                  l_axi02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_axi.axi04 != 0 AND g_axi.axi04 != 12 THEN
                    CALL cl_err('','agl-166',0)
                    NEXT FIELD axi04
                 ELSE
                    IF g_axi.axi04 = 12 THEN
                       LET g_axi.axi03 = l_azn02
                    ELSE
                       LET g_axi.axi03 = l_azn02+1
                    END IF
                    DISPLAY BY NAME g_axi.axi03,g_axi.axi04
                 END IF
              END IF
           END IF
 
        AFTER FIELD axi05   #族群編號
           IF NOT cl_null(g_axi.axi05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file WHERE axa01=g_axi.axi05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 LET g_axi.axi05=g_axi_t.axi05
                 CALL cl_err(g_axi.axi05,'agl-223',0) NEXT FIELD axi05
                 NEXT FIELD axi05
              END IF
           ELSE                                        #FUN-930090 add
              CALL cl_err(g_axi.axi05,'mfg0037',0)     #FUN-930090 add
              NEXT FIELD axi05                         #FUN-930090 add
           END IF
           
        AFTER FIELD axi06   #上層公司
           IF NOT cl_null(g_axi.axi06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file
                             WHERE axa01=g_axi.axi05
                               AND axa02=g_axi.axi06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0 
              #--FUN-AA0005 start--
              ELSE
                  SELECT axa03 INTO g_axi.axi07
                    FROM axa_file
                   WHERE axa01=g_axi.axi05
                     AND axa02=g_axi.axi06
                  DISPLAY BY NAME g_axi.axi07
              #--FUN-AA0005 end--
              END IF
              IF l_cnt <=0  THEN
                #-----------------------MOD-C20016--------------------start
                 SELECT COUNT(*) INTO l_cnt FROM axb_file
                                WHERE axb01=g_axi.axi05
                                  AND axb04=g_axi.axi06
                 IF SQLCA.sqlcode THEN
                     LET l_cnt = 0
                 ELSE
                     SELECT axb05 INTO g_axi.axi07
                       FROM axb_file
                      WHERE axb01=g_axi.axi05
                        AND axb04=g_axi.axi06
                     DISPLAY BY NAME g_axi.axi07
                 END IF
                 IF l_cnt <=0 THEN
                #-----------------------MOD-C20016----------------------end
                    LET g_axi.axi06=g_axi_t.axi06
                    CALL cl_err(g_axi.axi06,'agl-223',0) NEXT FIELD axi06
                    NEXT FIELD axi06
                 END IF                                                       #MOD-C20016 add
              END IF   #MOD-B70103 ADD
#FUN-AA0005 --Begin mark
#             ELSE
#                SELECT axa03 INTO g_axi.axi07 
#                  FROM axa_file
#                 WHERE axa01=g_axi.axi05
#                   AND axa02=g_axi.axi06
#                IF cl_null(g_axi.axi07) THEN 
#                   CALL cl_err(g_axi.axi07,'agl-223',0) NEXT FIELD axi06
#                ELSE 
#                   DISPLAY BY NAME g_axi.axi07
#                END IF
#                #使用tiptop否(axz04)='N',表示為非tiptop公司,預設目前所在DB給他 
#                SELECT axz03,axz04 INTO g_axz03,g_axz04 FROM axz_file                    
#                 WHERE axz01 = g_axi.axi06                                               
#                IF g_axz04 = 'N' THEN 
#                   LET g_axz03=g_plant                                
#                   SELECT azp03 INTO g_dbs_new FROM azp_file                            
#                    WHERE azp01 = g_axz03                                               
#                   IF STATUS THEN LET g_dbs_new = NULL END IF                                                 
#                   LET g_plant_axz03 = g_axz03  #No.FUN-980025
#                   LET g_dbs_axz03 = s_dbstring(g_dbs_new)       
#                   LET g_plant_new = g_plant  #FUN-A50102
#                ELSE    
#                   SELECT axa09 INTO g_axa09 FROM axa_file
#                    WHERE axa01 = g_axi.axi05 AND axa02 = g_axi.axi06
#                   IF g_axa09 = 'N' THEN 
#                     SELECT azp03 INTO g_dbs_new FROM azp_file 
#                      WHERE azp01 = g_plant
#                     LET g_plant_new = g_plant   #FUN-A50102
#                   ELSE
#                    #FUN-A10135--mod--str--
#                    #SELECT azp03 INTO g_dbs_new FROM azp_file
#                    #   WHERE azp01 = g_plant
#                     SELECT azp03 INTO g_dbs_new FROM azp_file    #取上層公司DB
#                      WHERE azp01 = g_axz03
#                    #FUN-A10135--mod--end
#                     LET g_plant_new = g_axz03   #FUN-A50102
#                   END IF
#                     LET g_plant_axz03 = g_plant   #No.FUN-980025
#                     LET g_dbs_axz03 = s_dbstring(g_dbs_new)
#                END IF    
#               #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
#                LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                            " WHERE aaz00 = '0'" 
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#                PREPARE t001_pre_05 FROM g_sql  
#                DECLARE t001_cur_05 CURSOR FOR t001_pre_05 
#                OPEN t001_cur_05
#                FETCH t001_cur_05 INTO g_aaz641     #合併後帳別
#FUN-AA0005 --End mark
                 #--MOD-B70103 mark
                 #IF cl_null(g_aaz641) THEN
                 #   CALL cl_err(g_axz03,'agl-601',1)
                 #END IF
                 #--MOD-B70103 mark
                 CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03  #FUN-AA0005
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641                 #FUN-AA0005
                 #---MOD-B70103 start--
                 IF cl_null(g_aaz641) THEN
                    CALL cl_err(g_axz03,'agl-601',1)
                 END IF
				 #--MOD-B70103 end---
                 CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03  #FUN-AA0005
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641                 #FUN-AA0005
                 LET g_axi.axi00 = g_aaz641   #MOD-9C0458 add
                 SELECT axz06 INTO g_axz06
                   FROM axz_file
                  WHERE axz01 = g_axi.axi06
                 IF cl_null(g_axz06) THEN
                    CALL cl_err(g_axi.axi06,'afa-050',0)
                    NEXT FIELD axi06
                 ELSE 
                    DISPLAY  g_axz06 TO FORMONLY.axz06
                 END IF
              #END IF    #MOD-B70103 mark
           ELSE                                                       
              CALL cl_err(g_axi.axi06,'mfg0037',0)                    
              NEXT FIELD axi06                                        
           END IF 
 
        AFTER FIELD axi09
          IF NOT cl_null(g_axi.axi09) THEN
             IF g_axi.axi09 NOT MATCHES '[YN]' THEN
                NEXT FIELD axi09
             END IF
          END IF
            
        AFTER FIELD axi08
          IF cl_null(g_axi.axi08) THEN NEXT FIELD axi08 END IF  #FUN-AA0005
          IF NOT cl_null(g_axi.axi08) THEN
            #FUN-A90030--------------add start------------------
            #IF p_cmd='a' THEN
            #   IF g_axi.axi08 = '2' THEN
            #      CALL cl_err('','agl-227',1) 
            #      NEXT FIELD axi08
            #   END IF
            #END IF
            #FUN-A90030 ------------add end----------------------
            #IF g_axi.axi08 NOT MATCHES '[123]' THEN #FUN-770086    #FUN-B60143   Mark
             IF g_axi.axi08 NOT MATCHES '[123456]' THEN #FUN-770086 #FUN-B60143   Add
                NEXT FIELD axi08
             END IF
           #CHI-D20005--mark--
           ##-----------------------MOD-C80021-----------------------(S)
           # IF g_axi.axi08 = '2' THEN
           #    CALL cl_err('','axi-001',1)
           #    NEXT FIELD axi08
           # END IF
           ##-----------------------MOD-C80021-----------------------(E)
           #CHI-D20005--mark--
          END IF
          #FUN-A90030 -----------add start-------------------
          CALL t001_set_entry(p_cmd)
          CALL t001_set_no_entry(p_cmd)
          #FUN-A90030 ------------add end---------------------
           #--FUN-AA0005 start-
           IF g_axi.axi08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           END IF
           #--FUN-AA0005 end-
 
        AFTER INPUT
           LET g_axi.axiuser = s_get_data_owner("axi_file") #FUN-C10039
           LET g_axi.axigrup = s_get_data_group("axi_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(axi01) #單據性質
                 CALL q_aac(FALSE,TRUE,g_axi.axi01,'A','','','AGL') RETURNING g_axi.axi01  #TQC-670008
                 DISPLAY BY NAME g_axi.axi01
                 NEXT FIELD axi01
              WHEN INFIELD(axi05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_axi.axi05
                 DISPLAY BY NAME g_axi.axi05
 
                 SELECT azi04 INTO t_azi04          #No.CHI-6A0004 g_azi-->t_azi 
                   FROM azi_file
                  WHERE azi01 = g_axz06
 
                 NEXT FIELD axi05
              WHEN INFIELD(axi06)  
                 #--FUN-AA0005 start--
                 IF g_axi.axi08 = '1' THEN
                     CALL q_axa4(FALSE,TRUE,g_axi.axi06,g_axi.axi05)
                          RETURNING g_axi.axi06
                     DISPLAY BY NAME g_axi.axi06
                     NEXT FIELD axi06
                 ELSE
                 #---FUN-AA0005 end--
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axa2"     
                    LET g_qryparam.arg1 = g_axi.axi05
                    CALL cl_create_qry() RETURNING g_axi.axi06,g_axi.axi07
                    DISPLAY BY NAME g_axi.axi06
                    DISPLAY BY NAME g_axi.axi07
                    NEXT FIELD axi06
                 END IF         #FUN-AA0005
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
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
 
FUNCTION t001_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("axi01",TRUE)
   END IF
   IF p_cmd='a' THEN
      CALL cl_set_comp_entry("axi08",TRUE)
   END IF
   IF g_axi.axi08 = '1' THEN
      CALL cl_set_comp_entry("axi03,axi04",TRUE)
   END IF
  #FUN-A90030 ----------add start---------
   IF g_axi.axi08 = '2' THEN
      CALL cl_set_comp_entry("axi081",TRUE)
   END IF 
  #FUN-A90030 ---------add end------------ 
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)
   DEFINE l_axi02   STRING                 #MOD-930284 add
   DEFINE l_i       LIKE type_file.num5    #MOD-930284 add
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("axi01",FALSE)
   END IF
  #----------------------MOD-C80021------------mark
  #IF p_cmd='u' THEN
  #   CALL cl_set_comp_entry("axi08",FALSE)
  #END IF
  #----------------------MOD-C80021------------mark
   IF g_axi.axi08 = '1' THEN
      LET l_axi02 = g_axi.axi02
      LET l_i = l_axi02.getLength()
      IF NOT (l_axi02.subString(l_i-4,l_i-3)='12' AND
              l_axi02.subString(l_i-1,l_i)  ='31') THEN
         CALL cl_set_comp_entry("axi03,axi04",FALSE)
      END IF
   END IF
  #FUN-A90030 -----------add start----------
   IF g_axi.axi08 <> '2' THEN
      CALL cl_set_comp_entry("axi081",FALSE)
   END IF
  #FUN-A90030 -----------add end-------------

  #MOD-C40101---str---
   IF p_cmd='a' THEN
      IF g_axi.axi09='Y' THEN
         CALL cl_set_comp_entry("axi09",FALSE)
      END IF
   END IF
  #MOD-C40101---end---
END FUNCTION
 
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680098  smalint
    l_row,l_col     LIKE type_file.num5,  	  #分段輸入之行,列數 #No.FUN-680098   smallint
    l_n,l_cnt       LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint 
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098  VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,          #Esc結束INPUT ARRAY 否 #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680098 VARCHAR(1)
    l_b2            LIKE abh_file.abh11,          #No.FUN-680098  VARCHAR(30)
    l_qty	    LIKE aao_file.aao05,          #No.FUN-680098  dec(15,3)
    l_flag          LIKE type_file.num10,         #No.FUN-680098  integer 
    l_dir           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    l_jump          LIKE type_file.num5,          #判斷是否跳過AFTER ROW的處理   #No.FUN-680098   smallint
    k_n             LIKE type_file.num5,          #No.FUN-680098 smallint 
    l_allow_insert  LIKE type_file.chr1,          #可新增否   #No.FUN-680098  VARCHAR(1) 
    l_allow_delete  LIKE type_file.chr1,          #可刪除否   #No.FUN-680098  VARCHAR(1)
    l_axa09         LIKE axa_file.axa09           #獨立會科合并   #FUN-950051 add
 
    LET g_action_choice = ""

    #FUN-C70002--mark--str-- 
    #IF g_aza.aza26=2 THEN              #No.FUN-B70003   當使用功能別是"中國大陸"時，提示用戶無錄入功能
    #   CALL cl_err('','agl-607',2)
    #   RETURN
    #END IF
    #FUN-C70002--mark--end--

    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF cl_null(g_axi.axi01) THEN RETURN END IF
    IF g_axi.axiconf = 'Y' THEN CALL cl_err('','9022',0) RETURN END IF

    CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03 #FUN-AA0005
    CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641                #FUN-AA0005

#FUN-AA0005 --Begin mark
#   SELECT axa09 INTO l_axa09  FROM axa_file
#    WHERE axa01 = g_axi.axi05
#      AND axa02 = g_axi.axi06
#   IF l_axa09 = 'Y' THEN
#      LET g_axz03=''
#      SELECT axz03 INTO g_axz03    
#        FROM axz_file
#       WHERE axz01 = g_axi.axi06
#      LET g_plant_axz03 = g_axz03    #No.FUN-980025
#      LET g_plant_new = g_axz03      #營運中心
#      CALL s_getdbs()
#      LET g_dbs_axz03 = g_dbs_new    #所屬DB
#      
#     #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#      LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                  " WHERE aaz00 = '0'"
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#      PREPARE t001_pre FROM g_sql
#      DECLARE t001_cur CURSOR FOR t001_pre
#      OPEN t001_cur
#      FETCH t001_cur INTO g_aaz641     #合併後帳別
#      IF cl_null(g_aaz641) THEN
#          CALL cl_err(g_axz03,'agl-601',1)
#      END IF
#   ELSE 
#      LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  
#      LET g_plant_new = g_plant   #FUN-A50102
#      SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#   END IF 
#FUN-AB0046 --End mark
     
   #-TQC-AB0046-add-     
    SELECT azi04 INTO t_azi04      
      FROM azi_file
     WHERE azi01 = g_axz06
   #-TQC-AB0046-end-     

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT * FROM axj_file ",
                       " WHERE axj00=? AND axj01=? AND axj02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql
 
      INPUT ARRAY g_axj WITHOUT DEFAULTS FROM s_axj.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
            OPEN t001_cl USING g_axi.axi00,g_axi.axi01
            FETCH t001_cl INTO g_axi.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
               CLOSE t001_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_axj_t.* = g_axj[l_ac].*  #BACKUP
                OPEN t001_bcl USING g_axi.axi00,g_axi.axi01,g_axj_t.axj02
                IF STATUS THEN
                    CALL cl_err("OPEN t002_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                   FETCH t001_bcl INTO b_axj.*
                  #TQC-A50088---add---start---
                   IF cl_null(b_axj.axj05) THEN
                      LET b_axj.axj05 = ' '
                   END IF
                  #TQC-A50088---add---end---
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock axj',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t001_b_move_to()
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            ELSE
                LET p_cmd='a'  #輸入新資料
                INITIALIZE g_axj[l_ac].* TO NULL
                INITIALIZE b_axj.* TO NULL
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_axj[l_ac].* TO NULL      #900423
            LET b_axj.axj01=g_axi.axi01
            INITIALIZE g_axj_t.* TO NULL
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD axj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET g_success = 'Y'
           CALL t001_b_move_back()
           LET b_axj.axj00=g_axi.axi00
           LET b_axj.axjlegal=g_legal #FUN-980003 add g_legal
          #TQC-A50088---add---start---
           IF cl_null(b_axj.axj05) THEN
              LET b_axj.axj05 = ' '
           END IF
          #TQC-A50088---add---end---
           INSERT INTO axj_file VALUES(b_axj.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","axj_file",b_axj.axj01,b_axj.axj02,SQLCA.sqlcode,"","ins axj",1)  #No.FUN-660123
              CANCEL INSERT
           ELSE
              CALL t001_bu()
              IF g_success='Y' THEN COMMIT WORK
                                    MESSAGE 'INSERT O.K'
                               ELSE ROLLBACK WORK
                                    MESSAGE 'ROLLBACK'
              END IF
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD axj02                            #default 序號
            IF cl_null(g_axj[l_ac].axj02) OR
               g_axj[l_ac].axj02 = 0 THEN
                  SELECT max(axj02)+1 INTO g_axj[l_ac].axj02
                   FROM axj_file WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
                  IF cl_null(g_axj[l_ac].axj02) THEN
                      LET g_axj[l_ac].axj02 = 1
                  END IF
            END IF
 
        AFTER FIELD axj02                        #check 序號是否重複
            IF NOT cl_null(g_axj[l_ac].axj02) THEN
               IF g_axj[l_ac].axj02 != g_axj_t.axj02 THEN
                   SELECT count(*) INTO l_n FROM axj_file
                    WHERE axj00=g_axi.axi00
                      AND axj01=g_axi.axi01
                      AND axj02 = g_axj[l_ac].axj02
                   IF l_n > 0 THEN
                       LET g_axj[l_ac].axj02 = g_axj_t.axj02
                       CALL cl_err('',-239,0) NEXT FIELD axj02
                   END IF
               END IF
            END IF
 
        AFTER FIELD axj03   #科目編號
            IF NOT cl_null(g_axj[l_ac].axj03) THEN
               CALL t001_axj03('a')
               IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axj[l_ac].axj03,g_errno,0)
                    #FUN-B20004--begin
                    CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_axj[1].axj03,'23',g_aaz641)
                        RETURNING g_axj[l_ac].axj03 
                    #LET g_axj[l_ac].axj03=g_axj_t.axj03
                    #FUN-B20004--end
                     DISPLAY g_axj[l_ac].axj03 TO axj03               #No.MOD-490344
                    NEXT FIELD axj03
               END IF
            END IF
 
        AFTER FIELD axj04    #摘要
            IF NOT cl_null(g_axj[l_ac].axj04) THEN
               LET g_msg = g_axj[l_ac].axj04
               IF g_msg[1,1] = '.' THEN
                  LET g_msg = g_msg[2,10]
                  SELECT aad02 INTO g_axj[l_ac].axj04 FROM aad_file
                     WHERE aad01 = g_msg AND aadacti = 'Y'
                   DISPLAY g_axj[l_ac].axj04 TO axj04      #No.MOD-490344
                  NEXT FIELD axj04
               END IF
            END IF
 
 
        AFTER FIELD axj06  #借貸方
          IF NOT cl_null(g_axj[l_ac].axj06) THEN
             IF g_axj[l_ac].axj06 NOT MATCHES '[12]' THEN
                 NEXT FIELD axj06
             END IF
          END IF
 
        AFTER FIELD axj07
          LET g_axj[l_ac].axj07 = cl_digcut(g_axj[l_ac].axj07,t_azi04)   #No.FUN-590062    #No.CHI-6A0004 g_azi-->t_azi 
          IF NOT cl_null(g_axj[l_ac].axj07) THEN
             IF g_axj[l_ac].axj07 <= 0 THEN
               CALL cl_err(g_axj[l_ac].axj07,'aap-022',0)
               NEXT FIELD axj07
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_axj_t.axj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM axj_file
                 WHERE axj00 = g_axi.axi00
                   AND axj01 = g_axi.axi01
                   AND axj02 = g_axj_t.axj02
 
                IF SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("del","axj_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                CALL t001_bu()
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE t001_bcl
                COMMIT WORK
            END IF
       ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axj[l_ac].* = g_axj_t.*
            CLOSE t001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL t001_b_move_back()
         LET g_success = 'Y'
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axj[l_ac].axj02,-263,1)
            LET g_axj[l_ac].* = g_axj_t.*
         ELSE
            UPDATE axj_file SET axj02 = b_axj.axj02,
                                axj03 = b_axj.axj03,
                                axj04 = b_axj.axj04,
                                axj05 = b_axj.axj05,
                                axj06 = b_axj.axj06,
                                axj07 = b_axj.axj07,
                                axj13 = b_axj.axj13        #FUN-D20048 add
                         WHERE axj00=g_axi.axi00
                           AND axj01=g_axi.axi01 AND axj02=g_axj_t.axj02
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","axj_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","upd axj",1)  #No.FUN-660123
                           LET g_axj[l_ac].* = g_axj_t.*
                           LET g_success='N'
                        ELSE
                           CALL t001_bu()
                        END IF
             CLOSE t001_bcl
         END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac    #FUN-D30032 mark
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0) LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_axj[l_ac].* = g_axj_t.*
             #FUN-D30032--add--begin--
             ELSE
                CALL g_axj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end----
             END IF
             CLOSE t001_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE t001_bcl
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(axj02) AND l_ac > 1 THEN
                LET g_axj[l_ac].* = g_axj[l_ac-1].*
                LET g_axj[l_ac].axj02 = NULL
                NEXT FIELD axj02
            END IF
            IF INFIELD(axj04) AND l_ac > 1 THEN
               LET g_axj[l_ac].axj04 = g_axj[l_ac-1].axj04
                DISPLAY g_axj[l_ac].axj04 TO axj04         #No.MOD-490344
               NEXT FIELD axj04
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(axj03)
                   CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaz641)#No.FUN-980025
                        RETURNING g_axj[l_ac].axj03 
                   DISPLAY BY NAME g_axj[l_ac].axj03         
                   NEXT FIELD axj03
 
                WHEN INFIELD(axj04)     #查詢常用摘要
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aad2"
                     LET g_qryparam.default1 = g_axj[l_ac].axj04
                     CALL cl_create_qry() RETURNING g_axj[l_ac].axj04
                     DISPLAY BY NAME g_axj[l_ac].axj04
                     NEXT FIELD axj04
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      END INPUT
 
      LET g_axi.aximodu = g_user
      LET g_axi.axidate = g_today
      UPDATE axi_file SET aximodu = g_axi.aximodu,axidate = g_axi.axidate
       WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
      DISPLAY BY NAME g_axi.aximodu,g_axi.axidate
 
      UPDATE axi_file SET axidate = g_today WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
 
      #-->借貸不平
      IF cl_null(g_axi.axi11) THEN LET g_axi.axi11 = 0 END IF
      IF cl_null(g_axi.axi12) THEN LET g_axi.axi12 = 0 END IF
      IF g_axi.axi11 != g_axi.axi12 THEN
         CALL cl_err('','agl-060',1)
      END IF
      IF g_success='Y' THEN COMMIT WORK
                            MESSAGE 'UPDATE O.K'
                       ELSE ROLLBACK WORK
                            MESSAGE 'ROLLBACK'
      END IF
 
    CLOSE t001_bcl
    CALL t001_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t001_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_axi.axi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM axi_file ",
                  "  WHERE axi01 LIKE '",l_slip,"%' ",
                  "    AND axi01 > '",g_axi.axi01,"'"
      PREPARE t001_pb1 FROM l_sql 
      EXECUTE t001_pb1 INTO l_cnt       
      
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
         CALL t001_v()
         IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
         INITIALIZE g_axi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查科目名稱
FUNCTION t001_axj03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    #No.TQC-B70040  --Begin
    IF (NOT cl_null(g_axi.axi05) AND NOT cl_null(g_axi.axi06)) THEN
       CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03
       CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
    END IF 
    #No.TQC-B70040  --End
   #LET g_sql = "SELECT aag02,aag03,aag07,aagacti FROM ",g_dbs_axz03,"aag_file", #FUN-A50102
    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",   #FUN-A50102
                "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
                " WHERE aag01 = '",g_axj[l_ac].axj03,"'",                
                "   AND aag00 = '",g_aaz641,"'"                
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE t001_pre_1 FROM g_sql
    DECLARE t001_cur_1 CURSOR FOR t001_pre_1
    OPEN t001_cur_1
    FETCH t001_cur_1 INTO l_aag02,l_aag03,l_aag07,l_aagacti
 
    IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
 
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        #WHEN l_aag03 != '2'      LET g_errno = 'agl-201'   #CHI-9C0038
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    IF g_errno = ' ' OR p_cmd = 'd' THEN
       LET g_axj[l_ac].aag02 = l_aag02
        DISPLAY g_axj[l_ac].aag02 TO aag02            #No.MOD-490344
    END IF
END FUNCTION
 
FUNCTION t001_bu()
 
   SELECT SUM(axj07) INTO g_axi.axi11
     FROM axj_file
    WHERE axj01=g_axi.axi01 AND axj00=g_axi.axi00 AND axj06='1'
 
   SELECT SUM(axj07) INTO g_axi.axi12
     FROM axj_file
    WHERE axj01=g_axi.axi01 AND axj00=g_axi.axi00 AND axj06='2'
 
   IF cl_null(g_axi.axi11) THEN LET g_axi.axi11 = 0 END IF
   IF cl_null(g_axi.axi12) THEN LET g_axi.axi12 = 0 END IF
 
   LET g_axi.axi11 = cl_digcut(g_axi.axi11,t_azi04)   #No.FUN-590062   #No.CHI-6A0004 g_azi-->t_azi 
   LET g_axi.axi12 = cl_digcut(g_axi.axi12,t_azi04)   #No.FUN-590062   #No.CHI-6A0004 g_azi-->t_azi 
 
   UPDATE axi_file SET axi11=g_axi.axi11, axi12=g_axi.axi12
    WHERE axi01=g_axi.axi01 AND axi00=g_axi.axi00
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("upd","axi_file",g_axi.axi01,g_axi.axi00,STATUS,"","upd axi",1)  #No.FUN-660123
      RETURN
   END IF
   DISPLAY BY NAME g_axi.axi11,g_axi.axi12
END FUNCTION
 
FUNCTION t001_baskey()
DEFINE l_wc2    LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(200)
 
    CONSTRUCT g_wc1 ON axj13,axj02,axj03,axj04,axj05,axj06,axj07                         #FUN-D20048 add axj13
                  FROM s_axj[1].axj13,s_axj[1].axj02,s_axj[1].axj03,s_axj[1].axj04,      #FUN-D20048 add axj13
                       s_axj[1].axj05,s_axj[1].axj06,s_axj[1].axj07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
    ON ACTION controlp
          CASE
             WHEN INFIELD(axj03)
 
                CALL q_m_aag2(TRUE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaz641) #No.FUN-980025
                     RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO axj03 
                NEXT FIELD axj03
             WHEN INFIELD(axj04)     #查詢常用摘要
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aad2"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axj04
                NEXT FIELD axj04
 
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL t001_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t001_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2      LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(300)
 
    LET g_sql =
        "SELECT axj13,axj02,axj03,'',axj04,axj05,axj06,axj07 ",   #FUN-D20048 add axj13
        " FROM axj_file ",
        " WHERE axj01 ='",g_axi.axi01,"' ",
        "   AND axj00='",g_axi.axi00,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t001_pb FROM g_sql
    DECLARE axj_curs CURSOR FOR t001_pb
 
    CALL g_axj.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH axj_curs INTO g_axj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102
        LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
                    " WHERE aag01 = '",g_axj[g_cnt].axj03,"'",                
                    "   AND aag00 = '",g_aaz641,"'"                
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
        PREPARE t001_pre_2 FROM g_sql
        DECLARE t001_cur_2 CURSOR FOR t001_pre_2
        OPEN t001_cur_2
        FETCH t001_cur_2 INTO g_axj[g_cnt].aag02 
        
        IF SQLCA.sqlcode  THEN LET g_axj[g_cnt].aag02 = '' END IF
        IF SQLCA.sqlcode THEN 
           SELECT aag02 INTO g_axj[g_cnt].aag02 FROM aag_file
            WHERE aag01=g_axj[g_cnt].axj03
           IF SQLCA.sqlcode THEN LET g_axj[g_cnt].aag02 = ' ' END IF
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_axj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
#FUN-A10135--add--str--
FUNCTION t001_copy()
   DEFINE l_newno     LIKE axi_file.axi01,
          l_newdate   LIKE axi_file.axi02,
          l_oldno     LIKE axi_file.axi01
   DEFINE l_oldno1    LIKE axi_file.axi00
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_newaxi03  LIKE axi_file.axi03
   DEFINE l_newaxi04  LIKE axi_file.axi04
   DEFINE l_newaxi05  LIKE axi_file.axi05
   DEFINE l_newaxi06  LIKE axi_file.axi06
   DEFINE l_newaxi07  LIKE axi_file.axi07
   DEFINE l_newaxi08  LIKE axi_file.axi08    #MOD-C80021 add
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_aaz641    LIKE aaz_file.aaz641
   DEFINE l_azn02     LIKE azn_file.azn02
   DEFINE l_azn04     LIKE azn_file.azn04
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   IF g_axi.axi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #FUN-C70002--mark--str--
   #IF g_aza.aza26=2 THEN              #No.FUN-B70003   當使用功能別是"中國大陸"時，提示用戶無錄入功能
   #  CALL cl_err('','agl-607',2)
   #  RETURN
   #END IF
   #FUN-C70002--mark--end--

  #IF g_axi.axi08 <> '1' THEN  #MOD-BB0284 mark
   IF g_axi.axi08 = '2' THEN   #MOD-BB0284
      CALL cl_err('','axi-001',0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t001_set_entry('a')

   CALL cl_set_head_visible("","YES")
   INPUT l_newno,l_newdate,l_newaxi08,l_newaxi05,l_newaxi06      #MOD-C80021 add newaxi08
    FROM axi01,axi02,axi08,axi05,axi06                           #MOD-C80021 add axi08

       BEFORE INPUT
          CALL cl_set_docno_format("axi01")

       AFTER FIELD axi01
           IF NOT cl_null(l_newno) THEN
#             CALL s_check_no(g_sys,l_newno,"","*","axi_file","axi01","")
              CALL s_check_no("agl",l_newno,"","*","axi_file","axi01","")   #No.FUN-A40041
                   RETURNING li_result,l_newno
              DISPLAY l_newno TO axi01
              IF (NOT li_result) THEN
                  LET l_newno = g_axi01_t
                  NEXT FIELD axi01
              END IF
           END IF
       AFTER FIELD axi02
           IF cl_null(l_newdate) THEN NEXT FIELD axi02 END IF
           IF NOT cl_null(l_newdate) THEN
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                   WHERE azn01 = l_newdate
              IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN
                 CALL cl_err('','agl-022',0)
                 NEXT FIELD axi02
              ELSE LET l_newaxi03 = l_azn02
                   LET l_newaxi04 = l_azn04
              END IF
              DISPLAY l_newaxi03 TO axi03
              DISPLAY l_newaxi04 TO axi04
              LET g_axi_o.axi02 = l_newdate
           END IF
       AFTER FIELD axi05   #族群編號
           IF NOT cl_null(l_newaxi05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file WHERE axa01=l_newaxi05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 CALL cl_err(l_newaxi05,'agl-223',0) NEXT FIELD axi05
                 NEXT FIELD axi05
              END IF
           ELSE
              CALL cl_err(l_newaxi05,'mfg0037',0)
              NEXT FIELD axi05
           END IF

      #CHI-D20005--mark--
      ##-----------------------MOD-C80021-----------------------(S)
      # AFTER FIELD axi08
      #      IF NOT cl_null(l_newaxi08) THEN
      #         IF l_newaxi08 = '2' THEN
      #            CALL cl_err('','axi-001',1)
      #            NEXT FIELD axi08
      #         END IF
      #      END IF
      ##-----------------------MOD-C80021-----------------------(E)
      #CHI-D20005--mark--

       AFTER FIELD axi06   #上層公司
           IF NOT cl_null(l_newaxi06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file
                             WHERE axa01=l_newaxi05
                               AND axa02=l_newaxi06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0 
              #---FUN-AA0005 start-
              ELSE
                  SELECT axa03 INTO l_newaxi07
                    FROM axa_file
                   WHERE axa01=l_newaxi05
                     AND axa02=l_newaxi06
                  DISPLAY l_newaxi07 TO axi07
              #---FUN-AA0005 end---
              END IF
              IF l_cnt <=0  THEN
                 #--FUN-AA0005 start--#                                         
                 SELECT COUNT(*) INTO l_cnt FROM axb_file
                                WHERE axb01=l_newaxi05
                                  AND axb04=l_newaxi06
                 IF SQLCA.sqlcode THEN
                     LET l_cnt = 0
                 ELSE
                     SELECT axb05 INTO l_newaxi07
                       FROM axb_file
                      WHERE axb01=l_newaxi05
                        AND axb04=l_newaxi06
                     DISPLAY l_newaxi07 TO axi07
                 END IF
                 IF l_cnt <=0 THEN
                 #--FUN-AA0005 end---
                    CALL cl_err(l_newaxi06,'agl-223',0) NEXT FIELD axi06
                    NEXT FIELD axi06
                 ELSE
#FUN-AA0005 --Begin mark
#                   SELECT axa03 INTO l_newaxi07
#                     FROM axa_file
#                    WHERE axa01=l_newaxi05
#                      AND axa02=l_newaxi06
#                   IF cl_null(l_newaxi07) THEN
#                      CALL cl_err(l_newaxi07,'agl-223',0) NEXT FIELD axi06
#                   ELSE
#                      DISPLAY l_newaxi07 TO axi07
#                   END IF
#FUN-AA0005 --End mark
                 END IF             #FUN-AA0005
              END IF                #FUN-AA0005
              CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03 #FUN-AA0005  
              CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641                #FUN-AA0005
#FUN-AA0005 --Begin mark
#                #使用tiptop否(axz04)='N',表示為非tiptop公司,預設目前所在DB給他
#                SELECT axz03,axz04 INTO g_axz03,g_axz04 FROM axz_file
#                 WHERE axz01 = l_newaxi06
#                IF g_axz04 = 'N' THEN
#                   LET g_axz03=g_plant
#                   SELECT azp03 INTO g_dbs_new FROM azp_file
#                    WHERE azp01 = g_axz03
#                   IF STATUS THEN LET g_dbs_new = NULL END IF
#                   LET g_dbs_axz03 = s_dbstring(g_dbs_new)
#                   LET g_plant_new = g_plant   #FUN-A50102
#                ELSE
#                   SELECT axa09 INTO g_axa09 FROM axa_file
#                    WHERE axa01 = l_newaxi05 AND axa02 = l_newaxi06
#                   IF g_axa09 = 'N' THEN
#                     SELECT azp03 INTO g_dbs_new FROM azp_file
#                      WHERE azp01 = g_plant
#                     LET g_plant_new = g_plant   #FUN-A50102
#                   ELSE
#                     SELECT azp03 INTO g_dbs_new FROM azp_file    #取上層公司DB
#                      WHERE azp01 = g_axz03
#                     LET g_plant_new = g_axz03   #FUN-A50102
#                   END IF
#                     LET g_dbs_axz03 = s_dbstring(g_dbs_new)
#                END IF
#               #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#                LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                            " WHERE aaz00 = '0'"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#                PREPARE t001_sel_aaz641 FROM g_sql
#                EXECUTE t001_sel_aaz641 INTO g_aaz641   #合并後帳別
#FUN-AA0005 --End mark
                 IF cl_null(g_aaz641) THEN
                    CALL cl_err(g_axz03,'agl-601',1)
                 END IF
                 SELECT axz06 INTO g_axz06
                   FROM axz_file
                  WHERE axz01 = l_newaxi06
                 IF cl_null(g_axz06) THEN
                    CALL cl_err(l_newaxi06,'afa-050',0)
                    NEXT FIELD axi06
                 ELSE
                    DISPLAY  g_axz06 TO FORMONLY.axz06
                 END IF
#             END IF     #FUN-AA0005 mark
              BEGIN WORK
             #CALL s_auto_assign_no("agl",l_newno,l_newdate,"","axi_file","axi01",g_dbs,"2",g_aaz641)   #FUN-A50102
              CALL s_auto_assign_no("agl",l_newno,l_newdate,"","axi_file","axi01",g_plant,"2",g_aaz641)    #FUN-A50102
                        RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 NEXT FIELD axi01
                 END IF
              DISPLAY l_newno TO axi01
           ELSE
              CALL cl_err(l_newaxi06,'mfg0037',0)
              NEXT FIELD axi06
           END IF
       ON ACTION controlp
          CASE
             WHEN INFIELD(axi01) #單據性質
                 CALL q_aac(FALSE,TRUE,l_newno,'A','','','AGL') RETURNING l_newno
                 DISPLAY l_newno TO axi01
                 NEXT FIELD axi01
             WHEN INFIELD(axi05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING l_newaxi05
                 DISPLAY l_newaxi05 TO axi05
                 SELECT azi04 INTO t_azi04
                   FROM azi_file
                  WHERE azi01 = g_axz06
                 NEXT FIELD axi05
             WHEN INFIELD(axi06)
                 #--FUN-AA0005 start--
                 IF g_axi.axi08 = '1' THEN
                     CALL q_axa4(FALSE,TRUE,g_axi.axi06,g_axi.axi05)
                          RETURNING g_axi.axi06
                     DISPLAY BY NAME g_axi.axi06
                     NEXT FIELD axi06
                 ELSE
                 #---FUN-AA0005 end--
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axa2"
                    LET g_qryparam.arg1 = l_newaxi05
                    CALL cl_create_qry() RETURNING l_newaxi06,l_newaxi07
                    DISPLAY l_newaxi06 TO axi06
                    DISPLAY l_newaxi07 TO axi07
                    NEXT FIELD axi06
                 END IF       #FUN-AA0005
              OTHERWISE EXIT CASE
           END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()


   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_axi.axi01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y
   SELECT * FROM axi_file         #單頭複製
       WHERE axi01=g_axi.axi01
         AND axi00=g_axi.axi00
       INTO TEMP y

   UPDATE y
       SET axi01=l_newno,    #新的鍵值
           axi00=g_aaz641,   #新的鍵值
           axi02=l_newdate,  #新的鍵值
           axi03=l_newaxi03, #新的鍵值
           axi04=l_newaxi04, #新的鍵值
           axi05=l_newaxi05, #新的鍵值
           axi06=l_newaxi06, #新的鍵值
           axi07=l_newaxi07, #新的鍵值
           axiconf = 'N',
           axiuser=g_user,   #資料所有者
           axigrup=g_grup,   #資料所有者所屬群
           aximodu=NULL,     #資料修改日期
           axidate=g_today   #資料建立日期

   INSERT INTO axi_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axi_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
   DROP TABLE x
   SELECT * FROM axj_file         #單身複製
    WHERE axj01=g_axi.axi01
      AND axj00=g_axi.axi00
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   UPDATE x SET axj01=l_newno,
                axj00=g_aaz641
   INSERT INTO axj_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      ROLLBACK WORK






      CALL cl_err3("ins","axj_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   ELSE
       COMMIT WORK
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

   LET l_oldno = g_axi.axi01
   LET l_oldno1 = g_axi.axi00
   SELECT axi_file.* INTO g_axi.* FROM axi_file WHERE axi01 = l_newno AND axi00 = g_aaz641
   CALL t001_u()
   CALL t001_b()
   #SELECT axi_file.* INTO g_axi.* FROM axi_file WHERE axi01 = l_oldno AND axi00 = l_oldno1 #FUN-C30027
   #CALL t001_show()  #FUN-C30027

END FUNCTION
#FUN-A10135--add--end

 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axj TO s_axj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
         IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
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
      #FUN-A10135--add--str--
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #FUN-A10135--add--end
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t001_b_move_to()
   LET g_axj[l_ac].axj02 = b_axj.axj02
   LET g_axj[l_ac].axj03 = b_axj.axj03
   LET g_axj[l_ac].axj04 = b_axj.axj04
   LET g_axj[l_ac].axj05 = b_axj.axj05
   LET g_axj[l_ac].axj06 = b_axj.axj06
   LET b_axj.axj07 = cl_digcut(b_axj.axj07,t_azi04)   #No.FUN-590062       #No.CHI-6A0004 g_azi-->t_azi 
   LET g_axj[l_ac].axj07 = b_axj.axj07
   LET g_axj[l_ac].axj13 = b_axj.axj13    #FUN-D20048 add
END FUNCTION
 
FUNCTION t001_b_move_back()
   LET b_axj.axj01 = g_axi.axi01
   LET b_axj.axj02 = g_axj[l_ac].axj02
   LET b_axj.axj03 = g_axj[l_ac].axj03
   LET b_axj.axj04 = g_axj[l_ac].axj04
   LET b_axj.axj05 = g_axj[l_ac].axj05
   LET b_axj.axj06 = g_axj[l_ac].axj06
   LET g_axj[l_ac].axj07 = cl_digcut(g_axj[l_ac].axj07,t_azi04)   #No.FUN-590062       #No.CHI-6A0004 g_azi-->t_azi 
   LET b_axj.axj07 = g_axj[l_ac].axj07
   LET b_axj.axj13 = g_axj[l_ac].axj13    #FUN-D20048 add
END FUNCTION
 
FUNCTION t001_u()
    DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)

    #FUN-C70002--mark--str-- 
    #IF  g_aza.aza26=2 THEN              #No.FUN-B70003   當使用功能別是"中國大陸"時，提示用戶無錄入功能
    #  CALL cl_err('','agl-607',2)
    #  RETURN
    #END IF
    #FUN-C70002--mark--str-- 

    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axi.axi01) THEN CALL cl_err('',-400,2) RETURN END IF
    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF g_axi.axiconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_axi.axiconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
 
    LET g_success = 'Y'
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_axi01_t = g_axi.axi01
    LET g_axi_o.* = g_axi.*
    BEGIN WORK
    OPEN t001_cl USING g_axi.axi00,g_axi.axi01
    FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    WHILE TRUE
        LET g_axi01_t = g_axi.axi01
        LET g_axi.aximodu=g_user
        LET g_axi.axidate=g_today
        CALL t001_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_axi.*=g_axi_t.*
            CALL t001_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_axi.axi01 != g_axi01_t THEN            # 更改單號
            UPDATE axj_file SET axj01 = g_axi.axi01
                WHERE axj00 = g_axi.axi00
                AND axj01 = g_axi01_t      #No.TQC-950063
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","axj_file",g_axi.axi00,"",SQLCA.sqlcode,"","abb",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
            LET g_errno = TIME
            LET g_msg = 'Chg No:',g_axi.axi01
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal
               VALUES('aglt001',g_user,g_today,g_errno,g_axi01_t,g_msg,g_plant,g_legal)  #FUN-980003 add g_palnt,g_legal
        END IF
        UPDATE axi_file SET axi_file.* = g_axi.*
            WHERE axi00=g_axi.axi00 AND axi01 = g_axi01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","axi_file",g_axi_t.axi00,g_axi_t.axi01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_r()
    DEFINE k_n      LIKE type_file.num5,         #No.FUN-680098  smallint
           l_flag   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
    DEFINE l_cnt    LIKE type_file.num5          #FUN-930144       

    #FUN-C70002--mark--str-- 
    #IF g_aza.aza26=2 THEN              #No.FUN-B70003   當使用功能別是"中國大陸"時，提示用戶無錄入功能
    #  CALL cl_err('','agl-607',2)
    #  RETURN
    #END IF
    #FUN-C70002--mark--end-- 

    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axi.axi01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF g_axi.axiconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_axi.axiconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t001_cl USING g_axi.axi00,g_axi.axi01
    FETCH t001_cl INTO g_axi.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
       CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    LET g_axi_o.* = g_axi.*
    LET g_axi_t.* = g_axi.*
    CALL t001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "axi00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_axi.axi00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "axi01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_axi.axi01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       SELECT COUNT(*) INTO k_n FROM axj_file
        WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
       IF k_n > 0 THEN
          DELETE FROM axj_file WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
          IF SQLCA.sqlcode THEN
          CALL cl_err3("del","axj_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","(t001_r:delete axj)",1)  #No.FUN-660123
          LET g_success='N'  
          END IF
       END IF
       DELETE FROM axi_file WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","(t001_r:delete axi)",1)  #No.FUN-660123
          LET g_success='N' 
       END IF
       INITIALIZE g_axi.* TO NULL
       IF g_success = 'Y' THEN
          COMMIT WORK
          LET g_axi_t.* = g_axi.*
          CALL g_axj.clear()
          OPEN t001_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t001_cs
             CLOSE t001_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH t001_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t001_cs
             CLOSE t001_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t001_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t001_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t001_fetch('/')
          END IF
       ELSE
          ROLLBACK WORK
          LET g_axi.* = g_axi_t.*
       END IF
    END IF
    CALL t001_show()
END FUNCTION
 
FUNCTION t001_y()
   DEFINE l_axi01_old           LIKE axi_file.axi01
   DEFINE only_one              LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   DEFINE l_cmd                 LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
 
   IF s_aglshut(0) THEN RETURN END IF
#CHI-C30107 ------------- add ----------- begin
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   IF g_axi.axiconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='Y'    THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ------------- add ----------- end
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   SELECT * INTO g_axi.* FROM axi_file
    WHERE axi00=g_axi.axi00 AND axi01 = g_axi.axi01
   IF g_axi.axiconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='Y'    THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM axj_file
    WHERE axj00=g_axi.axi00 AND axj01=g_axi.axi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF cl_confirm('axm-108') THEN  #CHI-C30107 mark
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_axi.axi00,g_axi.axi01
      FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      IF g_axi.axi09='N' AND (g_axi.axi11<>g_axi.axi12) THEN
         CALL cl_err('','agl-060',1)
         LET g_success='N'
      END IF
      IF g_success = 'Y' THEN
         UPDATE axi_file SET axiconf='Y'
                              #axi13 = g_newno  #FUN-930144  #FUN-960003 mark
          WHERE axi00=g_axi.axi00 AND axi01=g_axi.axi01
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("upd","axi_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","upd axi_file",1)  #No.FUN-660123
                LET g_success='N'
             END IF
      END IF
 
      CLOSE t001_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      SELECT * INTO g_axi.* FROM axi_file
       WHERE axi00=g_axi.axi00 AND axi01 = g_axi.axi01
      DISPLAY BY NAME g_axi.axiconf
#  END IF  #CHI-C30107 mark
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION
 
FUNCTION t001_z()
   DEFINE l_axi01_old LIKE axi_file.axi01
   DEFINE only_on     LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
   DEFINE l_amt       LIKE abg_file.abg072
   DEFINE l_cnt       LIKE type_file.num5     #FUN-930144
 
   IF s_aglshut(0) THEN RETURN END IF
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   SELECT * INTO g_axi.* FROM axi_file
           WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
   IF g_axi.axiconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='N' THEN RETURN END IF
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_axi.axi00,g_axi.axi01
      FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      UPDATE axi_file SET axiconf='N'
       WHERE axi00=g_axi.axi00 AND axi01=g_axi.axi01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","axi_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
      CLOSE t001_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
      CALL cl_cmmsg(1)
      END IF
   END IF
   SELECT * INTO g_axi.* FROM axi_file WHERE axi01=g_axi.axi01
   DISPLAY BY NAME g_axi.axiconf
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#CHI-C80041---begin
FUNCTION t001_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axi.axi01) OR cl_null(g_axi.axi00) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t001_cl USING g_axi.axi00,g_axi.axi01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_axi.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t001_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_axi.axiconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_axi.axiconf)   THEN 
        LET l_chr=g_axi.axiconf
        IF g_axi.axiconf='N' THEN 
            LET g_axi.axiconf='X' 
        ELSE
            LET g_axi.axiconf='N'
        END IF
        UPDATE axi_file
            SET axiconf=g_axi.axiconf,  
                aximodu=g_user,
                axidate=g_today
            WHERE axi00=g_axi.axi00
              AND axi01=g_axi.axi01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","axi_file",g_axi.axi01,"",SQLCA.sqlcode,"","",1)  
            LET g_axi.axiconf=l_chr 
        END IF
        DISPLAY BY NAME g_axi.axiconf 
   END IF
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_axi.axi01,'V')
 
END FUNCTION
#CHI-C80041---end

