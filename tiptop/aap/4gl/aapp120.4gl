# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aapp120.4gl
# Descriptions...: 驗收單贖單發票修改作業
# Date & Author..: 94/04/27 By Jackson
#                  1.增加show出料號,2.修改發票號碼時,check若此發票號碼已存在
#                  apa_file,則不可修改
# Modify.........: 97/05/12 By Danny 非贖單時, 詢問是否更新同一廠商發票號碼
# Modify.........: 02/10/03 By Kammy 
#                           aapp120 g_argv0='1' 驗收單贖單發票修改作業
#                           aapp121 g_argv0='2' 驗收單贖單發票修改作業(沖暫估)
# Modify.........: No:8494 03/10/16 By Kitty 開窗部份沒有控制好
# Modify.........: No.8456 04/07/07 By Kammy 應排除作廢入庫單
# Modify.........: No.9405 04/07/07 By Kammy 應排除作廢收貨單
# Modify.........: No.8054 04/07/07 By Kammy 在輸入發票後也要檢查是否已存在apa
# Modify.........: No.8801 04/07/07 By Kammy 只抓入庫單資料
# Modify.........: No.MOD-480609 04/09/02 ching 清除"發票號碼"後,相同發票未清除
# Modify.........: No.MOD-530466 05/03/30 By saki 發票號碼更新為其他號碼,原發票沒有被其他入庫單使用,應要清除
# Modify.........: No.MOD-530734 05/04/04 By Nicola 若L/C否為"Y"，則發票號碼需與aapt810的提單編號中
# Modify.........: No.MOD-540038 05/04/22 By Nicola 已沖暫估的資料不應該再query出現
# Modify ........: No.MOD-540169 05/08/08 By ice 以大陸的情況，發票維護時優先執行gapi140
# Modify.........: No.MOD-590457 05/10/20 By Smapmin 已沖暫估資料不可在出現於aapp121
# Modify.........: No.TQC-5B0020 05/11/24 By Smapmin "已確認"入庫單才可作業
# Modify.........: NO.TQC-5B0091 05/11/16 BY yiting 建議單身加入採購單,項次                                                                       
# Modify.........: No.MOD-5C0025 05/12/06 By Smapmin 資料已轉沖暫估應付又出現在暫估發票匹配作業中
# Modify.........: No.MOD-620031 06/02/14 By Smapmin 字串由500放大到1500
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.MOD-630104 06/03/30 By Smapmin 修改判斷舊發票是否對應其他單子的依據
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670105 06/07/28 By Smapmin 單身多一個判斷收貨發票是否存在的判斷
# Modify.........: No.MOD-680026 06/08/07 By Smapmin 修正MOD-590457
# Modify.........: No.FUN-680110 06/08/29 By Sarah 暫估應付功能調整
# Modify.........: No.FUN-690028 06/09/19 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0047 06/11/08 By rainy 單身加廠商簡稱，入庫量，單價、金額
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.MOD-720024 07/03/01 By Smapmin 所輸入的發票編號不可存在於 apk_file 中
# Modify.........: No.MOD-760141 07/07/03 By Smapmin 不同廠商不可開同一發票
# Modify.........: No.CHI-790035 07/10/08 By Smapmin 修正FUN-6A0047加入的單價/金額
# Modify.........: No.TQC-7B0083 07/12/10 By Carrier 修改暫估功能
# Modify.........: No.MOD-810225 08/01/31 By Smapmin 入庫量應以入庫單+項次為主
# Modify.........: No.CHI-830022 08/03/19 By Smapmin 只要發票仍存在收貨單身,則不可刪除rvw_file
# Modify.........: No.CHI-840053 08/05/05 By Smapmin ON ROW CHANGE後要先開輸入發票的窗,再UPDATE rvb22,以避免發票金額帶不出來
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-860175 08/06/26 By Sarah 當單身輸入完發票後,執行"確定",顯示aap-267時,選擇"是"之後,單身不應被清空
# Modify.........: No.MOD-960171 09/06/15 By baofei 修改MOD-860175給l_flag賦初值'N' 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-990204 09/10/14 By Carrier aapp120僅care台灣版的內容,不去判斷地區別
# Modify.........: No.FUN-990087 09/10/14 By sabrina 新增匯出Excel功能
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
#                                            QBE条件新增来源机构,控制在同一法人下，资料来源中心隐藏 
# Modify.........: No:TQC-990033 09/11/18 By Sarah 正式區程式有誤,重新過單
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A60056 10/06/18 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-A70139 10/07/30 By lutingting 修正FUN-A60056問題
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:MOD-B50120 11/05/13 By Dido 單身維護時若輸入 E/e 會啟動匯出 EXCEL,調整 ON ACTION name 
# Modify.........: No:CHI-820005 11/05/26 By zhangweib 檢查發票號碼是否有重複時,應多判斷已存在的發票資料其發票日期年度是否為今年,若是的話才卡住.
# Modify.........: No:TQC-B80224 11/09/07 By guoch 入庫單號、採購單號、廠商進行開窗處理
# Modify.........: No.MOD-BA0049 11/10/07 By Sarah SELECT rvb_file/rvv_file 應該要排除rvb89='Y'/rvv89='Y' VMI收貨入庫資料  
# Modify.........: No:TQC-BA0068 11/10/14 By wujie 支持无采购无收货单的入库单产生应付
# Modify.........: No.FUN-BA0065 11/11/04 By pauline 是流通業時，另加一組開窗，內容含虛擬入庫單的資料
# Modify.........: No.MOD-BB0123 11/11/14 By Polly 調整年份抓取條件判斷
# Modify.........: No.FUN-BB0001 11/12/12 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.TQC-C20200 12/02/17 By wangrr 修改l_sql類型為STRING
# Modify.........: No.TQC-BB0163 12/03/19 By yinhy 單身入庫單需過濾經營方式必須為經銷類型才可以錄入發票
# Modify.........: No.MOD-C90224 12/10/31 By Polly 增加trainsation的架構，按放棄則不寫入發票檔rvw_file
# Modify.........: No.MOD-CC0158 12/12/18 By Polly ROLLBACK WORK後需離開INPUT段
# Modify.........: No.MOD-D10123 13/01/15 By Polly 增加發票重覆檢查控卡

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ac      LIKE type_file.num5,   #No.FUN-690028 SMALLINT               
        g_wc      string,  #No.FUN-580092 HCN
        g_wc1     string,  #FUN-A60056
       g_rvv     DYNAMIC ARRAY OF RECORD
                    rvvplant LIKE rvv_file.rvvplant,   #FUN-A60056
                    rvv09   LIKE rvv_file.rvv09,
                    rvv06   LIKE rvv_file.rvv06,
                    pmc03   LIKE pmc_file.pmc03, #FUN-6A0047
                    rvb05   LIKE rvb_file.rvb05,      #96-07-13 modify
                    rvv36   LIKE rvv_file.rvv36,      #NO.TQC-5B0091
                    rvv37   LIKE rvv_file.rvv37,      #NO.TQC-5B0091
                    rvv01   LIKE rvv_file.rvv01,
                    rvv02   LIKE rvv_file.rvv02,
                    rvv87   LIKE rvv_file.rvv87,  #MOD-810225
                    rvv04   LIKE rvv_file.rvv04,
                    rvv05   LIKE rvv_file.rvv05,
                    rva04b  LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
                    x       LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)   #FUN-670105
                    rvb22b  LIKE rvb_file.rvb22,
                    rvb10   LIKE rvb_file.rvb10,  #FUN-6A0047
                    rvb88   LIKE rvb_file.rvb88   #FUN-6A0047
 
                 END RECORD,
       g_rvv_o   RECORD
                    rvvplant LIKE rvv_file.rvvplant,   #FUN-A60056
                    rvv09   LIKE rvv_file.rvv09,
                    rvv06   LIKE rvv_file.rvv06,
                    pmc03   LIKE pmc_file.pmc03, #FUN-6A0047
                    rvb05   LIKE rvb_file.rvb05,      #96-07-13 modify
                    rvv36   LIKE rvv_file.rvv36,      #NO.TQC-5B0091
                    rvv37   LIKE rvv_file.rvv37,      #NO.TQC-5B0091
                    rvv01   LIKE rvv_file.rvv01,
                    rvv02   LIKE rvv_file.rvv02,
                    rvv87   LIKE rvv_file.rvv87,  #MOD-810225
                    rvv04   LIKE rvv_file.rvv04,
                    rvv05   LIKE rvv_file.rvv05,
                    rva04b  LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
                    x       LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)   #FUN-670105
                    rvb22b  LIKE rvb_file.rvb22,
                    rvb10   LIKE rvb_file.rvb10,  #FUN-6A0047
                    rvb88   LIKE rvb_file.rvb88   #FUN-6A0047
 
                 END RECORD,
       g_rvb_key DYNAMIC ARRAY OF RECORD rvb01 LIKE rvb_file.rvb01,rvb02 LIKE rvb_file.rvb02 END RECORD, 
       g_unique_key DYNAMIC ARRAY OF RECORD rvb01 LIKE rvb_file.rvb01,rvb02 LIKE rvb_file.rvb02 END RECORD, 
       g_rec_b   LIKE type_file.num5,    #單身筆數  #No.FUN-690028 SMALLINT
       g_argv0   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_chr     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_cnt     LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE g_msg     LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE source    LIKE azp_file.azp01    #No.FUN-690028 VARCHAR(10)     #FUN-630043
DEFINE g_azw01   LIKE azw_file.azw01    #No.FUN-A60056
 
MAIN
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                 #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv0  = ARG_VAL(1)              #1.非沖暫估 2.沖暫估
 
   IF g_argv0 = '1' THEN 
      LET g_prog = 'aapp120'
   ELSE
      LET g_prog = 'aapp121'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_aza.aza26 = '2' THEN
      CALL cl_err('','gap-201',1)
      EXIT PROGRAM 
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
   LET p_row = 3 LET p_col = 8
 
   OPEN WINDOW aapp120_w AT p_row,p_col
     WITH FORM "aap/42f/aapp120" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   # 2004/06/02 共用程式時呼叫
   CALL cl_set_locale_frm_name("aapp120")
   CALL cl_ui_init()
 
  #CALL cl_set_comp_visible("source,azp02",FALSE)   #FUN-990031   #FUN-A60056
 
   CALL cl_opmsg('z')
 
   CALL p120_b()                          #接受選擇
 
  #FUN-A60056--mark--str--
  #IF g_aza.aza53='Y' AND source!=g_plant THEN
  #   DATABASE g_dbs      
  #   CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
  #END IF
  #FUN-A60056--mark--end
   CLOSE WINDOW p120_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
END MAIN
 
#將資料選出, 並進行挑選
FUNCTION p120_b()
DEFINE
    l_n             LIKE type_file.num5,                    #screen array no  #No.FUN-690028 SMALLINT
    l_i,l_cnt       LIKE type_file.num5,                    #screen array no  #No.FUN-690028 SMALLINT
    l_sql           STRING,                                 #RDSQL STATEMENT  #No.FUN-690028 VARCHAR(300) #MOD-D10123 mod char1000 -> STRING
    l_rvb04         LIKE rvb_file.rvb04,
    l_rvb03         LIKE rvb_file.rvb03,
    l_rva05         LIKE rva_file.rva05,
    l_als05         LIKE als_file.als05,
    l_time1         LIKE type_file.chr5,   #No.FUN-690028 VARCHAR(5)
    l_rvv04         LIKE rvv_file.rvv04,   #MOD-630104
    g_rva05         LIKE rva_file.rva05,   #MOD-760141
    l_flag          LIKE type_file.chr1    #MOD-860175 add
 
   DEFINE l_azp02   LIKE azp_file.azp02  #FUN-630043
   DEFINE l_azp03   LIKE azp_file.azp03  #FUN-630043
   DEFINE l_year    LIKE type_file.num5  #CHI-820005
   DEFINE l_azw04   LIKE azw_file.azw04  #FUN-BA0065 add
   DEFINE l_rva00   LIKE rva_file.rva00   #MOD-D10123 add
   DEFINE l_rvw02   LIKE rvw_file.rvw02   #MOD-BB0123 add
   DEFINE l_rvw03   LIKE rvw_file.rvw03   #MOD-D10123 add
   DEFINE l_rvu21   LIKE rvu_file.rvu21   #TQC-BB0163 add

   WHILE TRUE
      LET g_action_choice = ""
      IF s_aapshut(0) THEN EXIT WHILE END IF
      
      CLEAR FORM
 
    #FUN-A60056--mark--str--
    # LET source=g_plant 
    # LET l_azp02=''
    # DISPLAY BY NAME source
    # SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=source
    # DISPLAY l_azp02 TO FORMONLY.azp02
    # IF g_aza.aza53='Y' THEN
    #    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
    #    INPUT BY NAME source WITHOUT DEFAULTS
    #       AFTER FIELD source 
    #          LET l_azp02=''
    #          SELECT azp02 INTO l_azp02 FROM azp_file
    #             WHERE azp01=source
    #          IF STATUS THEN
    #             CALL cl_err3("sel","azp_file",source,"","100","","",0) #No.FUN-660122
    #             NEXT FIELD source
    #          END IF
    #          DISPLAY l_azp02 TO FORMONLY.azp02
 
    #       AFTER INPUT
    #          IF INT_FLAG THEN EXIT INPUT END IF  
 
    #       ON ACTION CONTROLP
    #          CASE
    #             WHEN INFIELD(source)
    #                  CALL cl_init_qry_var()
    #                  LET g_qryparam.form = "q_azp"
    #                  LET g_qryparam.default1 = source
    #                  CALL cl_create_qry() RETURNING source 
    #                  DISPLAY BY NAME source
    #                  NEXT FIELD source
    #          END CASE
 
    #       ON ACTION exit              #加離開功能genero
    #          LET INT_FLAG = 1
    #          EXIT INPUT
 
    #       ON ACTION controlg       #TQC-860021
    #          CALL cl_cmdask()      #TQC-860021
 
    #       ON IDLE g_idle_seconds   #TQC-860021
    #          CALL cl_on_idle()     #TQC-860021
    #          CONTINUE INPUT        #TQC-860021
 
    #       ON ACTION about          #TQC-860021
    #          CALL cl_about()       #TQC-860021
 
    #       ON ACTION help           #TQC-860021
    #          CALL cl_show_help()   #TQC-860021
    #    END INPUT
    #    IF INT_FLAG THEN
    #       LET INT_FLAG = 0 
    #       CLOSE WINDOW p120_w 
    #       EXIT PROGRAM
    #    END IF
    #    IF source!=g_plant THEN
    #       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=source
    #       IF STATUS THEN LET l_azp03=g_dbs END IF
    #       DATABASE l_azp03    
    #       CALL cl_ins_del_sid(1,source) #FUN-980030  #FUN-990069
    #    END IF
    # END IF
    #FUN-A60056--mark--end
 
      CALL g_rvv.clear()
      WHILE TRUE
         CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
        #CONSTRUCT BY NAME g_wc ON rvv09,rvv01,rvb04,rvb22,rva04,rvv06,rvvplant    #FUN-990031 add  rvvplant   #FUN-A60056
         CONSTRUCT BY NAME g_wc ON rvv09,rvv01,rvb04,rvb22,rva04,rvv06             #FUN-A60056
      
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
            ON ACTION locale
               LET g_action_choice = 'locale'
               EXIT CONSTRUCT
 
            ON ACTION exit
               LET INT_FLAG = 1
               EXIT CONSTRUCT
 
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
         
           #FUN-A60056--mark--str--
           #ON ACTION CONTROLP
           #   CASE
           #     WHEN INFIELD(rvvplant)
           #       CALL cl_init_qry_var()
           #       LET g_qryparam.form = "q_azw"
           #       LET g_qryparam.where = "azw02 = '",g_legal,"' "
           #       LET g_qryparam.state = "c"
           #       CALL cl_create_qry() RETURNING g_qryparam.multiret
           #       DISPLAY g_qryparam.multiret TO rvvplant
           #       NEXT FIELD rvvplant
           #   END CASE
           #FUN-A60056--mark--end
          #TQC-B80224 --begin
           ON ACTION CONTROLP
              CASE
                   WHEN INFIELD(rvv01)
                     CALL cl_init_qry_var()
               #FUN-BA0065 add START
                     SELECT azw04 INTO l_azw04 FROM azw_file WHERE azw01 = g_plant
                     IF l_azw04 = '2' THEN
                        LET g_qryparam.form = 'q_rvv10'
                     ELSE
               #FUN-BA0065 add END
                        LET g_qryparam.form = 'q_rvv01'
                     END IF #FUN-BA0065 add
                     LET g_qryparam.where = "rvv89!='Y' "   #MOD-BA0049 add
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv01
                     NEXT FIELD rvv01
                   WHEN INFIELD(rvb04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ='q_rvv32'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvb04
                     NEXT FIELD rvb04
                   WHEN INFIELD(rvv06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_pmc'
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rvv06
                     NEXT FIELD rvv06
              END CASE
          #TQC-B80224 --end
 
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
         IF g_action_choice = 'locale' THEN
            EXIT WHILE
         END IF
      
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            CLOSE WINDOW p120_w 
       #FUN-A60056--mark--str--
       # IF g_aza.aza53='Y' AND source!=g_plant THEN
       #    DATABASE g_dbs 
       #    CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
       # END IF
       #FUN-A60056--mark--end
            CALL  cl_used(g_prog,g_time,2)  RETURNING g_time     #No.FUN-B30211
             EXIT PROGRAM
         END IF
 
        #IF g_wc = ' 1=1' THEN
        #   CALL cl_err('','9046',0)
        #   CONTINUE WHILE
        #END IF

         #FUN-A60056--add--str--
         CONSTRUCT BY NAME g_wc1 ON azw01

            BEFORE CONSTRUCT
                CALL cl_qbe_init()

            ON ACTION locale
               LET g_action_choice = 'locale'
               EXIT CONSTRUCT

            ON ACTION exit
               LET INT_FLAG = 1
               EXIT CONSTRUCT

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
               CALL cl_qbe_select()

            ON ACTION CONTROLP
               CASE
                 WHEN INFIELD(azw01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azw01
                   NEXT FIELD azw01
               END CASE

         END CONSTRUCT
         LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond(null, null) 

         IF g_action_choice = 'locale' THEN
            EXIT WHILE
         END IF

         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p120_w
            CALL  cl_used(g_prog,g_time,2)  RETURNING g_time     #No.FUN-B30211
            EXIT PROGRAM
         END IF
         #FUN-A60056--add--end
 
         EXIT WHILE
      END WHILE
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
  
      MESSAGE "WAITING...." 
      CALL ui.Interface.refresh()
 
      CALL p120_b_fill()
 
      MESSAGE ""
      CALL ui.Interface.refresh()
      
      DISPLAY g_rec_b TO FORMONLY.cn3  #顯示總筆數
      
      INPUT ARRAY g_rvv WITHOUT DEFAULTS FROM s_rvv.* 
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE ROW
            LET g_ac = ARR_CURR()
            DISPLAY g_ac TO cn3   #FUN-680110 modify   #cn2   
            BEGIN WORK                                 #MOD-C90224 add
           #FUN-A60056--mod--str--
           #SELECT rvb22 INTO g_rvv[g_ac].rvb22b FROM rvb_file
           # WHERE rvb01=g_rvv[g_ac].rvv04 AND rvb02=g_rvv[g_ac].rvv05
            IF NOT cl_null(g_rvv[g_ac].rvv04) THEN   #FUN-BB0001 add
               LET l_sql = "SELECT rvb22 FROM ",
                            cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                           " WHERE rvb01='",g_rvv[g_ac].rvv04,"'",
                           "   AND rvb02='",g_rvv[g_ac].rvv05,"'",
                           "   AND rvb89!='Y'"   #MOD-BA0049 add
        #FUN-BB0001 add START
            ELSE
               LET l_sql = " SELECT rvv22 FROM ",
                            cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                           " WHERE rvv01='",g_rvv[g_ac].rvv01,"'",
                           "   AND rvv02='",g_rvv[g_ac].rvv02,"'"
            END IF
        #FUN-BB0001 add END
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
            PREPARE sel_rvb22 FROM l_sql
            EXECUTE sel_rvb22 INTO g_rvv[g_ac].rvb22b 
           #FUN-A60056--mod--end
            LET g_rvv_o.* = g_rvv[g_ac].*  
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
         AFTER FIELD rvb22b
            IF NOT cl_null(g_rvv[g_ac].rvb22b) THEN
               #No.TQC-BB0163  --Begin
               SELECT rvu21 INTO l_rvu21 FROM rvu_file WHERE rvu01=g_rvv[g_ac].rvv01
               IF l_rvu21 = '2' OR l_rvu21 = '3' OR l_rvu21='4' THEN 
                  CALL cl_err(g_rvv[g_ac].rvb22b,'gap-006',0)
                  NEXT FIELD rvb22b
               END IF
               #No.TQC-BB0163  --End
              #--------------------MOD-D10123-------------(S)
               IF NOT cl_null(g_rvv[g_ac].rvv04) THEN
                  LET l_sql = "SELECT rva06 FROM ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rva_file'),
                              " WHERE rva01 = '",g_rvv[g_ac].rvv04,"'"
               ELSE
                  LET l_sql = "SELECT rvu03 FROM ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvu_file'),
                              " WHERE rvu01 = '",g_rvv[g_ac].rvv01,"'"
               END IF
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE sel_rva06_pre FROM l_sql
               EXECUTE sel_rva06_pre INTO l_rvw02

               IF NOT cl_null(g_rvv[g_ac].rvv04) THEN
                  SELECT rva00 INTO l_rva00
                    FROM rva_file
                   WHERE rva01 = g_rvv[g_ac].rvv04
                   IF l_rva00 = '1' THEN
                      LET l_sql = "SELECT UNIQUE pmm21 ",
                                  "  FROM ",cl_get_target_table(g_rvv[g_ac].rvvplant,'pmm_file'),",",
                                  "       ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                                  " WHERE pmm01 = rvb04  AND rvb01 = '",g_rvv[g_ac].rvv04,"'"
                   ELSE
                      LET l_sql = "SELECT rva115 ",
                                  "  FROM ",cl_get_target_table(g_rvv[g_ac].rvvplant,' rva_file'),
                                  "  WHERE rva01 = '",g_rvv[g_ac].rvv04,"' "
                   END IF
               ELSE
                  LET l_sql = " SELECT DISTINCT pmc47 ",
                              " FROM ",cl_get_target_table(g_rvv[g_ac].rvvplant,'pmc_file'),",",
                              "      ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvu_file'),
                              " WHERE pmc01 = rvu04 AND rvu01 = '",g_rvv[g_ac].rvv01,"'"
               END IF
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE sel_pmm21 FROM l_sql
               EXECUTE sel_pmm21 INTO l_rvw03

               CALL t120_invoice_chk(g_rvv[g_ac].rvb22b,l_rvw03,l_rvw02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvv[g_ac].rvb22b,g_errno,0)
                  NEXT FIELD rvb22b
               END IF
              #--------------------MOD-D10123-------------(E)
             #-------------------MOD-D10123---------------mark
             # LET l_n=0
             # SELECT COUNT(*) INTO l_n FROM apa_file,apb_file
             #  WHERE apa08 = g_rvv[g_ac].rvb22b
             #    AND apa42 = 'N'
             #    AND apa01 = apb01
             #    AND apb21 = g_rvv[g_ac].rvv01
             #    AND apb22 = g_rvv[g_ac].rvv02
             # IF l_n > 0 THEN
             #    CALL cl_err(g_rvv[g_ac].rvb22b,'apm-241',0)
             #    NEXT FIELD rvb22b
             # END IF
             ##CHI-820005   ---start   Add
             ##--------------MOD-BB0123------------------start
             ##SELECT rvw02 INTO l_year FROM rvw_file
             # SELECT max(rvw02) INTO l_rvw02 FROM rvw_file
             #  WHERE rvw01 = g_rvv[g_ac].rvb22b
             ##   AND rvw08 = g_rvv[g_ac].rvv01
             ##   AND rvw09 = g_rvv[g_ac].rvv02
             ##LET l_year = YEAR(l_year)USING '&&&&'
             # LET l_year = YEAR(l_rvw02)USING '&&&&'
             ##--------------MOD-BB0123--------------------end
             ##CHI-820005   ---end     Add
             # LET l_n=0
             # SELECT COUNT(*) INTO l_n FROM apk_file
             #   WHERE apk03 = g_rvv[g_ac].rvb22b
             #     AND YEAR(apk05) = l_year     #CHI-820005   Add
             # IF l_n > 0 THEN
             #    CALL cl_err(g_rvv[g_ac].rvb22b,'apm-241',0)
             #    NEXT FIELD rvb22b
             # END IF
             #-------------------MOD-D10123---------------mark
               IF g_sma.sma41 = "Y" AND g_rvv[g_ac].rva04b = "Y" THEN
                  SELECT als05 INTO l_als05 FROM als_file
                   WHERE als01 = g_rvv[g_ac].rvb22b
                  IF SQLCA.sqlcode=100 THEN
                     CALL cl_err3("sel","als_file",g_rvv[g_ac].rvb22b,"","apm-269","","",0) #No.FUN-660122
                     NEXT FIELD rvb22b
                  END IF
                 #FUN-A60056--mod--str--
                 #SELECT rva05 INTO l_rva05 FROM rva_file
                 # WHERE rva01 = g_rvv[g_ac].rvv04
                  LET l_sql = "SELECT rva05 FROM ",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rva_file'),
                              " WHERE rva01 = '",g_rvv[g_ac].rvv04,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE sel_rva05 FROM l_sql
                  EXECUTE sel_rva05 INTO l_rva05
                 #FUN-A60056--mod--end
                  IF l_als05 <> l_rva05 THEN
                     CALL cl_err('','apm-303',1)
                     NEXT FIELD rvb22b
                  END IF
 
               END IF
               IF NOT cl_null(g_rvv[g_ac].rvb22b) THEN
                  LET g_rva05=''
                 #FUN-A60056--mod--str--
                 #SELECT rva05 INTO g_rva05 FROM rva_file
                 #  WHERE rva01=g_rvv[g_ac].rvv04
                  LET l_sql = "SELECT rva05 FROM ",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rva_file'),
                              " WHERE rva01 = '",g_rvv[g_ac].rvv04,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE sel_rva05_pre FROM l_sql
                  EXECUTE sel_rva05_pre INTO g_rva05
                 #FUN-A60056--mod--end
                  LET l_cnt = 0
                 #FUN-A60056--mod--str--
                 #SELECT COUNT(*) INTO l_cnt FROM rvw_file,rva_file,rvb_file
                 #   WHERE rvw01 = g_rvv[g_ac].rvb22b AND
                 #         rvb22 = rvw01 AND
                 #         rvb01 = rva01 AND
                 #         rva05 <> g_rva05
                  LET l_sql = "SELECT COUNT(*) FROM rvw_file,",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rva_file'),",",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                              " WHERE rvw01 = '",g_rvv[g_ac].rvb22b,"'",
                              "   AND rvb22 = rvw01 ",
                              "   AND rvb01 = rva01 ",
                              "   AND rva05 <> '",g_rva05,"'",
                              "   AND rvb89!='Y'"   #MOD-BA0049 add
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                 CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                 PREPARE sel_cout_rva FROM l_sql
                 EXECUTE sel_cout_rva INTO l_cnt
                 #FUN-A60056--mod--end
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_rvv[g_ac].rvb22b,'apm-435',0)
                     NEXT FIELD rvb22b
                  END IF
               END IF
            END IF
         
      
         ON ROW CHANGE
            LET l_flag = 'N' #MOD-960171    
            IF g_rvv[g_ac].rva04b = g_rvv_o.rva04b OR
               (g_rvv[g_ac].rva04b IS NULL AND g_rvv_o.rva04b IS NULL) THEN 
              MESSAGE "rva04 no change"
              CALL ui.Interface.refresh()
            ELSE 
               #-->是否贖單收料(FLAG)
              #FUN-A60056--mod--str--
              #UPDATE rva_file SET rva04=g_rvv[g_ac].rva04b 
              # WHERE rva01=g_rvv[g_ac].rvv04
               LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvv04,'rva_file'),
                           "   SET rva04= '",g_rvv[g_ac].rva04b,"'",
                           " WHERE rva01='",g_rvv[g_ac].rvv04,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE upd_rva FROM l_sql
               EXECUTE upd_rva
              #FUN-A60056--mod--end
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err3("upd","rva_file",g_rvv[g_ac].rvv04,"",SQLCA.sqlcode,"","upd rvb",1) #No.FUN-660122
                  ROLLBACK WORK                     #MOD-C90224 add
               END IF 
            END IF 
 
            IF g_rvv[g_ac].rvb22b = g_rvv_o.rvb22b OR
               (g_rvv[g_ac].rvb22b IS NULL AND g_rvv_o.rvb22b IS NULL) THEN
                 MESSAGE "rvb22 no change"
                 CALL ui.Interface.refresh()
            ELSE 
               SELECT COUNT(*) INTO l_cnt FROM rvw_file 
                WHERE rvw01=g_rvv[g_ac].rvb22b
               IF l_cnt=0 AND g_rvv[g_ac].rvb22b IS NOT NULL AND g_rvv[g_ac].rvb22b<>' ' THEN  
                 #CALL saapt114(g_rvv[g_ac].rvb22b,g_rvv[g_ac].rvv04,g_rvv[g_ac].rvvplant)  #FUN-A60056 add rvvplant  #FUN-BB0001 mark
                  CALL saapt114(g_rvv[g_ac].rvb22b,g_rvv[g_ac].rvv04,g_rvv[g_ac].rvvplant,g_rvv[g_ac].rvv01)        #FUN-BB0001 add
                   RETURNING g_rvv[g_ac].rvb22b
                  DISPLAY g_rvv[g_ac].rvb22b TO rvb22b 
                  IF INT_FLAG THEN 
                     LET INT_FLAG = 0 
                     ROLLBACK WORK                                             #MOD-C90224 add
                     EXIT INPUT                                                #MOD-CC0158 add
                  END IF
               END IF
               IF g_rvv[g_ac].rvb22b IS NULL THEN
                  LET g_rvv[g_ac].rvb22b = ' '
               END IF
               IF cl_null(g_rvv[g_ac].rvb22b) THEN
                 #FUN-A60056--mod--str--
                 #UPDATE rvb_file SET rvb22 = g_rvv[g_ac].rvb22b
                 # WHERE rvb01 = g_rvv[g_ac].rvv04
                 #   AND rvb02 = g_rvv[g_ac].rvv05
                  LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                              "   SET rvb22 = '",g_rvv[g_ac].rvb22b,"'",
                              " WHERE rvb01 = '",g_rvv[g_ac].rvv04,"'",
                              "   AND rvb02 = '",g_rvv[g_ac].rvv05,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE upd_rvb_pre FROM l_sql
                  EXECUTE upd_rvb_pre
               #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
               #FUN-BB0001 add START
                  LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                              "   SET rvv22 = '",g_rvv[g_ac].rvb22b,"'",
                              " WHERE rvv01 = '",g_rvv[g_ac].rvv01,"'",
                              "   AND rvv02 = '",g_rvv[g_ac].rvv02,"'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE upd_rvv_pre FROM l_sql
                  EXECUTE upd_rvv_pre
               #FUN-BB0001 add END
                 #FUN-A60056--mod--end
               END IF
 
               #-->更新發票資料
               #No:7816 若多張入庫單對一張發票,當某一個發票號碼清除時,要詢問
               IF g_rvv[g_ac].rvb22b=' ' OR g_rvv[g_ac].rvb22b IS NULL THEN
                   IF cl_confirm('aap-247') THEN  #MOD-4A0149
                     #-->舊的發票號碼要刪掉 by kitty bug No:7376
                     DELETE from rvw_file WHERE rvw01=g_rvv_o.rvb22b
 
                    #FUN-A60056--mod--str--
                    #UPDATE rvb_file SET rvb22=g_rvv[g_ac].rvb22b
                    # WHERE rvb22=g_rvv_o.rvb22b
                     LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                                 "   SET rvb22='",g_rvv[g_ac].rvb22b,"'",
                                 " WHERE rvb22='",g_rvv_o.rvb22b,"'"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                     PREPARE upd_rvb_pre1 FROM l_sql
                     EXECUTE upd_rvb_pre1
               #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
               #FUN-BB0001 add START
                     LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                                 "   SET rvv22 = '",g_rvv[g_ac].rvb22b,"'",
                                 " WHERE rvv22 = '",g_rvv_o.rvb22b,"'"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                     PREPARE upd_rvv_pre1 FROM l_sql
                     EXECUTE upd_rvv_pre1
               #FUN-BB0001 add END 
                    #FUN-A60056--mod--end
                     CALL p120_b_fill()
                  END IF
               END IF
 
                #-->更新發票資料
              #FUN-A60056--mod--str--
              #UPDATE rvb_file SET rvb22=g_rvv[g_ac].rvb22b
              # WHERE rvb01 = g_unique_key[g_ac].rvb01 AND rvb02 = g_unique_key[g_ac].rvb02
               LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                           "   SET rvb22='",g_rvv[g_ac].rvb22b,"'",
                           " WHERE rvb01 = '",g_unique_key[g_ac].rvb01,"'",
                           "   AND rvb02 = '",g_unique_key[g_ac].rvb02,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE upd_rvb_pre2 FROM l_sql
               EXECUTE upd_rvb_pre2
            #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
            #FUN-BB0001 add START
               LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                           "   SET rvv22 = '",g_rvv[g_ac].rvb22b,"'",
                           " WHERE rvv01 = '",g_rvv[g_ac].rvv01,"'",
                           "   AND rvv02 = '",g_rvv[g_ac].rvv02,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE upd_rvv_pre2 FROM l_sql
               EXECUTE upd_rvv_pre2
            #FUN-BB0001 add END
              #FUN-A60056--mod--end
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","rvb_file",g_rvv[g_ac].rvb22b,"",SQLCA.sqlcode,"","upd rvb",1) #No.FUN-660122
                  ROLLBACK WORK                     #MOD-C90224 add
                  EXIT INPUT                        #MOD-CC0158 add
                # No.MOD-530466 --start-- 更新成功若舊發票號碼沒有其他單子使用則刪除
               ELSE
                  LET l_rvv04 = ''
                 #FUN-A60056--mod--str--
                 #SELECT rvv04 INTO l_rvv04 FROM rvv_file
                 #  WHERE rvv01 = g_rvv[g_ac].rvv01 AND
                 #        rvv02 = g_rvv_o.rvv02
                  LET l_sql = "SELECT rvv04 FROM ",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                              " WHERE rvv01 = '",g_rvv[g_ac].rvv01,"'",
                              "   AND rvv02 = '",g_rvv_o.rvv02,"'",
                              "   AND rvv89!='Y'"   #MOD-BA0049 add
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE sel_rvv04 FROM l_sql
                  EXECUTE sel_rvv04 INTO l_rvv04
                 #FUN-A60056--mod--end
                  LET l_cnt = 0
                 #FUN-A60056--mod--str--
                 #SELECT COUNT(*) INTO l_cnt FROM rvb_file
                 #  WHERE rvb22 = g_rvv_o.rvb22b
                  LET l_sql = "SELECT COUNT(*) FROM ",
                               cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                              " WHERE rvb22 = '",g_rvv_o.rvb22b,"'",
                              "   AND rvb89!='Y'"   #MOD-BA0049 add
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                  PREPARE sel_cou_rvv FROM l_sql
                  EXECUTE sel_cou_rvv INTO l_cnt
                 #FUN-A60056--mod--end
                  IF l_cnt = 0 THEN
                     DELETE FROM rvw_file WHERE rvw01 = g_rvv_o.rvb22b
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","rvw_file",g_rvv_o.rvb22b,"",SQLCA.sqlcode,"","del rvw",0) #No.FUN-660122
                        ROLLBACK WORK                     #MOD-C90224 add
                        EXIT INPUT                        #MOD-CC0158 add
                     END IF
                  END IF
               END IF
            END IF
 
            #-->發票收料輸入發票資料
            IF g_rvv[g_ac].rva04b = 'N' THEN
               ##No:7816 不要每筆都開窗,這樣不方便
 
               IF NOT cl_null(g_rvv[g_ac].rvb22b) AND
                  (g_rvv[g_ac].rvb22b != g_rvv_o.rvb22b OR
                   g_rvv_o.rvb22b IS NULL) THEN
                  LET l_cnt = 0
                  FOR l_i = g_ac + 1 TO g_cnt 
                   #加判斷已有發票號碼者不更新
                     IF g_rvv[l_i].rvv06 = g_rvv[g_ac].rvv06 
                    AND (g_rvv[l_i].rvb22b IS NULL OR g_rvv[l_i].rvb22b=' ') THEN
                         LET l_cnt = l_cnt + 1
                         LET g_rvb_key[l_cnt].* = g_unique_key[l_i].*
                      END IF
                  END FOR 
 
                  #-->更新發票號碼
                  IF l_cnt > 0 THEN
                     IF cl_confirm('aap-267') THEN
                        LET l_i = 1
                        FOR l_i = 1 TO l_cnt
                           #FUN-A60056--mod--str--
                           #UPDATE rvb_file SET rvb22 = g_rvv[g_ac].rvb22b
                           # WHERE rvb01 = g_rvb_key[l_i].rvb01 AND rvb02 = g_rvb_key[l_i].rvb02
                            LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                                        "   SET rvb22 = '",g_rvv[g_ac].rvb22b,"'",
                                        " WHERE rvb01 = '",g_rvb_key[l_i].rvb01,"'",
                                        "   AND rvb02 = '",g_rvb_key[l_i].rvb02,"'"
                            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                            CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                            PREPARE upd_rvb_pre3 FROM l_sql
                            EXECUTE upd_rvb_pre3
                           #FUN-A60056--mod--end
                            IF SQLCA.SQLCODE THEN 
                               CALL cl_err3("upd","rvb_file",g_rvv[g_cnt].rvv01,g_rvv[g_cnt].rvv02,SQLCA.sqlcode,"","upd rvb22",1) #No.FUN-660122
                               ROLLBACK WORK                     #MOD-C90224 add
                               EXIT INPUT                        #MOD-CC0158 add
                            END IF
                         #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
                         #FUN-BB0001 add START
                            LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                                        "   SET rvv22 = '",g_rvv[g_ac].rvb22b,"'",
                                        " WHERE rvv01 = '",g_rvv[g_ac].rvv01,"'",
                                        "   AND rvv02 = '",g_rvv[g_ac].rvv02,"'"
                            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                            CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
                            PREPARE upd_rvv_pre3 FROM l_sql
                            EXECUTE upd_rvv_pre3
                           #FUN-A60056--mod--end
                            IF SQLCA.SQLCODE THEN
                               CALL cl_err3("upd","rvb_file",g_rvv[g_cnt].rvv01,g_rvv[g_cnt].rvv02,SQLCA.sqlcode,"","upd rvb22",1) #No.FUN-660122
                               ROLLBACK WORK                     #MOD-C90224 add
                               EXIT INPUT                        #MOD-CC0158 add
                            END IF
                         #FUN-BB0001 add END 
                            LET l_flag='Y'   #MOD-860175 add
                        END FOR
                        CALL p120_b_fill()
                     END IF
                  END IF
               END IF
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM rvw_file
              WHERE rvw01=g_rvv[g_ac].rvb22b
            IF l_cnt > 0 THEN
               LET g_rvv[g_ac].x = 'Y'
              #COMMIT WORK                       #MOD-C90224 add #MOD-CC0158 mark
            ELSE
               LET g_rvv[g_ac].x = 'N'
              #ROLLBACK WORK                     #MOD-C90224 add #MOD-CC0158 mark
            END IF
            COMMIT WORK                          #MOD-CC0158
      #FUN-BB0001 add START
            IF cl_null(g_rvv[g_ac].rvb22b) THEN
               SELECT rvv22 INTO g_rvv[g_ac].rvb22b
                 FROM rvv_file
                   WHERE rvv01 = g_rvv[g_ac].rvv01
                     AND rvv02 = g_rvv[g_ac].rvv02
            END IF
      #FUN-BB0001 add END
            DISPLAY BY NAME g_rvv[g_ac].x
            IF l_flag='Y' THEN     #MOD-860175 add
               NEXT FIELD rvb22b   #MOD-860175 add
            END IF                 #MOD-860175 add
      
         AFTER ROW
            LET g_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvv[g_ac].* = g_rvv_o.*
               ROLLBACK WORK                     #MOD-C90224 add
               EXIT INPUT
            END IF
      
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP 
           #No.+216 010615 和採購區分開來
           #CALL saapt114(g_rvv[g_ac].rvb22b,g_rvv[g_ac].rvv04,g_rvv[g_ac].rvvplant)  #FUN-A60056 add rvvplant  #FUN-BB0001 mark
            CALL saapt114(g_rvv[g_ac].rvb22b,g_rvv[g_ac].rvv04,g_rvv[g_ac].rvvplant,g_rvv[g_ac].rvv01)        #FUN-BB0001 add
                RETURNING g_rvv[g_ac].rvb22b
             DISPLAY g_rvv[g_ac].rvb22b TO rvb22b #No.MOD-480094
            
            IF INT_FLAG THEN 
               LET INT_FLAG = 0 
               ROLLBACK WORK                     #MOD-C90224 add
               CONTINUE INPUT                    #MOD-CC0158 add
            END IF
            IF g_rvv[g_ac].rvb22b IS NULL THEN
               LET g_rvv[g_ac].rvb22b = ' '
            END IF
            IF cl_null(g_rvv[g_ac].rvb22b) THEN
              #FUN-A60056--mod--str--
              #UPDATE rvb_file SET rvb22 = g_rvv[g_ac].rvb22b
              # WHERE rvb01 = g_rvv[g_ac].rvv04
              #   AND rvb02 = g_rvv[g_ac].rvv05
               LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvb_file'),
                           "   SET rvb22 = '",g_rvv[g_ac].rvb22b,"'",
                           " WHERE rvb01 = '",g_rvv[g_ac].rvv04,"'",
                           "   AND rvb02 = '",g_rvv[g_ac].rvv05,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE upd_rvb_pre4 FROM l_sql
               EXECUTE upd_rvb_pre4
           #流通代銷無收貨單,將發票記錄rvb22同時update到rvv22內
           #FUN-BB0001 add START
               LET l_sql = "UPDATE ",cl_get_target_table(g_rvv[g_ac].rvvplant,'rvv_file'),
                           "   SET rvv22 = '",g_rvv[g_ac].rvb22b,"'",
                           " WHERE rvv01 = '",g_rvv[g_ac].rvv01,"'",
                           "   AND rvv02 = '",g_rvv[g_ac].rvv02,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvv[g_ac].rvvplant) RETURNING l_sql
               PREPARE upd_rvv_pre4 FROM l_sql
               EXECUTE upd_rvv_pre4
           #FUN-BB0001 add END
              #FUN-A60056--mod--end
            END IF
      
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
         
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION controls                       #No.FUN-6B0033                                                                       	
            CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
         ON ACTION exporttoexcel2                                                                    #FUN-990087 add #MOD-B50120 mod exporttoexcel -> exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')    #FUN-990087 add
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         ROLLBACK WORK                     #MOD-C90224 add
         CONTINUE WHILE 
      END IF #使用者中斷
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
     
      ERROR ' '
   END WHILE
 
   CLOSE WINDOW p120_w
 
END FUNCTION
 
FUNCTION p120_b_fill()
  #DEFINE l_sql  LIKE type_file.chr1000  #MOD-620031  #No.FUN-690028 VARCHAR(1500) #TQC-C20200 mark--
   DEFINE l_sql  STRING                  #TQC-C20200 
   DEFINE l_n    LIKE type_file.num5     #No.MOD-540038  #No.FUN-690028 SMALLINT
   DEFINE l_cnt  LIKE type_file.num5     #FUN-670105  #No.FUN-690028 SMALLINT
 
#FUN-A60056--add--str--
   #FUN-A70139--mark--str--提到最外層FROEACH處
   CALL g_rvv.clear()
   CALL g_rvb_key.clear()
   CALL g_unique_key.clear()

   LET g_cnt=1                                         #總選取筆數
   #FUN-A70139--mark--end

   #若沒有下PLANT查詢條件,則抓當前法人下所有PLANT資料
   LET l_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y'",
               "   AND azw02 = '",g_legal,"'",
               "   AND ",g_wc1 CLIPPED
   PREPARE sel_azw FROM l_sql
   DECLARE sel_azw1 CURSOR FOR sel_azw
   FOREACH sel_azw1 INTO g_azw01
#FUN-A60056--add--end
#No.TQC-BA0068 --begin 
      IF g_wc.getIndexOf("rvb",1) > 0 OR g_wc.getIndexOf("rvb",1) > 0 THEN  
         LET l_sql = " SELECT rvb01,rvb02,rvvplant,rvv09,rvv06,'',rvb05,rvv36,rvv37,rvv01,rvv02,'',",  #NO.TQC-5B0091  #FUN-6A0047 add pmc03,rvb30   #MOD-810225   #FUN-A60056 add rvvplant
                     "        rvv04,rvv05,rva04,'',rvb22,rvv38,rvv39",   #CHI-790035
                    #FUN-A60056--mod--str--
                    #"   FROM rvv_file,rva_file,rvb_file,rvu_file ",#No.8456 add rvu   
                     "   FROM ",cl_get_target_table(g_azw01,'rvv_file'),",",
                     "        ",cl_get_target_table(g_azw01,'rva_file'),",",
                     "        ",cl_get_target_table(g_azw01,'rvb_file'),",",
                     "        ",cl_get_target_table(g_azw01,'rvu_file'),
                    #FUN-A60056--mod--end
                     "  WHERE rvv04=rva01 ",
                     "    AND rvv04=rvb01 ",
                     "    AND rvv05=rvb02 ",
                     "    AND rvv01=rvu01 ",     #No.8456
                     "    AND rvu00= '1'  ",     #No.8801
                     "    AND rvuconf = 'Y' ",   #No.8456   #TQC-5B0020
                     "    AND rvaconf != 'X' ",  #No.9405
                     "    AND rvv89!='Y'",       #MOD-BA0049 add
                     "    AND rvb89!='Y'",       #MOD-BA0049 add
                     "    AND ",g_wc CLIPPED
      ELSE 
         LET l_sql = " SELECT rvb01,rvb02,rvvplant,rvv09,rvv06,'',rvb05,rvv36,rvv37,rvv01,rvv02,'',",                       
                     "        rvv04,rvv05,rva04,'',rvb22,rvv38,rvv39",  
                     "   FROM ",cl_get_target_table(g_azw01,'rvu_file'),",",
                     "        ",cl_get_target_table(g_azw01,'rvv_file'),
                     "   LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'rvb_file'),
                     "   ON rvv_file.rvv04=rvb_file.rvb01 AND rvv_file.rvv05=rvb_file.rvb02 AND rvb_file.rvb89!='Y' ",  #MOD-BA0049 mod
                     "   LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'rva_file'),
                     "   ON rvv_file.rvv04=rva_file.rva01 AND rva_file.rvaconf != 'X' ",                    
                     "  WHERE rvv01=rvu01 ",                         
                     "    AND rvu00= '1'  ",                     
                     "    AND rvuconf = 'Y' ",                                                                
                     "    AND rvv89!='Y'",       #MOD-BA0049 add
                     "    AND ",g_wc CLIPPED
      END IF 
#No.TQC-BA0068 --end 
 

      #no.5748 增加沖暫估功能
      IF g_argv0 = '1' THEN #非沖暫估
         LET l_sql = l_sql CLIPPED,
                     "  AND rvv87 > rvv23 ",    #TQC-6B0151
                     "  ORDER BY rvv01,rvv02"
      ELSE                  #沖暫估 
         LET l_sql = l_sql CLIPPED,
                     "  AND rvv88 > 0   ",
                     "  ORDER BY rvv01,rvv02"
      END IF
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A60056
      CALL cl_parse_qry_sql(l_sql,g_azw01) RETURNING l_sql   #FUN-A60056
      PREPARE p120_prepare FROM l_sql  
      IF SQLCA.sqlcode THEN                          #有問題了
         CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
         RETURN
      END IF
 
      DECLARE p120_cs CURSOR FOR p120_prepare     #宣告之
 
     #FUN-A70139--mark--str--提到最外層FROEACH處
     #CALL g_rvv.clear()
     #CALL g_rvb_key.clear()
     #CALL g_unique_key.clear()
 
     #LET g_cnt=1                                         #總選取筆數
     #FUN-A70139--mark--end

      FOREACH p120_cs INTO g_unique_key[g_cnt].*,g_rvv[g_cnt].*
         IF SQLCA.sqlcode THEN                           #有問題
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      #FUN-BB0001 add START
         IF cl_null(g_rvv[g_cnt].rvb22b) THEN
            LET l_sql = " SELECT rvv22 FROM ",cl_get_target_table(g_azw01,'rvv_file') ,
                        " WHERE rvv01 = '",g_rvv[g_cnt].rvv01,"' ",
                        " AND rvv02 = '",g_rvv[g_cnt].rvv02,"'  "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_azw01) RETURNING l_sql
            PREPARE p120_prepare_1 FROM l_sql
            DECLARE p120_cs_1 CURSOR FOR p120_prepare_1
            EXECUTE p120_cs_1 INTO g_rvv[g_cnt].rvb22b
         END IF
      #FUN-BB0001 add END 
        #FUN-A60056--mod--str--
        #SELECT rvv87 INTO g_rvv[g_cnt].rvv87 FROM rvv_file
        #  WHERE rvv01 = g_rvv[g_cnt].rvv01
        #    AND rvv02 = g_rvv[g_cnt].rvv02
#No.TQC-BA0068 --begin 
         IF g_unique_key[g_cnt].rvb02 IS NULL THEN LET g_unique_key[g_cnt].rvb02 = 0 END IF 
#No.TQC-BA0068 --end
         LET l_sql = "SELECT rvv87 ",
                     "  FROM ",cl_get_target_table(g_rvv[g_cnt].rvvplant,'rvv_file'),
                     " WHERE rvv01 = '",g_rvv[g_cnt].rvv01,"'",
                     "   AND rvv02 = '",g_rvv[g_cnt].rvv02,"'",
                     "   AND rvv89!='Y'"        #MOD-BA0049 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_rvv[g_cnt].rvvplant) RETURNING l_sql
         PREPARE sel_rvv87 FROM l_sql
         EXECUTE sel_rvv87 INTO g_rvv[g_cnt].rvv87
        #FUN-A60056--mod--end
 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM rvw_file
           WHERE rvw01=g_rvv[g_cnt].rvb22b
         IF l_cnt > 0 THEN
            LET g_rvv[g_cnt].x = 'Y'
         ELSE
            LET g_rvv[g_cnt].x = 'N'
         END IF
 
         IF g_argv0 <> '1' THEN #沖暫估
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM apa_file,apb_file 
             WHERE apb21 = g_rvv[g_cnt].rvv01
               AND apb22 = g_rvv[g_cnt].rvv02
               AND apb01 = apa01
               AND apa42 = "N"
               AND apa51 = "UNAP"
            IF l_n <> 0 THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         SELECT pmc03 INTO g_rvv[g_cnt].pmc03 FROM pmc_file
          WHERE pmc01 = g_rvv[g_cnt].rvv06
         IF SQLCA.sqlcode THEN
           LET g_rvv[g_cnt].pmc03 = ''
         END IF
 
 
         LET g_cnt = g_cnt + 1                           #累加筆數
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
      END FOREACH
   END FOREACH    #FUN-A60056
 
   CALL g_rvv.deleteElement(g_cnt)
 
   IF g_cnt=1 THEN                                    #沒有抓到
      CALL cl_err('','aap-129',0)                     #顯示錯誤, 並回去
      RETURN
   END IF
 
   LET g_rec_b =g_cnt-1                               #正確的總筆數
 
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
   END DISPLAY
 
END FUNCTION
 
#---------------------MOD-D10123---------------------(S)
FUNCTION t120_invoice_chk(p_no,p_tax,p_date)
   DEFINE p_no      LIKE apk_file.apk03
   DEFINE p_tax     LIKE gec_file.gec01
   DEFINE l_rvu04   LIKE rvu_file.rvu04
   DEFINE l_gec08   LIKE gec_file.gec08
   DEFINE l_gec05   LIKE gec_file.gec05
   DEFINE l_n1,l_n2 LIKE type_file.num5,
          l_idx     LIKE type_file.num5,
          l_year    LIKE type_file.num5
   DEFINE p_date    LIKE apa_file.apa09

   LET g_errno = ''
   LET l_year = YEAR(p_date)USING '&&&&'
   IF p_no IS NULL THEN
      LET g_errno = 'aap-099'
      RETURN
   END IF

   SELECT gec05,gec08 INTO l_gec05,l_gec08
     FROM gec_file
    WHERE gec01 = p_tax AND gec011 = '1'
   IF status THEN LET l_gec05='' LET l_gec08='' END IF

   IF l_gec08 = 'XX' THEN RETURN END IF
   IF l_gec05 MATCHES '[2356]' THEN
      FOR l_idx = 3 TO 10
         IF cl_null(p_no[l_idx,l_idx]) THEN
            LET g_errno='aap-760'
            EXIT FOR
         END IF
      END FOR
   END IF

   SELECT rvu04 INTO l_rvu04 FROM rvu_file,rvv_file
    WHERE rvu01 = rvv01
      AND rvu01 = g_rvv[g_ac].rvv01
      AND rvv05 = g_rvv[g_ac].rvv02

   LET l_n1 = 0
   SELECT COUNT(*) INTO l_n1 FROM apa_file
    WHERE apa08 = p_no
      AND apa05 = l_rvu04
      AND YEAR(apa09) = l_year

   LET l_n2 = 0
   SELECT COUNT(*) INTO l_n2 FROM apk_file,apa_file
    WHERE apk03 = p_no
      AND apk171 !='23' AND apk171 != '24'
      AND apk01 = apa01 AND apa05 = l_rvu04
      AND YEAR(apk05) = l_year
      AND APK171 <> 'XX'

   IF (l_n1+l_n2) > 0 THEN
      LET g_errno = 'aap-034'
      RETURN
   END IF

   IF g_apz.apz07 != 'Y' THEN
      RETURN
   END IF
   RETURN

END FUNCTION
#---------------------MOD-D10123---------------------(E)

FUNCTION p120_rva()
   DEFINE i,j LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   FOR i = 1 TO g_rvv.getLength()
      IF g_rvv[i].rvv04 = g_rvv[g_ac].rvv04 THEN
         LET g_rvv[i].rva04b = g_rvv[g_ac].rva04b
         LET j = i - g_ac #+ g_sl
      END IF
   END FOR
 
END FUNCTION
#No.FUN-9C0077 程式精簡
