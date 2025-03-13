# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt740.4gl
# Descriptions...: L/C 修改維護
# Date & Author..: 95/11/20 By Roger
# Modify.........: 97/04/22 By Star [將apc_file 改為 npp_file,npq_file ]
# Modify.........: 98/07/02 By Carol let alc02 matches [0-9]
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# MOdify.........: No.MOD-4C0040 04/12/15 By Smapmin 新增alc86會計日期欄位
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
#                  call s_def_npq.4gl 抓取異動碼、摘要default值
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: NO.MOD-650011 06/05/03 By Smapmin 修正修改記錄
# Modify.........: No.FUN-660122 06/06/19 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.MOD-670082 06/07/18 By Smapmin 於單身輸入時就判斷採購單+項次不可重複
# Modify.........: No.FUN-670060 06/07/31 By wujie 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/08 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680059 06/08/17 By Smapmin 列印程式由aapr701改為aapr700
# Modify.........: No.FUN-680029 06/08/23 By Rayven 新增多帳套功能 
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.CHI-6A0017 06/10/12 By kim 當agls103設定不使用成本中心時,aapt740單身的成本中心要隱藏
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0055 06/10/26 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.MOD-6A0020 06/10/30 By Smapmin 修正TQC-680059
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/15 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6B0095 06/12/05 By Smapmin 外購LC修改作業,應採修改金額加總制
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/39 By lora    會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By hongmei 用年度取帳號
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780050 07/08/09 By Smapmin 修改後付款作業未確認,預購修改才可取消確認
#                                                    預購修改刪除後,要連同付款作業的分錄都刪除
# Modify.........: No.MOD-780087 07/08/16 By Smapmin 修改table名稱,變數名稱
# Modify.........: No.TQC-790116 07/09/20 By Judy 點"運營中心切換"，錄入后切換不成功
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.CHI-870010 08/07/30 By Sarah t740_cs()段需判斷有沒有g_argv1傳入值,若有的話直接組g_wc與g_wc2
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()   
# Modify.........: No.MOD-960094 09/06/06 By Sarah t740_b()段寫入all_file時應寫入all12,all13
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
#Modify.........: No.FUN-980094 09/10/19 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/21 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056 問題 
# Modify.........: No:CHI-AA0015 10/11/05 By Summer all00與alc02原為vachar(1)改為Number(5)
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action
# Modify.........: No:FUN-AA0087 11/01/27 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:MOD-B30393 11/03/18 By wuxj   单身营运中心资料自动带入，采购单号开窗控管，单身删除后继续进入单身可自动带出
# Modify.........: NO:MOD-B40267 11/04/29 By Dido FUNCTION t740_set_du_by_origin 變數運用有誤  
# Modify.........: NO:MOD-B50034 11/05/09 By Dido 多筆資料語法調整 
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:FUN-B90033 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.MOD-BB0212 11/11/21 By Dido 帳別預設值調整 
# Modify.........: No:FUN-BB0086 12/01/13 By tanxc 增加數量欄位小數取位  
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30018 12/03/07 By Polly 確認後回寫aapt710多加alb86、alb87欄位
# Modify.........: No.TQC-BB0201 12/03/21 By yinhy 查詢時，資料建立者，資料建立部門無法下查詢條件
# Modify.........: No.TQC-BB0264 12/03/21 By yinhy 當“使用利潤中心”未勾選時，未隱藏顯示成本中心欄位
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao  單身無資料時候提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:TQC-C70191 12/07/26 By Dido 取消 FUNCTION t740_hu2_alb 重覆 alb86/alb87 
# Modify.........: No.TQC-BB0264 12/08/22 By wangwei 當“使用利潤中心”未勾選時，未隱藏顯示成本中心欄位
# Modify.........: No:MOD-CB0008 12/11/02 By Polly 調整回寫alb_file欄位
# Modify.........: No:CHI-C80041 12/11/29 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No.FUN-D10065 13/01/15 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50026 13/05/06 By Polly 調整抓取數量條件，應排除本筆預購單
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_alc              RECORD LIKE alc_file.*,
    g_ala              RECORD LIKE ala_file.*,
    g_alc_t            RECORD LIKE alc_file.*,
    g_alc_o            RECORD LIKE alc_file.*,
    g_alc01_t          LIKE alc_file.alc01,
    g_alc02_t          LIKE alc_file.alc02,
    g_argv1            LIKE alc_file.alc01,    #CHI-870010 add
    g_argv2            STRING,                 #CHI-870010 add   #執行功能
    g_wc,g_wc2,g_sql   STRING,                 #No.FUN-580092 HCN
    g_cmd              LIKE type_file.chr1,    #1.開狀申請 2.會計作業 3.財務作業  #No.FUN-690028 VARCHAR(1)
    g_act_sw           LIKE type_file.num5,    #No.FUN-690028 SMALLINT,      #            1.會計作業 2.財務作業
    g_statu            LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(01),       # 是否從新賦予等級
    g_dbs_gl           LIKE type_file.chr21,   #No.FUN-690028 VARCHAR(21),
    g_plant_gl         LIKE type_file.chr21,   #No.FUN-690028 VARCHAR(21),   #No.FUN-980059
    g_dbs_nm           LIKE type_file.chr21,   #No.FUN-690028 VARCHAR(21),
    nm_no_b,nm_no_e    LIKE type_file.num10,   #No.FUN-690028 INTEGER,
    gl_no_b,gl_no_e    LIKE abb_file.abb01,    #No.FUN-690028 VARCHAR(16),  #No.FUN-550030
    l_cnt              LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_all              DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        all02            LIKE all_file.all02,
        all44            LIKE all_file.all44,    #FUN-A60056
        all04            LIKE all_file.all04,
        all05            LIKE all_file.all05,
        all11            LIKE all_file.all11,
        pmn041           LIKE pmn_file.pmn041,
#NO.FUN-710029 start---
        all83            LIKE all_file.all83, 
        all84            LIKE all_file.all84,
        all85            LIKE all_file.all85,
        all80            LIKE all_file.all80,
        all81            LIKE all_file.all81,
        all82            LIKE all_file.all82,
        all86            LIKE all_file.all86,
        all87            LIKE all_file.all87,
#NO.FUN-710029 end---
        pmn07            LIKE pmn_file.pmn07 ,
        all06            LIKE all_file.all06,
        all07            LIKE all_file.all07,
        all08            LIKE all_file.all08,
        all12            LIKE all_file.all12,
        all13            LIKE all_file.all13,
        pmn06            LIKE pmn_file.pmn06,
        all930           LIKE all_file.all930, #FUN-680019
        gem02c           LIKE gem_file.gem02   #FUN-680019
        #FUN-850038 --start---
       ,allud01          LIKE all_file.allud01,
        allud02          LIKE all_file.allud02,
        allud03          LIKE all_file.allud03,
        allud04          LIKE all_file.allud04,
        allud05          LIKE all_file.allud05,
        allud06          LIKE all_file.allud06,
        allud07          LIKE all_file.allud07,
        allud08          LIKE all_file.allud08,
        allud09          LIKE all_file.allud09,
        allud10          LIKE all_file.allud10,
        allud11          LIKE all_file.allud11,
        allud12          LIKE all_file.allud12,
        allud13          LIKE all_file.allud13,
        allud14          LIKE all_file.allud14,
        allud15          LIKE all_file.allud15
        #FUN-850038 --end--
                    END RECORD,
    g_all_t         RECORD                 #程式變數 (舊值)
        all02            LIKE all_file.all02,
        all44            LIKE all_file.all44,   #FUN-A60056
        all04            LIKE all_file.all04,
        all05            LIKE all_file.all05,
        all11            LIKE all_file.all11,
        pmn041           LIKE pmn_file.pmn041,
#NO.FUN-710029 start---
        all83            LIKE all_file.all83, 
        all84            LIKE all_file.all84,
        all85            LIKE all_file.all85,
        all80            LIKE all_file.all80,
        all81            LIKE all_file.all81,
        all82            LIKE all_file.all82,
        all86            LIKE all_file.all86,
        all87            LIKE all_file.all87,
#NO.FUN-710029 end---
        pmn07            LIKE pmn_file.pmn07 ,
        all06            LIKE all_file.all06,
        all07            LIKE all_file.all07,
        all08            LIKE all_file.all08,
        all12            LIKE all_file.all12,
        all13            LIKE all_file.all13,
        pmn06            LIKE pmn_file.pmn06,
        all930           LIKE all_file.all930, #FUN-680019
        gem02c           LIKE gem_file.gem02   #FUN-680019
        #FUN-850038 --start---
       ,allud01          LIKE all_file.allud01,
        allud02          LIKE all_file.allud02,
        allud03          LIKE all_file.allud03,
        allud04          LIKE all_file.allud04,
        allud05          LIKE all_file.allud05,
        allud06          LIKE all_file.allud06,
        allud07          LIKE all_file.allud07,
        allud08          LIKE all_file.allud08,
        allud09          LIKE all_file.allud09,
        allud10          LIKE all_file.allud10,
        allud11          LIKE all_file.allud11,
        allud12          LIKE all_file.allud12,
        allud13          LIKE all_file.allud13,
        allud14          LIKE all_file.allud14,
        allud15          LIKE all_file.allud15
        #FUN-850038 --end--
                    END RECORD,
    g_buf           LIKE type_file.chr1000,             #  #No.FUN-690028 VARCHAR(78)
    g_tot           LIKE type_file.num20_6,             # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_chr              LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt              LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg              LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count       LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index      LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump            LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask          LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_alc02           LIKE alc_file.alc02   #MOD-650011
DEFINE  g_str           STRING     #No.FUN-670060                                                                                   
DEFINE  g_wc_gl         STRING     #No.FUN-670060 
DEFINE  g_t1            LIKE oay_file.oayslip    #No.FUN-670060   #No.FUN-690028 VARCHAR(5)
#NO.FUN-710029 start---
DEFINE g_img09             LIKE img_file.img09,
       g_ima25             LIKE ima_file.ima25,
       g_ima44             LIKE ima_file.ima44,
       g_ima31             LIKE ima_file.ima31,
       g_ima906            LIKE ima_file.ima906,
       g_ima907            LIKE ima_file.ima907,
       g_ima908            LIKE ima_file.ima908,
       g_factor            LIKE pmn_file.pmn09,
       g_tot1               LIKE img_file.img10,
       g_qty               LIKE img_file.img10,
       g_flag              LIKE type_file.chr1
#NO.FUN-710029 end---
DEFINE g_bookno1    LIKE aza_file.aza81    #No.FUN-730064                                                                           
DEFINE g_bookno2    LIKE aza_file.aza82    #No.FUN-730064                                                                           
DEFINE g_bookno3    LIKE aza_file.aza82    #No.FUN-D40118   Add
DEFINE g_flag1      LIKE type_file.chr1    #No.FUN-730064  
DEFINE p_bookno     LIKE aag_file.aag00    #No.FUN-730064
DEFINE g_dbsm       LIKE type_file.chr21   #No.FUN-730064                                                                    
DEFINE g_plantm     LIKE type_file.chr10   #No.FUN-980020
DEFINE g_db_type    LIKE type_file.chr3    #No.FUN-730064
DEFINE g_azp03      LIKE azp_file.azp03     #No.FUN-730064
DEFINE g_db1               LIKE type_file.chr21  #No.FUN-730064
DEFINE g_all80_t           LIKE all_file.all80      #No.FUN-BB0086
DEFINE g_all83_t           LIKE all_file.all83      #No.FUN-BB0086
DEFINE g_all86_t           LIKE all_file.all86      #No.FUN-BB0086
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

MAIN
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0055
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)               #CHI-870010 add
   LET g_argv2 = ARG_VAL(2)   #執行功能   #CHI-870010 add
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   LET p_row = 3 LET p_col = 5
 
   OPEN WINDOW t740_w AT p_row,p_col WITH FORM "aap/42f/aapt740"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #NO.FUN-710029 start--
   CALL t740_def_form()
   #NO.FUN-710029 end----
 
   #FUN-680019...............begin
   CALL cl_set_comp_visible("all930,gem02c",g_aaz.aaz90='Y') #CHI-6A0017
   #FUN-680019...............end
 
  #str CHI-870010 add
  #先以g_argv2判斷直接執行哪種功能：
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t740_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t740_a()
           END IF
         OTHERWISE
            CALL t740_q()
      END CASE
   END IF
  #end CHI-870010 add
 
   CALL t740('1')      # 1.開狀申請
   CLOSE WINDOW t740_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION t740(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1              # 1.開狀申請 2.會計作業 3.財務作業  #No.FUN-690028 VARCHAR(1)
 
   LET g_plant_new=g_apz.apz04p
   CALL s_getdbs()
   LET g_dbs_nm=g_dbs_new
   IF cl_null(g_dbs_nm) THEN LET g_dbs_nm = NULL END IF
   LET g_plant_new=g_apz.apz02p
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
   IF cl_null(g_dbs_gl)  THEN LET g_dbs_gl = NULL END IF
 
#  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  #NO.CHI-6A0004
#   IF STATUS THEN           #No.CHI-6A0004
#      LET g_azi04 = 0       #No.CHI-6A0004
#   END IF                   #No.CHI-6A0004
   LET g_cmd = p_cmd
   INITIALIZE g_alc.* TO NULL
   INITIALIZE g_alc_t.* TO NULL
   INITIALIZE g_alc_o.* TO NULL
   
   #No.TQC-BB0264  --Begin
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("ala04",TRUE)
   END IF
   CALL cl_set_comp_visible("ala930,gem02b,all930,gem02c",g_aaz.aaz90='Y')
   #No.TQC-BB0264  --End
   
   CALL t740_lock_cur()
   CASE WHEN g_cmd = '1'
           LET g_act_sw=1
        WHEN g_cmd = '2'
           LET g_act_sw=1
        WHEN g_cmd = '3'
           LET g_act_sw=2
   END CASE
   CALL t740_menu()
END FUNCTION
 
FUNCTION t740_lock_cur()
 
   LET g_forupd_sql = "SELECT * FROM alc_file WHERE alc01 = ? AND alc02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t740_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t740_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   CLEAR FORM
   CALL g_all.clear()
 
   IF cl_null(g_argv1) THEN   #CHI-870010 add
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
      INITIALIZE g_alc.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
                  alc01,alc08,alc02,alc86,alcfirm,   #MOD-4C0040
                  alcuser,alcgrup,alcmodu,alcdate
                  ,alcoriu,alcorig                  #TQC-BB0201
                  #FUN-850038   ---start---
                  ,alcud01,alcud02,alcud03,alcud04,alcud05,
                  alcud06,alcud07,alcud08,alcud09,alcud10,
                  alcud11,alcud12,alcud13,alcud14,alcud15
                  #FUN-850038    ----end----
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(alc01) #PAY BANK
                  CALL q_ala(TRUE,TRUE,g_alc.alc01)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO alc01
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
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON all02,all44,all04,all05,all11,    #FUN-A60056 add all44
                         all83,all84,all85,all80,all81,all82,all86,all87,  #NO.FUN-710029
                         all06,all07,all08,all12,all13,all930 #FUN-680019
                         #No.FUN-850038 --start--
                         ,allud01,allud02,allud03,allud04,allud05
                         ,allud06,allud07,allud08,allud09,allud10
                         ,allud11,allud12,allud13,allud14,allud15
                         #No.FUN-850038 ---end---
           FROM s_all[1].all02,s_all[1].all44,s_all[1].all04,s_all[1].all05,   #FUN-A60056 add all44
                s_all[1].all11,
                s_all[1].all83,s_all[1].all84,s_all[1].all85,s_all[1].all80,  #NO.FUN-710029
                s_all[1].all81,s_all[1].all82,s_all[1].all86,s_all[1].all87,  #NO.FUN-710029
                s_all[1].all06,s_all[1].all07,
                s_all[1].all08,s_all[1].all12,s_all[1].all13,
                s_all[1].all930 #FUN-680019
               #No.FUN-850038 --start--
               ,s_all[1].allud01,s_all[1].allud02,s_all[1].allud03
               ,s_all[1].allud04,s_all[1].allud05,s_all[1].allud06
               ,s_all[1].allud07,s_all[1].allud08,s_all[1].allud09
               ,s_all[1].allud10,s_all[1].allud11,s_all[1].allud12
               ,s_all[1].allud13,s_all[1].allud14,s_all[1].allud15
               #No.FUN-850038 ---end---
 
	 #No.FUN-580031 --start--     HCN
	 BEFORE CONSTRUCT
	    CALL cl_qbe_display_condition(lc_qbe_sn)
	 #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
              #FUN-A60056--add--str--
               WHEN INFIELD(all44)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw" 
                  LET g_qryparam.state = "c" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO all44
                  NEXT FIELD all44 
              #FUN-A60056--add--end
               WHEN INFIELD(all04)
                   #MOD-490420
                 #FUN-980094------------(S)
                 #CALL q_m_pmm5(TRUE,TRUE,g_all[1].all04,g_dbs_new,g_ala.ala05)
#MOD-B30393  ---begin---
#                 CALL q_m_pmm5(TRUE,TRUE,g_all[1].all04,g_plant,g_ala.ala05)
                 #FUN-980094------------(E)
#                 RETURNING g_all[1].all04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_all04_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_all[1].all04
#MOD-B30393    ---end---
                   DISPLAY g_all[1].all04 TO all04             #No.MOD-490344
                  #--
               WHEN INFIELD(all05)
                   #MOD-490420
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmn"
                  LET g_qryparam.default1 = g_all[1].all04
                  CALL cl_create_qry() RETURNING g_all[1].all05
                   DISPLAY g_all[1].all05 TO all05             #No.MOD-490344
                  #--
               WHEN INFIELD(all11)
                  #FUN-530065
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_all[1].all11
                  CALL cl_create_qry() RETURNING g_all[1].all11
                  DISPLAY g_all[1].all11 TO all11
                  NEXT FIELD all11
                  #--
#NO.FUN-710029 start---
               WHEN INFIELD(all80)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO all80
                   NEXT FIELD all80
               WHEN INFIELD(all86)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO all86
                   NEXT FIELD all86
#NO.FUN-710029 end-------
               #FUN-680019...............begin
               WHEN INFIELD(all930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO all930
                  NEXT FIELD all930
               #FUN-680019...............end
               OTHERWISE
                  EXIT CASE
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
  #str CHI-870010 add
   ELSE
      LET g_wc=" alc01='",g_argv1,"'"
      LET g_wc2=" 1=1"
   END IF
  #end CHI-870010 add
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND alcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND alcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND alcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alcuser', 'alcgrup')
   #End:FUN-980030
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT alc01,alc02 FROM alc_file ",
               #" WHERE ",g_wc CLIPPED, " ORDER BY alc01,alc02"   #MOD-640018
                " WHERE alc02 <> 0 AND ",g_wc CLIPPED, " ORDER BY alc01,alc02"  #MOD-640018 #CHI-AA0015 mod '0'->0
 
   ELSE
      LET g_sql="SELECT alc01,alc02",
                "  FROM alc_file,all_file ",
                " WHERE alc01=all01 ",
                "   AND alc02=all00 ",
                "   AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY alc01,alc02"
   END IF
   PREPARE t740_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t740_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t740_prepare
   IF g_wc2 = ' 1=1' THEN
      #LET g_sql = "SELECT COUNT(*) FROM alc_file WHERE ",g_wc CLIPPED   #MOD-640018
      LET g_sql = "SELECT COUNT(*) FROM alc_file WHERE alc02 <> 0 AND ",g_wc CLIPPED   #MOD-640018 #CHI-AA0015 mod '0'->0
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT alc01) FROM alc_file,all_file",
                  " WHERE alc01 = all01 AND alc02=all00",
                  "   AND alc02 <> 0 ",   #MOD-640018 #CHI-AA0015 mod '0'->0
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t740_precount FROM g_sql
   DECLARE t740_count CURSOR FOR t740_precount
END FUNCTION
 
FUNCTION t740_menu()
 
   WHILE TRUE
      CALL t740_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t740_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t740_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t740_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t740_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t740_b(g_alc.alc02)
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t740_out('o')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_all),'','')
             END IF
         #--
 
         WHEN "gen_entry"
            CALL t740_g_gl(g_alc.alc01,6,g_alc.alc02)
         WHEN "maintain_entry"
            CALL s_fsgl('LC',6,g_alc.alc01,0,g_apz.apz02b,g_alc.alc02,
                 g_alc.alcfirm,'0',g_apz.apz02p)  #No.FUN-680029 add '0',g_apz.apz02p 
            CALL t740_npp02()
         #No.FUN-680029 --start--
         WHEN "maintain_entry2"
            CALL s_fsgl('LC',6,g_alc.alc01,0,g_apz.apz02c,g_alc.alc02,
                 g_alc.alcfirm,'1',g_apz.apz02p)    
            CALL t740_npp02()
         #No.FUN-680029 --end--
         WHEN "payment_acct"
            CALL t740_7(2)
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t740_firm1()
               #CALL cl_set_field_pic(g_alc.alcfirm,"","","","","")  #CHI-C80041
               IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
               CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"")  #CHI-C80041
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t740_firm2()
               #CALL cl_set_field_pic(g_alc.alcfirm,"","","","","")  #CHI-C80041
               IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
               CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"")  #CHI-C80041
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t740_m()
            END IF
         WHEN "payment_record"
            LET g_msg="aapt741 '",g_alc.alc01,"' ","'",g_alc.alc02,"' "
            #CALL cl_cmdrun(g_msg)        #FUN-660216 remark
            CALL cl_cmdrun_wait(g_msg)    #FUN-660216
         WHEN "qry_before_update_record"
            #-----MOD-650011---------
            IF g_alc.alc02 > 1 THEN
               LET g_alc02 = g_alc.alc02 - 1
               LET g_msg="aapq700 '",g_alc.alc01,"'","  '",g_alc02,"'"
               CALL cl_cmdrun(g_msg)
            END IF
            #LET g_msg="aapq700 '",g_alc.alc01,"'","  '",g_alc.alc02,"'"
            #CALL cl_cmdrun(g_msg)
            #-----END MOD-650011-----
         #--FUN-B10030--start--
         # WHEN "switch_plant"
         #   CALL t740_d()
         #--FUN--B10030--end--   
         #No.FUN-670060  --Begin                                                                                                    
         WHEN "carry_voucher"                                                                                                       
            IF cl_chk_act_auth() THEN
               IF g_alc.alcfirm = 'Y' THEN                                                                                            
                  CALL t740_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         WHEN "undo_carry_voucher"                                                                                                  
            IF cl_chk_act_auth() THEN
               IF g_alc.alcfirm = 'Y' THEN                                                                                            
                  CALL t740_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         #No.FUN-670060  --End 
         #No.FUN-6A0016----------add---------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_alc.alc01 IS NOT NULL THEN
                LET g_doc.column1 = "alc01"
                LET g_doc.column2 = "alc02"
                LET g_doc.value1 = g_alc.alc01
                LET g_doc.value2 = g_alc.alc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0016----------add---------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t740_x()
               IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"")   
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
      CLOSE t740_cs
END FUNCTION
 
FUNCTION t740_a()
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_all.clear()
   INITIALIZE g_alc.* LIKE alc_file.*
   LET g_alc01_t = NULL LET g_alc02_t = 0 #CHI-AA0015 mod '0'->0
   LET g_alc.alc08 = g_today
   LET g_alc.alc24 = 0 LET g_alc.alc34 = 0
   LET g_alc.alc51 = 1
   LET g_alc.alc52 = 0 LET g_alc.alc53 = 0 LET g_alc.alc54 = 0
   LET g_alc.alc55 = 0 LET g_alc.alc56 = 0 LET g_alc.alc57 = 0
   LET g_alc.alc60 = 0
   LET g_alc.alc78 = 'N'
   LET g_alc.alcmksg = 'N' LET g_alc.alcfirm = 'N'
   LET g_alc.alclegal=g_legal #FUN-980001 add
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_alc.alcacti ='Y'                   # 有效的資料
      LET g_alc.alcuser = g_user
      LET g_alc.alcoriu = g_user #FUN-980030
      LET g_alc.alcorig = g_grup #FUN-980030
      LET g_alc.alcgrup = g_grup               # 使用者所屬群
      LET g_alc.alcdate = g_today
      LET g_alc.alcinpd = g_today
      CALL t740_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_alc.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_all.clear()
         EXIT WHILE
      END IF
      IF g_alc.alc01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO alc_file VALUES(g_alc.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("ins","alc_file",g_alc.alc01,g_alc.alc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      ELSE
         LET g_alc_t.* = g_alc.*               # 保存上筆資料
         SELECT alc01,alc02 INTO g_alc.alc01,g_alc.alc02 FROM alc_file
          WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02 AND 
                alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
      END IF
      CALL g_all.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      CALL SET_COUNT(0)
      CALL t740_g_b()
      CALL t740_b_fill('1=1')
      CALL t740_b(g_alc.alc02)
      IF NOT cl_null(g_alc.alc01) THEN #CHI-C30002 加上不為空
         IF cl_confirm('aap-126') THEN CALL t740_out('a') END IF 
      END IF    #CHI-C30002 add
      CALL t740_firm1()
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t740_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,               #單別  #No.FUN-690028 VARCHAR(5)
                                               #No.FUN-550030
        #l_dept          VARCHAR(10),            #Dept   #FUN-660117 remark
        l_dept          LIKE ala_file.ala04,  #Dept   #FUN-660117
        l_nnp06         LIKE nnp_file.nnp06,
        l_amt           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
        l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0033			
 
    INPUT BY NAME g_alc.alcoriu,g_alc.alcorig,
             g_alc.alc01,g_alc.alc08,g_alc.alc02,g_alc.alcfirm,g_alc.alc72,
             g_alc.alc24,g_alc.alc34,g_alc.alc51,g_alc.alc52,
             g_alc.alc53,g_alc.alc54,g_alc.alc56,g_alc.alc60,g_alc.alc86,g_alc.alc32,   #MOD-4C0040
             g_alc.alcuser,g_alc.alcgrup,g_alc.alcmodu,g_alc.alcdate
             #FUN-850038     ---start---
            ,g_alc.alcud01,g_alc.alcud02,g_alc.alcud03,g_alc.alcud04,
             g_alc.alcud05,g_alc.alcud06,g_alc.alcud07,g_alc.alcud08,
             g_alc.alcud09,g_alc.alcud10,g_alc.alcud11,g_alc.alcud12,
             g_alc.alcud13,g_alc.alcud14,g_alc.alcud15 
             #FUN-850038     ----end----
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t740_set_entry(p_cmd)
         CALL t740_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#No.FUN-550030--begin
         CALL cl_set_docno_format("alc01")
#No.FUN-550030--end
 
        AFTER FIELD alc01
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_alc.alc01 != g_alc01_t) THEN
              IF NOT cl_null(g_alc.alc01) THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM alc_file
                  #WHERE alc01=g_alc.alc01 AND alcfirm='N'    #MOD-640018
                  WHERE alc01=g_alc.alc01 AND alcfirm='N' AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                 IF l_cnt>0 THEN
                    CALL cl_err(g_alc.alc01,'aap-239',0)
                    NEXT FIELD alc01
                 END IF
                 IF g_alc.alc01 IS NOT NULL THEN
                    SELECT ala01 INTO g_alc.alc01 FROM ala_file
                     WHERE ala03=g_alc.alc01
                    DISPLAY BY NAME g_alc.alc01
                 END IF
                 SELECT * INTO g_ala.* FROM ala_file
                  WHERE ala01 = g_alc.alc01
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err('sel ala:',STATUS,0)   #No.FUN-660122
                    CALL cl_err3("sel","ala_file",g_alc.alc01,"",STATUS,"","sel ala:",1)  #No.FUN-660122
                    NEXT FIELD alc01
                 END IF
                 IF g_ala.alafirm='N' THEN
                    CALL cl_err("alafirm='N'",'aap-717',0)
                    NEXT FIELD alc01
                 END IF
                 IF g_alc.alc43 IS NULL THEN
                    LET g_alc.alc43 = g_ala.ala43
                 END IF
                 #No.FUN-680029 --start--
                 IF g_aza.aza63 = 'Y' THEN
                    IF g_alc.alc431 IS NULL THEN
                       LET g_alc.alc431 = g_ala.ala431
                    END IF
                 END IF
                 #No.FUN-680029 --end--
                 IF g_ala.alaclos='Y' THEN
                    CALL cl_err("alaclos='Y':",'aap-165',0)
                    NEXT FIELD alc01
                 END IF
                 IF g_ala.alafirm = 'X' THEN
                    CALL cl_err("alafirm='X'",'9024',0)
                    NEXT FIELD alc01
                 END IF
                 DISPLAY BY NAME g_ala.ala20
                 DISPLAY BY NAME g_ala.ala03
                 DISPLAY BY NAME g_ala.ala04
                 DISPLAY BY NAME g_ala.ala930 #FUN-680019
                 DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b  #TQC-BB0264
                 IF cl_null(g_alc.alc02) THEN
                    SELECT MAX(alc02) INTO g_alc.alc02 FROM alc_file
                     #WHERE alc01=g_alc.alc01  #MOD-640018
                     WHERE alc01=g_alc.alc01  AND alc02 <> 0 #MOD-640018 #CHI-AA0015 mod '0'->0
                       AND alcfirm <> 'X'  #CHI-C80041
                    IF cl_null(g_alc.alc02) THEN
                       LET g_alc.alc02=0
                    END IF
                    LET g_alc.alc02=g_alc.alc02+1
                    DISPLAY BY NAME g_alc.alc02
                 END IF
              END IF
            END IF
 
        AFTER FIELD alc02
           IF NOT cl_null(g_alc.alc02) THEN
              #IF g_alc.alc02 NOT MATCHES '[0-9]' THEN   #MOD-640018
              #CHI-AA0015 mark --start--
              #IF g_alc.alc02 NOT MATCHES '[1-9]' THEN   #MOD-640018
              #   NEXT FIELD alc02
              #END IF
              #CHI-AA0015 mark --end--
              IF (g_alc.alc01 != g_alc01_t) OR (g_alc.alc02 != g_alc02_t) OR
                 (g_alc01_t IS NULL) THEN
                 SELECT count(*) INTO g_cnt FROM alc_file
                     WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02 AND 
                           alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                 IF g_cnt > 0 THEN                   # 資料重複
                    CALL cl_err('',-239,0)
                    LET g_alc.alc01 = g_alc01_t
                    LET g_alc.alc02 = g_alc02_t
                    DISPLAY BY NAME g_alc.alc01,g_alc.alc02
                    NEXT FIELD alc01
                 END IF
              END IF
           END IF
 
        AFTER FIELD alc24
           IF NOT cl_null(g_alc.alc24) THEN
              LET g_alc.alc34 = g_alc.alc24 * g_ala.ala21/100
              DISPLAY BY NAME g_alc.alc34
           END IF
 
        AFTER FIELD alc51
           IF NOT cl_null(g_alc.alc51) THEN
              LET g_alc.alc52 = g_alc.alc34 * g_alc.alc51
              LET g_alc.alc52 = cl_digcut(g_alc.alc52,g_azi04)
              DISPLAY BY NAME g_alc.alc52
              SELECT nnp06 INTO l_nnp06 FROM nnp_file
               WHERE nnp01=g_ala.ala33 AND nnp03=g_ala.ala35
              LET g_alc.alc53 = g_alc.alc24 * l_nnp06/100 * g_alc.alc51
              DISPLAY BY NAME g_alc.alc53
              CALL t740_alc60()
           END IF
 
        AFTER FIELD alc56
           IF NOT cl_null(g_alc.alc56) THEN
              CALL t740_alc60()
           END IF
        #No.FUN-730064--begin
        AFTER FIELD alc86 
#          CALL s_get_bookno(g_alc.alc86)
#               RETURNING g_flag,g_bookno1,g_bookno2
           CALL t740_bookno()   #No.FUN-730064
#          IF g_flag = '1' THEN
#             CALL cl_err(g_alc.alc86,'aoo-081',1)
#             NEXT FIELD alc86
#          END IF
        #No.FUN-730064--END   
        
        #FUN-850038     ---start---
        AFTER FIELD alcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          #CHI-AA0015 mark --start--
          #CASE
          #   WHEN INFIELD(alc02) # 序號
          #      #IF cl_null(g_alc.alc02) OR g_alc.alc02 NOT MATCHES '[0-9]' THEN   #MOD-640018
          #      IF cl_null(g_alc.alc02) OR g_alc.alc02 NOT MATCHES '[1-9]' THEN   #MOD-640018
          #         DISPLAY BY NAME g_alc.alc02
          #         NEXT FIELD alc02
          #      END IF
          #      #CHI-AA0015 mark --end--
          #   OTHERWISE EXIT CASE
          #END CASE
          #CHI-AA0015 mark --end--
           LET g_alc.alcuser = s_get_data_owner("alc_file") #FUN-C10039
           LET g_alc.alcgrup = s_get_data_group("alc_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
 
        ON KEY(F1)
           NEXT FIELD alc01
 
        ON KEY(F2)
           NEXT FIELD alc32
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #   IF INFIELD(alc01) THEN
        #      LET g_alc.* = g_alc_t.*
        #      CALL t740_show()
        #      NEXT FIELD alc01
        #   END IF
        #-----END FUN-630081-----
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(alc01) #PAY BANK
                 CALL q_ala(FALSE,TRUE,g_ala.ala01) RETURNING g_alc.alc01
                 DISPLAY BY NAME g_alc.alc01
 
              #FUN-4B0054
              WHEN INFIELD(alc51)
                 CALL s_rate(g_ala.ala20,g_alc.alc51)
                 RETURNING g_alc.alc51
                 DISPLAY BY NAME g_alc.alc51
              #--
              OTHERWISE EXIT CASE
           END CASE
 
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
 
FUNCTION t740_alc60()
   IF g_alc.alc78='Y' THEN
      LET g_alc.alc60 = g_alc.alc56 + g_alc.alc85 + g_alc.alc95
   ELSE
      LET g_alc.alc60 = g_alc.alc52 + g_alc.alc53 + g_alc.alc54 +
                        g_alc.alc55 + g_alc.alc56 + g_alc.alc57
   END IF
   DISPLAY BY NAME g_alc.alc60
END FUNCTION
 
FUNCTION t740_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_alc.* TO NULL             #No.FUN-6A0016
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t740_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_all.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t740_count
   FETCH t740_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t740_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
      INITIALIZE g_alc.* TO NULL
   ELSE
      CALL t740_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t740_fetch(p_flalc)
   DEFINE
       p_flalc         LIKE type_file.chr1        # No.FUN-690028  VARCHAR(1)
 
   CASE p_flalc
      WHEN 'N' FETCH NEXT     t740_cs INTO g_alc.alc01,g_alc.alc02
      WHEN 'P' FETCH PREVIOUS t740_cs INTO g_alc.alc01,g_alc.alc02
      WHEN 'F' FETCH FIRST    t740_cs INTO g_alc.alc01,g_alc.alc02
      WHEN 'L' FETCH LAST     t740_cs INTO g_alc.alc01,g_alc.alc02
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump t740_cs INTO g_alc.alc01,g_alc.alc02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
      INITIALIZE g_alc.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flalc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   #No.FUN-730064--begin                                                                                                       
#          CALL s_get_bookno(g_alc.alc86)                                                                                           
#               RETURNING g_flag,g_bookno1,g_bookno2                                                                                
#          IF g_flag = '1'  THEN                                                                                                        
#             CALL cl_err(g_alc.alc86,'aoo-081',1)                                                                                  
#          END IF                                                                                                                   
        #No.FUN-730064--END 
 
   SELECT * INTO g_alc.* FROM alc_file   # 重讀DB,因TEMP有不被更新特性
    WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
      CALL cl_err3("sel","alc_file",g_alc.alc01,g_alc.alc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
   ELSE
      LET g_data_owner = g_alc.alcuser     #No.FUN-4C0047
      LET g_data_group = g_alc.alcgrup     #No.FUN-4C0047
      #No.FUN-730064---begin--                                                                                                     
#           CALL s_get_bookno(g_alc.alc86)                                                                                    
#                RETURNING g_flag,g_bookno1,g_bookno2                                                                               
#           IF g_flag = "1" THEN    #抓不到帳別                                                                                     
#              CALL cl_err(g_alc.alc86,'aoo-081',1)                                                                                 
#           END IF                                                                                                                  
       #No.FUN-730064---end--  
      CALL t740_bookno()              #No.FUN-730064
      CALL t740_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t740_show()
   IF cl_null(g_alc.alc02) THEN  LET g_alc.alc02 = 0 END IF
   LET g_alc_t.* = g_alc.*
   SELECT * INTO g_ala.* FROM ala_file
    WHERE ala01 = g_alc.alc01
   IF STATUS THEN INITIALIZE g_ala.* TO NULL END IF
   DISPLAY BY NAME g_alc.alcoriu,g_alc.alcorig, g_ala.ala03,g_ala.ala04,g_ala.ala20, g_ala.ala930 #FUN-680019
   DISPLAY BY NAME g_alc.alc01,g_alc.alc02,g_alc.alc08,g_alc.alc32,g_alc.alc24,
                   g_alc.alc34,g_alc.alc72,g_alc.alc51,g_alc.alc52,g_alc.alc53,
                    g_alc.alc54,g_alc.alc56,g_alc.alc60,g_alc.alcfirm,g_alc.alc86,   #MOD-4C0040
                   g_alc.alcuser,g_alc.alcgrup,g_alc.alcmodu,g_alc.alcdate
                   #FUN-850038     ---start---
                   ,g_alc.alcud01,g_alc.alcud02,g_alc.alcud03,g_alc.alcud04,
                   g_alc.alcud05,g_alc.alcud06,g_alc.alcud07,g_alc.alcud08,
                   g_alc.alcud09,g_alc.alcud10,g_alc.alcud11,g_alc.alcud12,
                   g_alc.alcud13,g_alc.alcud14,g_alc.alcud15 
                   #FUN-850038     ----end----
   CALL t740_b_tot()
   CALL t740_b_fill(g_wc2)
   #CALL cl_set_field_pic(g_alc.alcfirm,"","","","","")  #CHI-C80041 
   IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"")  #CHI-C80041 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t740_u()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_alc.alc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_alc.* FROM alc_file
    WHERE alc01=g_alc.alc01
      AND alc02=g_alc.alc02
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   IF g_alc.alcfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_alc.alcfirm='Y' THEN
      CALL cl_err('','axm-101',0)
      RETURN
   END IF
   IF g_alc.alcacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_alc.alc01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t740_cl USING g_alc.alc01,g_alc.alc02
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   LET g_alc01_t = g_alc.alc01
   LET g_alc02_t = g_alc.alc02
   LET g_alc_o.*=g_alc.*
   LET g_alc.alcmodu=g_user                     #修改者
   LET g_alc.alcdate = g_today                  #修改日期
   CALL t740_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t740_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_alc.*=g_alc_t.*
         CALL t740_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE alc_file SET alc_file.* = g_alc.*    # 更新DB
       WHERE alc01 = g_alc01_t AND alc02 = g_alc02_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("upd","alc_file",g_alc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
      IF g_alc_t.alc08 != g_alc.alc08 THEN
          UPDATE npp_file SET npp02=g_alc.alc86    #MOD-4C0040 異動日期改以會計日期為基準
          WHERE npp01=g_alc.alc01 AND npp011=g_alc.alc02
            AND npp00 = 6         AND nppsys = 'LC'
         IF STATUS THEN
#           CALL cl_err('upd npp02:',STATUS,1)   #No.FUN-660122
            CALL cl_err3("upd","npp_file",g_alc01_t,g_alc02_t,STATUS,"","upd npp02:",1)  #No.FUN-660122
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t740_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t740_npp02()
 
   IF cl_null(g_alc.alc72) THEN
       UPDATE npp_file SET npp02=g_alc.alc86   #MOD-4C0040 異動日期以會計日期為基準
       WHERE npp01=g_alc.alc01 AND npp011=g_alc.alc02
         AND npp00 = 6         AND nppsys = 'LC'
      IF STATUS THEN 
#     CALL cl_err('upd npp02:',STATUS,1)  #No.FUN-660122
      CALL cl_err3("upd","npp_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd npp02:",1)  #No.FUN-660122
      END IF
   END IF
END FUNCTION
 
FUNCTION t740_r()
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_alc.alc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_alc.* FROM alc_file
    WHERE alc01=g_alc.alc01
      AND alc02=g_alc.alc02
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   IF g_alc.alcfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_alc.alcfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_ala.alaclos = 'Y' THEN
      CALL cl_err(g_alc.alc01,'aap-197',0)
      RETURN
   END IF
   BEGIN WORK
   OPEN t740_cl USING g_alc.alc01,g_alc.alc02
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_alc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   CALL t740_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "alc01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "alc02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_alc.alc01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_alc.alc02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM alc_file WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
      IF STATUS THEN 
#     CALL cl_err('del alc:',STATUS,0)  #No.FUN-660122
      CALL cl_err3("del","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","del alc:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM all_file WHERE all01 = g_alc.alc01 AND all00 = g_alc.alc02
      IF STATUS THEN 
#     CALL cl_err('del all:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","all_file",g_alc.alc01,g_alc.alc02,STATUS,"","del all:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM npp_file WHERE npp01 = g_ala.ala01
                             AND npp011= g_alc.alc02
                             AND nppsys='LC'
                             #AND npp00 = 6   #MOD-780050
                             AND (npp00 = 6 OR npp00 = 7)   #MOD-780050
      IF STATUS THEN 
#     CALL cl_err('del npp:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npp_file",g_alc.alc01,g_alc.alc02,STATUS,"","del npp:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM npq_file WHERE npq01 = g_ala.ala01
                             AND npq011= g_alc.alc02
                             AND npqsys='LC'
                             #AND npq00 = 6   #MOD-780050
                             AND (npq00 = 6 OR npq00 = 7)   #MOD-780050
      IF STATUS THEN 
#     CALL cl_err('del npq:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npq_file",g_alc.alc01,g_alc.alc02,STATUS,"","del npq:",1)  #No.FUN-660122
      RETURN END IF
#FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_ala.ala01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_alc.alc01,g_alc.alc02,STATUS,"","del tic:",1)
         RETURN   
      END IF
#FUN-B40056--add--end--

      #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
       #VALUES ('saapt740',g_user,g_today,g_msg,g_alc.alc01,'delete') #FUN-980001 mark 
       VALUES ('saapt740',g_user,g_today,g_msg,g_alc.alc01,'delete',g_plant,g_legal) #FUN-980001 add
      CLEAR FORM
      CALL g_all.clear()
      INITIALIZE g_alc.* TO NULL
      OPEN t740_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t740_cs  
         CLOSE t740_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t740_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t740_cs  
         CLOSE t740_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t740_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t740_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t740_fetch('/')
      END IF
   END IF
   CLOSE t740_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t740_m()
   DEFINE i,j            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_ac,l_sql,l_n  LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
          g_apd_t   RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
          l_ac_t         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
 
   IF g_alc.alc01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t740_m_w AT 8,30 WITH FORM "aap/42f/aapt710_3"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt710_3")
 
 
   DECLARE t740_m_c CURSOR FOR
           SELECT apd02,apd03,'' FROM apd_file
            WHERE apd01 = g_alc.alc01
            ORDER BY apd02
   LET i = 1
   FOREACH t740_m_c INTO g_apd[i].*
      LET i = i + 1
      IF i > 30 THEN
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_apd.deleteElement(i)
   LET g_rec_b = i - 1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_apd WITHOUT DEFAULTS FROM s_apd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD apd02
 
      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t740_m_w
      RETURN
   END IF
 
   CLOSE WINDOW t740_m_w
 
   LET j = ARR_COUNT()
 
   BEGIN WORK
 
   LET g_success = 'Y'
   WHILE TRUE
      DELETE FROM apd_file
       WHERE apd01 = g_alc.alc01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
#        CALL cl_err('t740_m(ckp#1):',SQLCA.sqlcode,1)   #No.FUN-660122
         CALL cl_err3("del","apd_file",g_alc.alc01,"",SQLCA.sqlcode,"","t740_m(ckp#1)",1)  #No.FUN-660122
         EXIT WHILE
      END IF
      FOR i = 1 TO g_apd.getLength()
         IF cl_null(g_apd[i].apd03) THEN CONTINUE FOR END IF
         IF g_apd[i].apd02 <= 0     THEN CONTINUE FOR END IF
         #INSERT INTO apd_file (apd01,apd02,apd03) #FUN-980001 mark
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add
                #VALUES(g_alc.alc01,g_apd[i].apd02,g_apd[i].apd03) #FUN-980001 mark
                VALUES(g_alc.alc01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err('t740_m(ckp#2):',SQLCA.sqlcode,1)   #No.FUN-660122
            CALL cl_err3("ins","apd_file",g_alc.alc01,"",SQLCA.sqlcode,"","t740_m(ckp#2)",1)  #No.FUN-660122
            EXIT WHILE
         END IF
      END FOR
      EXIT WHILE
   END WHILE
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t740_7(p_sw)
   DEFINE p_sw      LIKE type_file.chr1              # 1.不要update alc 2.要update alc  #No.FUN-690028 VARCHAR(1)
   #DEFINE aag02_1 VARCHAR(30)            #FUN-660117 remark
   DEFINE aag02_1  LIKE aag_file.aag02 #FUN-660117
   DEFINE aag02_2  LIKE aag_file.aag02 #No.FUN-680029
   DEFINE o_alc RECORD LIKE alc_file.*
 
   IF g_alc.alc01 IS NULL THEN RETURN END IF
 
   SELECT * INTO g_alc.* FROM alc_file
   WHERE alc01=g_alc.alc01
     AND alc02=g_alc.alc02
     AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
 
   LET o_alc.*=g_alc.*
 
 
   OPEN WINDOW t740_7_w AT 8,3 WITH FORM "aap/42f/aapt740c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt740c")
 
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("alc431,aag02_2",FALSE)
    END IF
    #No.FUN-680029 --end--
 
   SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alc.alc43
                                             AND aag00=g_bookno1    # No.FUN-730064
   DISPLAY BY NAME aag02_1
   #No.FUN-680029 --start--
   SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alc.alc431 
                                             AND aag00=g_bookno2     # No.FUN-730064
   DISPLAY BY NAME aag02_2
   #No.FUN-680029 --end--
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME g_alc.alc43,g_alc.alc431,g_alc.alc73 WITHOUT DEFAULTS  #No.FUN-680029 add g_alc.alc431
 
      AFTER FIELD alc43
         IF NOT cl_null(g_alc.alc43) THEN
            SELECT aag02 INTO aag02_1 FROM aag_file WHERE aag01=g_alc.alc43 
                                                      AND aag00=g_bookno1      # No.FUN-730064
              IF STATUS THEN 
#             CALL cl_err('sel aag:',STATUS,0)   #No.FUN-660122
              CALL cl_err3("sel","aag_file",g_alc.alc43,"",STATUS,"","sel aag:",1)  #No.FUN-660122
               NEXT FIELD alc43
            END IF
            DISPLAY BY NAME aag02_1
         END IF
 
      #No.FUN-680029 --start--
      AFTER FIELD alc431
         IF NOT cl_null(g_alc.alc431) THEN
            SELECT aag02 INTO aag02_2 FROM aag_file WHERE aag01=g_alc.alc431
                                                      AND aag00=g_bookno2      # No.FUN-730064
              IF STATUS THEN 
              CALL cl_err3("sel","aag_file",g_alc.alc431,"",STATUS,"","sel aag:",1)
               NEXT FIELD alc431
            END IF
            DISPLAY BY NAME aag02_2
         END IF
      #No.FUN-680029 --end--
 
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
 
   CLOSE WINDOW t740_7_w
 
   IF INT_FLAG THEN LET INT_FLAG=0 LET g_alc.*=o_alc.* RETURN END IF
 
   IF p_sw = '1' THEN RETURN END IF
   UPDATE alc_file SET alc43=g_alc.alc43,
                       alc73=g_alc.alc73
    WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' THEN
      UPDATE alc_file SET alc431 =g_alc.alc431
       WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
   END IF
   #No.FUN-680029 --end--
 
END FUNCTION
 
FUNCTION t740_firm1()
 
   IF cl_null(g_alc.alc01) THEN RETURN END IF
   IF g_alc.alcfirm='Y' THEN RETURN END IF           #CHI-C30107 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF   #CHI-C30107 add
   SELECT * INTO g_alc.* FROM alc_file
    WHERE alc01=g_alc.alc01
      AND alc02=g_alc.alc02
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   IF g_alc.alcfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_alc.alcfirm='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alc.alc08<=g_apz.apz57 THEN
      CALL cl_err(g_alc.alc01,'aap-176',1) RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM all_file
    WHERE all01=g_alc.alc01 AND all00=g_alc.alc02
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF   #CHI-C30107  mark
   LET g_success='Y'
   BEGIN WORK
   OPEN t740_cl USING g_alc.alc01,g_alc.alc02
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   #CALL s_chknpq1(g_alc.alc01,g_alc.alc02,6,'0',p_bookno)  #No.FUN-680029 add '0' #No.FUN-730064 add 'p_bookno'   #MOD-780050
   CALL s_chknpq1(g_alc.alc01,g_alc.alc02,6,'0',g_bookno1)  #No.FUN-680029 add '0' #No.FUN-730064 add 'p_bookno'   #MOD-780050
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      #CALL s_chknpq1(g_alc.alc01,g_alc.alc02,6,'1',p_bookno)  ##No.FUN-730064 add 'p_bookno'   #MOD-780050
      CALL s_chknpq1(g_alc.alc01,g_alc.alc02,6,'1',g_bookno2)  ##No.FUN-730064 add 'p_bookno'   #MOD-780050
   END IF
   #No.FUN-680029 --end--
 
   IF g_success = 'N' THEN
      ROLLBACK WORK RETURN
   END IF
   CALL t740_b_tot()
 
   UPDATE alc_file SET alcfirm = 'Y'
    WHERE alc01=g_alc.alc01 AND alc02=g_alc.alc02
   IF STATUS THEN
#     CALL cl_err('upd ala:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd ala:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   #-----MOD-640018---------
   IF g_alc.alc02 = 1 THEN #CHI-AA0015 mod '1'->1
      CALL t740_hu_ala_all1()
   END IF
   #-----END MOD-640018-----
   CALL t740_hu1_ala()
   CALL t740_hu1_alb()   #MOD-640018
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_alc.alcfirm='Y'
      DISPLAY BY NAME g_alc.alcfirm
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t740_firm2()
   DEFINE l_alc72   LIKE alc_file.alc72,
          l_alc02   LIKE alc_file.alc02
 
   IF cl_null(g_alc.alc01) THEN RETURN END IF
   SELECT * INTO g_alc.* FROM alc_file
    WHERE alc01=g_alc.alc01
      AND alc02=g_alc.alc02
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   IF g_alc.alcfirm='N' THEN RETURN END IF
   IF g_alc.alcfirm='X' THEN RETURN END IF  #CHI-C80041
   #-----MOD-780050---------
   IF g_alc.alc78='Y' THEN
      CALL cl_err(g_alc.alc01,'mfg-013',0)
      RETURN
   END IF
   #-----END MOD-780050-----
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_alc.alc08<=g_apz.apz57 THEN
      CALL cl_err(g_alc.alc01,'aap-176',1) RETURN
   END IF
   LET l_alc02 = 0
   SELECT MAX(alc02) INTO l_alc02 FROM alc_file
    WHERE alc01=g_alc.alc01 AND 
          alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
      AND alcfirm <> 'X'  #CHI-C80041
   IF cl_null(l_alc02) THEN LET l_alc02 = 0 END IF
   IF l_alc02 > g_alc.alc02 THEN CALL cl_err('','aap-709',0) RETURN END IF
   SELECT alc72 INTO l_alc72 FROM alc_file
    WHERE alc01=g_alc.alc01
      AND alc02=g_alc.alc02
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
#  IF NOT cl_null(l_alc72) THEN RETURN END IF   No.FUN-670060
 
   #No.FUN-670060  --Begin                                                                                                          
   IF NOT cl_null(g_alc.alc72) THEN                                                                                                 
      CALL cl_err(g_alc.alc01,'axr-370',0) RETURN                                                                                
   END IF                                                                                                                           
   #No.FUN-670060  --End 
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
   OPEN t740_cl USING g_alc.alc01,g_alc.alc02
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE alc_file SET alcfirm = 'N'
    WHERE alc01=g_alc.alc01 AND alc02=g_alc.alc02
   IF STATUS THEN
#     CALL cl_err('upd ala:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd ala:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   CALL t740_hu2_ala()
   CALL t740_hu2_alb()    #MOD-640018
   #-----MOD-640018---------
   IF g_alc.alc02 = 1 THEN #CHI-AA0015 mod '1'->1
      CALL t740_hu_ala_all2()
   END IF
   #-----END MOD-640018-----
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_alc.alcfirm='N'
      DISPLAY BY NAME g_alc.alcfirm
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t740_hu1_ala()
   #-----MOD-6B0095---------
   DEFINE t_alc24 LIKE alc_file.alc24
   DEFINE t_alc60 LIKE alc_file.alc60
 
   SELECT SUM(alc24),SUM(alc60) INTO t_alc24,t_alc60 FROM alc_file
     WHERE alc01 = g_alc.alc01 AND alcfirm='Y' AND alc02 <= g_alc.alc02
   IF STATUS THEN
      LET t_alc24 = 0
      LET t_alc60 = 0
   END IF
   #UPDATE ala_file SET ala24=g_alc.alc24,
   #                    ala60=g_alc.alc60
   UPDATE ala_file SET ala24=t_alc24,
                       ala60=t_alc60
   #-----END MOD-6B0095-----
    WHERE ala01=g_alc.alc01
   IF STATUS THEN
#     CALL cl_err('upd ala24:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","ala_file",g_alc.alc01,"",STATUS,"","upd ala24:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t740_hu2_ala()
   DEFINE t_alc24 LIKE alc_file.alc24
   DEFINE t_alc60 LIKE alc_file.alc60
 
   #SELECT alc24,alc60 INTO t_alc24,t_alc60 FROM alc_file   #MOD-6B0095
   SELECT SUM(alc24),SUM(alc60) INTO t_alc24,t_alc60 FROM alc_file   #MOD-6B0095
    WHERE alc01=g_alc.alc01 AND alcfirm='Y' AND alc02 = g_alc.alc02-1 AND
          alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
   IF STATUS THEN
      LET t_alc24 = 0 LET t_alc60 = 0
   END IF
   UPDATE ala_file SET ala24=t_alc24,
                       ala60=t_alc60
    WHERE ala01=g_alc.alc01
   IF STATUS THEN
#     CALL cl_err('upd ala24:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","ala_file",g_alc.alc01,"",STATUS,"","upd ala24:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t740_hu1_alb()
  DEFINE l_all  RECORD LIKE all_file.*
 
  DELETE FROM alb_file WHERE alb01 = g_alc.alc01
  INSERT INTO alb_file (alb01,alb02,alb04,alb05,alb06,alb07,alb08,alb11,
                        alb80,alb81,alb82,alb83,alb84,alb85,                #MOD-CB0008 add
                        alb12,alb13,alb930,alblegal,alb86,alb87)            #FUN-680019 #FUN-980001 add legal #MOD-C30018 alb86/alb87
                 SELECT all01,all02,all04,all05,all06,all07,all08,all11,
                        all80,all81,all82,all83,all84,all85,                #MOD-CB0008 add
                        all12,all13,all930,alllegal,all86,all87             #FUN-680019 #FUN-980001 add legal #MOD-C30018 all86/all87
                   FROM all_file,alc_file
                  WHERE all01=alc01  AND all00=alc02
                    AND all00=g_alc.alc02 AND all01=g_alc.alc01
  IF STATUS THEN
#    CALL cl_err('ins alb',STATUS,0)    #No.FUN-660122
     CALL cl_err3("ins","alb_file",g_alc.alc02,g_alc.alc01,STATUS,"","ins alb",1)  #No.FUN-660122
     LET g_success = 'N'
  END IF
END FUNCTION
 
#-----MOD-640018---------
FUNCTION t740_hu2_alb()
 DEFINE l_all  RECORD LIKE all_file.*
 
 DELETE FROM alb_file WHERE alb01 = g_alc.alc01
 INSERT INTO alb_file (alb01,alb02,alb04,alb05,alb06,alb07,alb08,alb11,
                       alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87,  #FUN-710029
                       alb12,alb13,alb930,alblegal)           #FUN-680019 #FUN-980001 add legal #MOD-C30018 alb86/alb87  #TQC-C70191 movie alb86/alb87
                SELECT all01,all02,all04,all05,all06,all07,all08,all11,
                       all80,all81,all82,all83,all84,all85,all86,all87,  #FUN-710029
                       all12,all13,all930,alllegal            #FUN-680019 #FUN-980001 add legal #MOD-C30018 all86/all87  #TQC-C70191 movie alb86/alb87
                  FROM all_file,alc_file
                 WHERE all01=alc01  AND all00=alc02
                   AND all00=g_alc.alc02-1  AND all01=g_alc.alc01
 IF STATUS THEN
#   CALL cl_err('ins alb',STATUS,0)    #No.FUN-660122
    CALL cl_err3("ins","alb_file",g_alc.alc02-1,g_alc.alc01,STATUS,"","ins alb",1)  #No.FUN-660122
    LET g_success = 'N'
 END IF
END FUNCTION
 
FUNCTION t740_hu_ala_all1()
 
DEFINE l_alc   RECORD LIKE alc_file.*,
      l_all   RECORD LIKE all_file.*,
      l_sql   STRING
 
  LET l_alc.alc01 = g_alc.alc01
  LET l_alc.alc08 = g_alc.alc08
  LET l_alc.alc02 = 0 #CHI-AA0015 mod '0'->0
  LET l_alc.alc24=0
  LET l_alc.alc34=0
  LET l_alc.alc51=0
  LET l_alc.alc52=0
  LET l_alc.alc53=0
  LET l_alc.alc54=0
  LET l_alc.alc56=0
  LET l_alc.alc60=0
  LET l_alc.alcfirm='Y'
  LET l_alc.alclegal=g_legal #FUN-980001 add
 
  LET l_alc.alcoriu = g_user      #No.FUN-980030 10/01/04
  LET l_alc.alcorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO alc_file VALUES(l_alc.*)
  IF SQLCA.sqlcode THEN
#    CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
     CALL cl_err3("ins","alc_file",l_alc.alc01,l_alc.alc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
     LET g_success = 'N'
  END IF
 
  LET l_sql = "SELECT alb02,alb04,alb05,alb06,alb07,alb08,alb11,alb12,alb13,alb930, ", #FUN-680019
              "       alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87 ",  #FUN-710029
              "   FROM alb_file WHERE alb01='",g_alc.alc01,"'"
  PREPARE alc_p FROM l_sql
  DECLARE alc_c CURSOR FOR alc_p
  FOREACH alc_c
     INTO l_all.all02,l_all.all04,l_all.all05,l_all.all06,
          l_all.all07,l_all.all08,l_all.all11,l_all.all12,
          l_all.all13,l_all.all930, #FUN-680019
          l_all.all80,l_all.all81,l_all.all82,l_all.all83,  #FUN-710029
          l_all.all84,l_all.all85,l_all.all86,l_all.all87  #FUN-710029
           
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
        LET g_success = 'N'
     END IF
 
     INSERT INTO all_file(all00,all01,all02,all04,all05,all06,all07,
                          all08,all11,all12,all13,all930, #FUN-680019
                 all80,all81,all82,all83,all84,all85,all86,all87,alllegal)  #FUN-710029 #FUN-9A0099
            VALUES(l_alc.alc02,l_alc.alc01,l_all.all02,l_all.all04,l_all.all05,
                   l_all.all06,l_all.all07,l_all.all08,l_all.all11,l_all.all12,
                   l_all.all13,l_all.all930, #FUN-680019
                   l_all.all80,l_all.all81,l_all.all82,l_all.all83,   #FUN-710029
                   l_all.all84,l_all.all85,l_all.all86,l_all.all87,g_legal)   #FUN-710029  #FUN-9A0099 
     IF SQLCA.sqlcode THEN
#       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("ins","all_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        LET g_success = 'N'
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION t740_hu_ala_all2()
     DELETE FROM alc_file WHERE alc01 = g_alc.alc01 AND alc02 = 0 #CHI-AA0015 mod '0'->0
     IF SQLCA.sqlcode THEN
#       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("del","alc_file",g_alc.alc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        LET g_success = 'N'
     END IF
     DELETE FROM all_file WHERE all01 = g_alc.alc01 AND all00 = 0 #CHI-AA0015 mod '0'->0
     IF SQLCA.sqlcode THEN
#       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("del","all_file",g_alc.alc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        LET g_success = 'N'
     END IF
END FUNCTION
#-----END MOD-640018-----
 
 
FUNCTION t740_out(p_cmd)
   DEFINE l_cmd                LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_wc,l_wc2      LIKE type_file.chr50,   #No.FUN-690028 VARCHAR(50)
          p_cmd         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_prtway        LIKE type_file.chr1        # No.FUN-690028   VARCHAR(1)
 
   CALL cl_wait()
   #LET l_cmd= "aapr701",  #FUN-C30085 mark
   LET l_cmd= "aapg701", #FUN-C30085 add
              " '",g_today CLIPPED,"' ''",
              " '",g_lang CLIPPED,"' 'Y' '' '1' 'alc01="  
   LET l_cmd=l_cmd CLIPPED,'"',g_alc.alc01,'"'  
   LET l_cmd=l_cmd CLIPPED,"' "   
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
FUNCTION t740_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno      LIKE alc_file.alc01
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 4
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE l_buf            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_alcfirm     LIKE alc_file.alcfirm
   DEFINE l_n              LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET g_success = 'Y'  #No.FUN-680029
   
   IF p_apno IS NULL THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   SELECT alcfirm INTO l_alcfirm FROM alc_file
    WHERE alc01=p_apno
      AND alc02=p_sw2
   IF l_alcfirm='X' THEN RETURN END IF  #CHI-C80041
   IF l_alcfirm='Y' THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   BEGIN WORK  #No.FUN-680029
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_apno AND npp00 = p_sw1 AND nppsys = 'LC'
      AND npp011= p_sw2
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN
         LET g_success = 'N'  #No.FUN-680029
         RETURN
      END IF  #Genero
#FUN-B40056--add--str--
     LET l_n = 0
     SELECT COUNT(*) INTO l_n FROM tic_file
      WHERE tic04 = p_apno
     IF l_n > 0 THEN
        IF NOT cl_confirm('sub-533') THEN
           LET g_success = 'N' 
           RETURN
        ELSE
           DELETE FROM tic_file WHERE tic04 = p_apno
           IF STATUS THEN
              CALL cl_err3("del","tic_file","","",STATUS,"","",1)
              LET g_success = 'N' 
              ROLLBACK WORK
              RETURN
           END IF
        END IF
     END IF
#FUN-B40056--add--end--
      DELETE FROM npp_file WHERE npp01 = p_apno
                             AND npp011= p_sw2
                             AND nppsys='LC'
                             AND npp00 = p_sw1
      IF STATUS THEN 
#     CALL cl_err('del npp:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npp_file",p_apno,p_sw2,STATUS,"","del npp:",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      ROLLBACK WORK  #No.FUN-680029
      RETURN END IF
      DELETE FROM npq_file WHERE npq01 = p_apno
                             AND npq011= p_sw2
                             AND npqsys='LC'
                             AND npq00 = p_sw1
      IF STATUS THEN 
#     CALL cl_err('del npq:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npq_file",p_apno,p_sw2,STATUS,"","del npq:",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      ROLLBACK WORK  #No.FUN-680029
      RETURN END IF
   END IF
   IF p_sw1='6' THEN
      CALL t740_g_gl_1(p_apno,p_sw1,p_sw2,'0')  #No.FUN-680029 add '0'
      #No.FUN-680029 --start--
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL t740_g_gl_1(p_apno,p_sw1,p_sw2,'1')
      END IF
      #No.FUN-680029 --end--
   ELSE
      CALL t740_g_gl_2(p_apno,p_sw1,p_sw2,'0')  #No.FUN-680029 add '0'
      #No.FUN-680029 --start--
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL t740_g_gl_2(p_apno,p_sw1,p_sw2,'1')
      END IF
      #No.FUN-680029 --end--
   END IF
   #No.FUN-680029 --start--
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   #No.FUN-680029 --end--
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t740_g_gl_1(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_apno      LIKE alc_file.alc01
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT {LC  (1.應付 2.直接付款 3.付款 4.外購)   }
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept      LIKE ala_file.ala04
   DEFINE l_alc            RECORD LIKE alc_file.*
   #DEFINE l_pmc03      VARCHAR(10)
   DEFINE l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_str         LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(02)
          l_pma11       LIKE pma_file.pma11,
          l_aag05       LIKE aag_file.aag05
   DEFINE l_msg         LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_aps            RECORD LIKE aps_file.*
   DEFINE l_mesg       LIKE ze_file.ze03   # No.FUN-690028 VARCHAR(30)
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_alc.* FROM alc_file WHERE alc01 = p_apno AND alc02 = p_sw2
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   SELECT pma11 INTO l_pma11 FROM pma_file WHERE pma01=g_ala.ala02
   CASE WHEN l_pma11 = '3' LET l_str = 'LC'
        WHEN l_pma11 = '4' LET l_str = 'OA'
        WHEN l_pma11 = '2' LET l_str = 'TT'
        OTHERWISE LET l_str = ''
   END CASE
   IF g_apz.apz13 = 'Y' THEN
      LET l_dept = g_ala.ala04
   ELSE
      LET l_dept = ' '
   END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = g_ala.ala42 END IF
   #No.FUN-680029 --start--
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = g_ala.ala421 END IF
   END IF
   #No.FUN-680029 --end--
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg       #預估保險費
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_alc.alc01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
    LET l_npp.npp02  = l_alc.alc86      #異動日期    #MOD-4C0040 異動日期改以會計日期為基準
   LET l_npp.npptype = p_npptype   #No.FUN-680029
   LET l_npp.npplegal = g_legal        #FUN-980001
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN 
#  CALL cl_err('ins npp#1',STATUS,1) #No.FUN-660122
   CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp#1",1)  #No.FUN-660122
   LET g_success = 'N'  #No.FUN-680029
   END IF
 
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_alc.alc01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02 = 0                 #項次
   LET l_npq.npq07 = 0                 #本幣金額
   LET l_npq.npq24  = g_ala.ala20      #幣別
   LET l_npq.npq25  = l_alc.alc51      #匯率
   LET l_npq.npqtype = p_npptype       #No.FUN-680029

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
   #--->借:預付購料款 (自備款 + 手續費 + 郵電費 + 其它費用)
   LET l_npq.npq07f = l_alc.alc34
   LET l_npq.npq07  = l_alc.alc52 + l_alc.alc53 +
                      l_alc.alc54 + l_alc.alc55 + l_alc.alc57
   IF l_npq.npq07  != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_ala.ala41     #預付科目
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_ala.ala411
      END IF
      #No.FUN-680029 --end--
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = l_str CLIPPED,' ',g_ala.ala20 CLIPPED,
      #                  l_alc.alc24 USING '<<<<<<<<','*',
      #                  l_alc.alc51 USING '##.###','*',
      #                  g_ala.ala21 USING '<<<','%+',
      #                  (l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
      #                              USING '<<<<<'
      #FUN-D10065--mark--end--
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1      # No.FUN-730064
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '1'             #D/C
      LET l_npq.npq14 = g_ala.ala01
      LET l_npq.npq21 = g_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      #NO.FUN-5C0015 ---start
      LET l_npq.npq04 = NULL #FUN-D10065 add
 
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1) #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_str CLIPPED,' ',g_ala.ala20 CLIPPED,
                           l_alc.alc24 USING '<<<<<<<<','*',
                           l_alc.alc51 USING '##.###','*',
                           g_ala.ala21 USING '<<<','%+',
                           (l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
                                       USING '<<<<<'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#1',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#1",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   #--->借:預付購料款 (預估保費)
   IF l_alc.alc56 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_ala.ala41
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_ala.ala411
      END IF
      #No.FUN-680029 --end--
      #LET l_npq.npq04 = l_mesg    #FUN-D10065  mark
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1  #No.FUN-730064
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f= 0
      LET l_npq.npq21 = g_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq07 = l_alc.alc56
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1) #No.FUN-730064
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#2',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#2",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   #--->貸:應付帳款 (同借方第一筆)
   LET l_npq.npq07f = l_alc.alc34
   LET l_npq.npq07  = l_alc.alc52 + l_alc.alc53 + l_alc.alc54 +
                      l_alc.alc55 + l_alc.alc57
   IF l_npq.npq07  != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_ala.ala42
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_ala.ala421
      END IF
      #No.FUN-680029 --end--
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = g_ala.ala20 CLIPPED,l_alc.alc24 USING '<<<<<<<<','*',
      #                  l_alc.alc51 USING '##.###','*',
      #                  g_ala.ala21 USING '<<<','%+',
      #                  (l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
      #                              USING '<<<<<'
      #FUN-D10065--mark--end--
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1 #No.FUN-730064     
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq21 = g_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)   #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = g_ala.ala20 CLIPPED,l_alc.alc24 USING '<<<<<<<<','*',
                           l_alc.alc51 USING '##.###','*',
                           g_ala.ala21 USING '<<<','%+',
                           (l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
                                       USING '<<<<<'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087 
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#3',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#3",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   #--->貸:應付帳款 (同借方第二筆)
   IF l_alc.alc56 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = l_aps.aps231
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = l_aps.aps236
      END IF
      #No.FUN-680029 --end--
      CALL cl_getmsg('aap-746',g_lang) RETURNING l_msg
      #LET l_npq.npq04 = l_msg      #FUN-D10065  mark
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1 #No.FUN-730064      
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= 0
      LET l_npq.npq21 = g_ala.ala05
      LET l_npq.npq22 = l_pmc03
      LET l_npq.npq07 = l_alc.alc56
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1) #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_msg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#4',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#4",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   CALL s_flows('3',l_npq.npq00,l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
 
FUNCTION t740_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_apno      LIKE alc_file.alc01
   DEFINE p_sw1       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 1.會計傳票 2.會計付款 3.出納付款
   DEFINE p_sw2       LIKE type_file.num5        # No.FUN-690028 SMALLINT      # 0.初開狀   1/2/3.修改
   DEFINE p_npptype   LIKE npp_file.npptype   #No.FUN-680029
   DEFINE l_dept      LIKE ala_file.ala04
   DEFINE l_alc            RECORD LIKE alc_file.*
   #DEFINE l_pmc03      VARCHAR(10)
   DEFINE l_pmc03     LIKE pmc_file.pmc03 
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_aps            RECORD LIKE aps_file.*
   DEFINE l_mesg      LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(30)
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag44     LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag      LIKE type_file.chr1   #No.FUN-D40118   Add

   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_alc.* FROM alc_file WHERE alc01 = p_apno AND alc02 = p_sw2
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   IF g_apz.apz13 = 'Y' THEN
      LET l_dept = g_ala.ala04
   ELSE
      LET l_dept = ' '
   END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = g_ala.ala42 END IF
   #No.FUN-680029 --start--
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = g_ala.ala421 END IF
   END IF
   #No.FUN-680029 --end--
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg       #預估保險費
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_alc.alc01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02 = 0                 #項次
   LET l_npq.npq07 = 0                 #本幣金額
   LET l_npq.npq24  = g_ala.ala20      #幣別
   LET l_npq.npq25  = l_alc.alc51      #匯率
   LET l_npq.npqtype = p_npptype       #No.FUN-680029

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End

   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
   #--->借:應付帳款
   LET l_npq.npq07f= l_alc.alc34
   LET l_npq.npq07 = l_alc.alc52 + l_alc.alc53 + l_alc.alc54 +
                     l_alc.alc55 + l_alc.alc57
   IF l_npq.npq07 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_ala.ala42
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_ala.ala421
      END IF
      #No.FUN-680029 --end--
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1  #No.FUN-730064
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq21 = g_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
      #NO.FUN-5C0015 ---start
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1) # No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_mesg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#5',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#5",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      INITIALIZE l_npp.* TO NULL
      LET l_npp.nppsys = 'LC'             #系統別
      LET l_npp.npp00  = p_sw1            #類別
      LET l_npp.npp01  = l_alc.alc01      #單號
      LET l_npp.npp011 = p_sw2            #異動序號
      LET l_npp.npptype = p_npptype       #No.FUN-680029
      LET l_npp.npplegal = g_legal        #FUN-980001
      INSERT INTO npp_file VALUES (l_npp.*)
      IF STATUS THEN 
#     CALL cl_err('ins npp#1',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp#1",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
   #--->貸:銀行存款
   IF l_npq.npq07 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_alc.alc43
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_alc.alc431
      END IF
      #No.FUN-680029 --end--
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno2  # No.FUN-730064
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t740_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '             #部門
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq21 = ''
      LET l_npq.npq22 = ''
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1) #No.FUN-730064
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal      #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq#6',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#6",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION t740_d()
   #DEFINE l_plant,l_dbs      VARCHAR(21)   #FUN-660117 remark
#   DEFINE l_plant  LIKE azp_file.azp01,  #FUN-660117
#          l_dbs    LIKE azp_file.azp03   #FUN-660117
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE PROMPT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
#   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
#   CLOSE DATABASE #TQC-790116
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030 #FUN-990069
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030 #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs 
#   CALL s_chgdbs()       #FUN-B10030
#   CALL cl_dsmark(0)    #TQC-790116
#   CALL t740_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION t740_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),                #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_lcqty,l_sumall07 LIKE all_file.all07,
    l_poqty            LIKE all_file.all07,
    l_pmn04            LIKE pmn_file.pmn04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
DEFINE l_m          LIKE type_file.num5           #MOD-B30393  add 
 
    LET g_action_choice = ""
    IF s_aapshut(0) THEN RETURN END IF
    IF g_alc.alc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alc.* FROM alc_file
     WHERE alc01=g_alc.alc01
       AND alc02=g_alc.alc02
    IF g_alc.alcfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_alc.alcfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF

#MOD-B30393   ---begin--- 
    SELECT COUNT(*) INTO l_m FROM all_file WHERE all00 = g_alc.alc02 AND all01 = g_alc.alc01
    IF l_m =0 THEN 
       CALL t740_g_b()
       CALL t740_b_fill("1=1")
    END IF
#MOD-B30393   ---end--- 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT all02,all44,all04,all05,all11,'',",   #FUN-A60056 add all44
                       " all83,all84,all85,all80,all81,all82,all86,all87,",   #FUN-710029
                       " '',all06,all07,",
                       "       all08,all12,all13,'',all930,'',",
                          #FUN-850038 --start--
                       "allud01,allud02,allud03,allud04,allud05,",
                       "allud06,allud07,allud08,allud09,allud10,",
                       "allud11,allud12,allud13,allud14,allud15",
                          #FUN-850038 --end--
                       " FROM all_file",
                       " WHERE all01=? AND all00=? AND all02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t740_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_all WITHOUT DEFAULTS FROM s_all.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
           #No.FUN-BB0086--add--begin--
           LET g_all80_t = NULL 
           LET g_all83_t = NULL 
           LET g_all86_t = NULL 
           #No.FUN-BB0086--add--end--
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN t740_cl USING g_alc.alc01,g_alc.alc02
           IF STATUS THEN
              CALL cl_err("OPEN t740_cl:", STATUS, 1)
              CLOSE t740_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t740_cl INTO g_alc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_all_t.* = g_all[l_ac].*  #BACKUP
               #No.FUN-BB0086--add--begin--
               LET g_all80_t = g_all[l_ac].all80
               LET g_all83_t = g_all[l_ac].all83
               LET g_all86_t = g_all[l_ac].all86
               #No.FUN-BB0086--add--end--
               OPEN t740_bcl USING g_alc.alc01,g_alc.alc02,g_all_t.all02
               IF STATUS THEN
                  CALL cl_err("OPEN t740_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH t740_bcl INTO g_all[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_all_t.all02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET g_all[l_ac].pmn041 = g_all_t.pmn041
               LET g_all[l_ac].pmn07  = g_all_t.pmn07
               LET g_all[l_ac].pmn06  = g_all_t.pmn06
               LET g_all[l_ac].gem02c = s_costcenter_desc(g_all[l_ac].all930) #FUN-680019
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           #FUN-710029  --begin
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_all[l_ac].all11) THEN
                 SELECT ima44,ima31 INTO g_ima44,g_ima31
                   FROM ima_file WHERE ima01=g_all[l_ac].all11
 
                 CALL s_chk_va_setting(g_all[l_ac].all11)
                      RETURNING g_flag,g_ima906,g_ima907
 
                 CALL s_chk_va_setting1(g_all[l_ac].all11)
                      RETURNING g_flag,g_ima908
              END IF
           END IF
           CALL t740_set_required() 
           CALL t740_set_entry_b(p_cmd)
           CALL t740_set_no_entry_b(p_cmd)
           #FUN-710029  --end
           NEXT FIELD all02
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_all[l_ac].* TO NULL      #900423
           LET g_all[l_ac].all05 = 0
           LET g_all[l_ac].all06 = 0
           LET g_all[l_ac].all07 = 0
           LET g_all[l_ac].all08 = 0
           LET g_all[l_ac].all12 = 0
           LET g_all[l_ac].all13 = 0
           LET g_all[l_ac].all930= g_ala.ala930 #FUN-680019
           LET g_all[l_ac].all81 = 0    #FUN-710029
           LET g_all[l_ac].all82 = 0    #FUN-710029
           LET g_all[l_ac].all84 = 0    #FUN-710029
           LET g_all[l_ac].all85 = 0    #FUN-710029
           LET g_all[l_ac].all87 = 0    #FUN-710029
           LET g_all_t.* = g_all[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL t740_set_entry_b(p_cmd)      #NO.FUN-710029
           CALL t740_set_no_entry_b(p_cmd)   #NO.FUN-710029
           NEXT FIELD all02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
              EXIT INPUT
           END IF
 
           INSERT INTO all_file(all00,all01,all02,all44,all04,all05,   #FUN-A60056 add all44
                                all06,all07,all08,all11,all930, #FUN-680019
                                all12,all13,                    #MOD-960094 add
                                all80,all81,all82,all83,all84,all85,all86,all87   #FUN-710029
                                #FUN-850038 --start--
                               ,allud01,allud02,allud03, allud04,allud05,allud06,
                                allud07,allud08,allud09, allud10,allud11,allud12,
                                allud13,allud14,allud15, alllegal)  #FUN-9A0099
                                #FUN-850038 --end--
            VALUES(g_alc.alc02,g_alc.alc01, g_all[l_ac].all02,
                   g_all[l_ac].all44,                       #FUN-A60056
                   g_all[l_ac].all04,g_all[l_ac].all05,
                   g_all[l_ac].all06,g_all[l_ac].all07,
                  #g_all[l_ac].all08,g_all[l_ac].all11,all930, #FUN-680019   #MOD-780087
                   g_all[l_ac].all08,g_all[l_ac].all11,g_all[l_ac].all930, #FUN-680019   #MOD-780087
                   g_all[l_ac].all12,g_all[l_ac].all13,        #MOD-960094 add
                   g_all[l_ac].all80,g_all[l_ac].all81,        #FUN-710029
                   g_all[l_ac].all82,g_all[l_ac].all83,        #FUN-710029
                   g_all[l_ac].all84,g_all[l_ac].all85,        #FUN-710029
                   g_all[l_ac].all86,g_all[l_ac].all87        #FUN-710029
                   #FUN-850038 --start--
                  ,g_all[l_ac].allud01, g_all[l_ac].allud02,
                   g_all[l_ac].allud03, g_all[l_ac].allud04,
                   g_all[l_ac].allud05, g_all[l_ac].allud06,
                   g_all[l_ac].allud07, g_all[l_ac].allud08,
                   g_all[l_ac].allud09, g_all[l_ac].allud10,
                   g_all[l_ac].allud11, g_all[l_ac].allud12,
                   g_all[l_ac].allud13, g_all[l_ac].allud14,
                   g_all[l_ac].allud15, g_legal)  #FUN-9A0099
                   #FUN-850038 --end--                  
 
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_all[l_ac].all02,SQLCA.sqlcode,0)   #No.FUN-660122
              CALL cl_err3("ins","all_file",g_alc.alc02,g_alc.alc01,SQLCA.sqlcode,"","",1)  #No.FUN-660122
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
 
              COMMIT WORK
              CALL t740_bu(1,0)
           END IF
 
        BEFORE FIELD all02                        #default 序號
           IF g_all[l_ac].all02 IS NULL OR g_all[l_ac].all02 = 0 THEN
              SELECT max(all02)+1
                INTO g_all[l_ac].all02
                FROM all_file
               WHERE all01 = g_alc.alc01
                 AND all00 = g_alc.alc02
              IF g_all[l_ac].all02 IS NULL THEN
                 LET g_all[l_ac].all02 = 1
              END IF
           END IF
 
        AFTER FIELD all02                        #check 序號是否重複
           IF NOT cl_null(g_all[l_ac].all02) THEN
              IF g_all[l_ac].all02 != g_all_t.all02 OR g_all_t.all02 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM all_file
                  WHERE all01 = g_alc.alc01
                    AND all00 = g_alc.alc02
                    AND all02 = g_all[l_ac].all02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_all[l_ac].all02 = g_all_t.all02
                    NEXT FIELD all02
                 END IF
              END IF
              SELECT ala97 INTO g_all[l_ac].all44 FROM ala_file WHERE ala01 = g_alc.alc01    #MOD-B30393 add 
           END IF
 
        #FUN-A60056--add--str--
        AFTER FIELD all44 
           IF NOT cl_null(g_all[l_ac].all44) THEN 
              CALL t740_all44()
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_all[l_ac].all44,g_errno,1)
                 NEXT FIELD all44
              END IF
           ELSE
              CALL cl_err('','alm-809',0)
              NEXT FIELD all44 
           END IF
        #FUN-A60056--add--end

        AFTER FIELD all04
           IF NOT cl_null(g_all[l_ac].all04) THEN
              IF g_all[l_ac].all04 != 'MISC' AND
                 (g_all[l_ac].all04 != g_all_t.all04 OR
                  g_all_t.all04 IS NULL ) THEN
                 CALL t740_all04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_all[l_ac].all04,g_errno,0)
                    NEXT FIELD all04
                 END IF
              END IF
           END IF
 
        AFTER FIELD all05
           IF NOT cl_null(g_all[l_ac].all05) THEN
              IF g_all_t.all04 IS NULL OR
                 (g_all[l_ac].all04 != g_all_t.all04 OR
                  g_all[l_ac].all05 != g_all_t.all05) THEN
                 CALL t740_all05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_all[l_ac].all04=g_all_t.all04
                    LET g_all[l_ac].all05=g_all_t.all05
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_all[l_ac].all04
                    DISPLAY BY NAME g_all[l_ac].all05
                    #------MOD-5A0095 END------------
                    NEXT FIELD all04
                 END IF
              END IF
           END IF
 
        AFTER FIELD all06
           LET g_all[l_ac].all08 = g_all[l_ac].all06 * g_all[l_ac].all07
           #------MOD-5A0095 START----------
           DISPLAY BY NAME g_all[l_ac].all08
           #------MOD-5A0095 END------------
           #------MOD-5A0095 START----------
           DISPLAY BY NAME g_all[l_ac].all08
           #------MOD-5A0095 END------------
 
        BEFORE FIELD all12
           CALL t740_set_entry_b(p_cmd)
 
        AFTER FIELD all12
           LET g_all[l_ac].all12 = s_digqty(g_all[l_ac].all12,g_all[l_ac].pmn07) #FUN-BB0086 add
           DISPLAY BY NAME g_all[l_ac].all12 #FUN-BB0086 add
           CALL t740_set_no_entry_b(p_cmd)
 
        BEFORE FIELD all13
           CALL t740_set_entry_b(p_cmd)
 
        AFTER FIELD all13
           CALL t740_set_no_entry_b(p_cmd)
 
        AFTER FIELD all07
           LET g_all[l_ac].all07 = s_digqty(g_all[l_ac].all07,g_all[l_ac].pmn07) #FUN-BB0086 add
           DISPLAY BY NAME g_all[l_ac].all07 #FUN-BB0086 add
           #-->檢查數量是否超出
           IF g_all[l_ac].all04 != 'MISC' THEN
             #SELECT sum(alb07) INTO l_sumall07 FROM all_file    #MOD-780087
             #SELECT sum(alb07) INTO l_sumall07 FROM alb_file    #MOD-780087 #MOD-D50026 mark
              SELECT sum(alb07) INTO l_sumall07                  #MOD-D50026 add 
                FROM alb_file,ala_file                           #MOD-D50026 add
               WHERE alb04 = g_all[l_ac].all04
                 AND alb05 = g_all[l_ac].all05
                 AND alb01 <> g_alc.alc01                         #MOD-D50026 add
                 AND ala01 = alb01                                #MOD-D50026 add
                 AND alafirm <> 'X'                               #MOD-D50026 add
              IF l_sumall07 IS NULL OR l_sumall07 = ' ' THEN
                 LET l_sumall07 = 0
              END IF
             #FUN-A60056--mod--str--
             #SELECT pmn20 INTO l_poqty FROM pmn_file
             # WHERE pmn01 = g_all[l_ac].all04
             #   AND pmn02 = g_all[l_ac].all05
              LET g_sql = "SELECT pmn20 FROM ",cl_get_target_table(g_all[l_ac].all44,'pmn_file'),
                          " WHERE pmn01 = '",g_all[l_ac].all04,"'",
                          "   AND pmn02 = '",g_all[l_ac].all05,"'" 
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_all[l_ac].all44) RETURNING g_sql
              PREPARE sel_pmn20 FROM g_sql
              EXECUTE sel_pmn20 INTO l_poqty
             #FUN-A60056--mod--end
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_all[l_ac].all04,'aap-006',0)   #No.FUN-660122
                 CALL cl_err3("sel","pmn_file",g_all[l_ac].all04,g_all[l_ac].all05,"aap-006","","",1)  #No.FUN-660122
                 NEXT FIELD all04
              END IF
             #IF p_cmd = 'a' THEN                                              #MOD-D50026 mark
              LET l_lcqty = l_sumall07 + g_all[l_ac].all07
             #ELSE                                                             #MOD-D50026 mark
             #   LET l_lcqty = l_sumall07 + g_all[l_ac].all07 - g_all_t.all07  #MOD-D50026 mark
             #END IF                                                           #MOD-D50026 mark
              IF l_lcqty > l_poqty THEN
                 CALL cl_err(l_sumall07,'aap-196',0)
                 LET g_all[l_ac].all07 = g_all_t.all07
                 #------MOD-5A0095 START----------
                 DISPLAY BY NAME g_all[l_ac].all08
                 #------MOD-5A0095 END------------
                 NEXT FIELD all07
              END IF
           END IF
           LET g_all[l_ac].all08 = g_all[l_ac].all06 * g_all[l_ac].all07
 
#NO.FUN-710029 start--
        BEFORE FIELD all11
           CALL t740_set_no_required()       
           CALL t740_set_entry_b(p_cmd)
 
#NO.FUN-710029 end---
        AFTER FIELD all11
           #-->料號不允許修改
           IF g_all[l_ac].all04 != 'MISC' THEN
             #FUN-A60056--mod--str--
             #SELECT pmn04 INTO l_pmn04 FROM pmn_file
             # WHERE pmn01 = g_all[l_ac].all04
             #   AND pmn02 = g_all[l_ac].all05
              LET g_sql = "SELECT pmn04 FROM ",cl_get_target_table(g_all[l_ac].all44,'pmn_file'),
                          " WHERE pmn01 = '",g_all[l_ac].all04,"'",
                          "   AND pmn02 = '",g_all[l_ac].all05,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql
              CALL cl_parse_qry_sql(g_sql,g_all[l_ac].all44) RETURNING g_sql
              PREPARE sel_pmn04 FROM g_sql
              EXECUTE sel_pmn04 INTO l_pmn04
             #FUN-A60056--mod--end
              IF l_pmn04 != g_all[l_ac].all11 THEN
                 CALL cl_err(l_pmn04,'aap-195',0)
                 LET g_all[l_ac].all11 = l_pmn04
                 #------MOD-5A0095 START----------
                 DISPLAY BY NAME g_all[l_ac].all11
                 #------MOD-5A0095 END------------
                 NEXT FIELD all04
              END IF
           END IF
 
#NO.FUN-710029 start--
           CALL t740_set_no_entry_b(p_cmd)
           CALL t740_set_required()
           IF g_sma.sma115 = 'Y' THEN
              CALL s_chk_va_setting(g_all[l_ac].all11)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD all11
              END IF
              CALL s_chk_va_setting1(g_all[l_ac].all11)
                   RETURNING g_flag,g_ima908
              IF g_flag=1 THEN
                 NEXT FIELD all05
              END IF
              IF g_ima906 = '3' THEN
                 LET g_all[l_ac].all83=g_ima907
              END IF
              IF g_sma.sma116 MATCHES '[13]' THEN   
                 LET g_all[l_ac].all86=g_ima908
              END IF
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_all[l_ac].all11
              IF cl_null(g_all[l_ac].all80) AND  
                 cl_null(g_all[l_ac].all83) THEN
                 CALL t740_du_default(p_cmd)
              END IF
          END IF
          CALL t740_set_required()
 
        BEFORE FIELD all83
           IF NOT cl_null(g_all[l_ac].all11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_all[l_ac].all11
           END IF
           CALL t740_set_no_required()
 
        AFTER FIELD all83  #第二單位
           IF cl_null(g_all[l_ac].all11) THEN NEXT FIELD all11 END IF
           IF NOT cl_null(g_all[l_ac].all83) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_all[l_ac].all83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_all[l_ac].all83,"",STATUS,"","gfe:",1)
                 NEXT FIELD all83
              END IF
              CALL s_du_umfchk(g_all[l_ac].all11,'','','',
                               g_ima44,g_all[l_ac].all83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_all[l_ac].all83,g_errno,1)
                 NEXT FIELD all83
              END IF
              IF cl_null(g_all_t.all83) OR g_all_t.all83 <> g_all[l_ac].all83 THEN
                 LET g_all[l_ac].all84 = g_factor
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT t810_all85_check(p_cmd) THEN
                 LET g_all83_t = g_all[l_ac].all83
                 NEXT FIELD all85
              END IF 
              LET g_all83_t = g_all[l_ac].all83
              #No.FUN-BB0086--add--end--
           END IF
           CALL t740_du_data_to_correct()
           CALL t740_set_required()
           CALL cl_show_fld_cont()  
 
        AFTER FIELD all84  #第二轉換率
           IF NOT cl_null(g_all[l_ac].all84) THEN
              IF g_all[l_ac].all84=0 THEN
                 NEXT FIELD all84
              END IF
           END IF
 
        AFTER FIELD all85  #第二數量
           IF NOT t810_all85_check(p_cmd) THEN NEXT FIELD all85 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_all[l_ac].all85) THEN
           #   IF g_all[l_ac].all85 < 0 THEN
           #      CALL cl_err('','aim-391',1) 
           #      NEXT FIELD all85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_all_t.all85 <> g_all[l_ac].all85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_all[l_ac].all85*g_all[l_ac].all84
           #         IF cl_null(g_all[l_ac].all82) OR g_all[l_ac].all82=0 THEN #No.CHI-960022
           #            LET g_all[l_ac].all82=g_tot*g_all[l_ac].all81
           #            DISPLAY BY NAME g_all[l_ac].all82                      #No.CHI-960022                                        
           #         END IF                                                    #No.CHI-960022
           #      END IF
           #   END IF
           #END IF
           #IF cl_null(g_all[l_ac].all86) THEN
           #   LET g_all[l_ac].all87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_all_t.all81 <> g_all[l_ac].all81 OR
           #          g_all_t.all82 <> g_all[l_ac].all82 OR
           #          g_all_t.all84 <> g_all[l_ac].all84 OR
           #          g_all_t.all85 <> g_all[l_ac].all85 OR
           #          g_all_t.all86 <> g_all[l_ac].all86) THEN
           #      CALL t740_set_all87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont() 
           #No.FUN-BB0086--mark--end-- 
 
        AFTER FIELD all80  #第一單位
           IF cl_null(g_all[l_ac].all11) THEN NEXT FIELD all11 END IF
           IF NOT cl_null(g_all[l_ac].all80) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_all[l_ac].all80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_all[l_ac].all80,"",STATUS,"","gfe:",1)
                 NEXT FIELD all80
              END IF
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                    (g_all_t.all81 <> g_all[l_ac].all81 OR
                     g_all_t.all82 <> g_all[l_ac].all82 OR
                     g_all_t.all84 <> g_all[l_ac].all84 OR
                     g_all_t.all85 <> g_all[l_ac].all85 OR
                     g_all_t.all86 <> g_all[l_ac].all86) THEN
                 CALL t740_set_all87()
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT t810_all82_check(p_cmd) THEN 
                 LET g_all80_t = g_all[l_ac].all80
                 CALL cl_show_fld_cont()         
                 NEXT FIELD all82
              END IF 
              LET g_all80_t = g_all[l_ac].all80
              #No.FUN-BB0086--add--end--
           END IF
           CALL cl_show_fld_cont()         
 
        AFTER FIELD all81  #第一轉換率
           IF NOT cl_null(g_all[l_ac].all81) THEN
              IF g_all[l_ac].all81=0 THEN
                 NEXT FIELD all81
              END IF
           END IF
 
        AFTER FIELD all82  #第一數量
           IF NOT t810_all82_check(p_cmd) THEN NEXT FIELD all82 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_all[l_ac].all82) THEN
           #   IF g_all[l_ac].all82 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD all82
           #   END IF
           #END IF
           #CALL t740_set_origin_field()
           #IF cl_null(g_all[l_ac].all86) THEN
           #   LET g_all[l_ac].all87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #         (g_all_t.all81 <> g_all[l_ac].all81 OR
           #          g_all_t.all82 <> g_all[l_ac].all82 OR
           #          g_all_t.all84 <> g_all[l_ac].all84 OR
           #          g_all_t.all85 <> g_all[l_ac].all85 OR
           #          g_all_t.all86 <> g_all[l_ac].all86) THEN
           #      CALL t740_set_all87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD all86
           IF NOT cl_null(g_all[l_ac].all11) THEN
              SELECT ima44,ima31 INTO g_ima44,g_ima31
                FROM ima_file WHERE ima01=g_all[l_ac].all11
           END IF
           CALL t740_set_no_required()
 
 
        AFTER FIELD all86
           IF cl_null(g_all[l_ac].all11) THEN NEXT FIELD all11 END IF
           IF NOT cl_null(g_all[l_ac].all86) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_all[l_ac].all86
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_all[l_ac].all86,"",STATUS,"","gfe:",1)
                 NEXT FIELD all86
              END IF
              CALL s_du_umfchk(g_all[l_ac].all11,'','','',
                               g_ima44,g_all[l_ac].all86,'1')
                  RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_all[l_ac].all86,g_errno,1)  
                 NEXT FIELD all86
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT t810_all87_check() THEN 
                 LET g_all86_t = g_all[l_ac].all86
                 NEXT FIELD all87
              END IF 
              LET g_all86_t = g_all[l_ac].all86
              #No.FUN-BB0086--add--end--
           END IF
           CALL t740_set_required()
 
        BEFORE FIELD all87
           IF g_sma.sma115 = 'Y' THEN
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 (g_all_t.all81 <> g_all[l_ac].all81 OR
                  g_all_t.all82 <> g_all[l_ac].all82 OR
                  g_all_t.all84 <> g_all[l_ac].all84 OR
                  g_all_t.all85 <> g_all[l_ac].all85 OR
                  g_all_t.all86 <> g_all[l_ac].all86) THEN
                 CALL t740_set_all87()
              END IF
           ELSE
              IF g_all[l_ac].all87 = 0 OR
                 g_all_t.all86 <> g_all[l_ac].all86 THEN
                 CALL t740_set_all87()
              END IF
           END IF
 
        AFTER FIELD all87
           IF NOT t810_all87_check() THEN NEXT FIELD all87 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF NOT cl_null(g_all[l_ac].all87) THEN
           #   IF g_all[l_ac].all87 < 0 THEN
           #      CALL cl_err('','aim-391',1)  
           #      NEXT FIELD all87
           #   END IF
           #END IF
           #No.FUN-BB0086--mark--end--
#FUN-710029 end--------------
 
           
        #FUN-680019...............begin
        AFTER FIELD all930 
           IF NOT s_costcenter_chk(g_all[l_ac].all930) THEN
              LET g_all[l_ac].all930=g_all_t.all930
              LET g_all[l_ac].gem02c=g_all_t.gem02c
              DISPLAY BY NAME g_all[l_ac].all930,g_all[l_ac].gem02c
              NEXT FIELD all930
           ELSE
              LET g_all[l_ac].gem02c=s_costcenter_desc(g_all[l_ac].all930)
              DISPLAY BY NAME g_all[l_ac].gem02c
           END IF
        #FUN-680019...............end
 
        #No.FUN-850038 --start--
        AFTER FIELD allud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD allud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850038 ---end---
 
        BEFORE DELETE                            #是否取消單身
           IF g_all_t.all02 > 0 AND g_all_t.all02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM all_file
               WHERE all01 = g_alc.alc01
                 AND all00 = g_alc.alc02
                 AND all02 = g_all_t.all02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_all_t.all02,SQLCA.sqlcode,0)   #No.FUN-660122
                 CALL cl_err3("del","all_file", g_alc.alc01,g_all_t.all02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t740_bu(0,1)
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_all[l_ac].* = g_all_t.*
              CLOSE t740_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_all[l_ac].all02,-263,1)
              LET g_all[l_ac].* = g_all_t.*
           ELSE
#NO.FUN-710029 start--
               CALL t740_set_origin_field()  
 
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_all[l_ac].all11) THEN
                     SELECT ima44,ima31 INTO g_ima44,g_ima31
                       FROM ima_file WHERE ima01=g_all[l_ac].all11
                  END IF
 
                  CALL s_chk_va_setting(g_all[l_ac].all11)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD all11
                  END IF
                  CALL s_chk_va_setting1(g_all[l_ac].all11)
                       RETURNING g_flag,g_ima908
                  IF g_flag=1 THEN
                     NEXT FIELD all02
                  END IF
 
                  CALL t740_du_data_to_correct()
 
                  CALL t740_set_origin_field()
               END IF
#No.FUN-710029 end-----------
              UPDATE all_file SET all02 = g_all[l_ac].all02,
                                  all44 = g_all[l_ac].all44,  #FUN-A60056
                                  all04 = g_all[l_ac].all04,
                                  all05 = g_all[l_ac].all05,
                                  all06 = g_all[l_ac].all06,
                                  all07 = g_all[l_ac].all07,
                                  all08 = g_all[l_ac].all08,
                                  all11 = g_all[l_ac].all11,
                                  all12 = g_all[l_ac].all12,
                                  all13 = g_all[l_ac].all13,
                                  all930= g_all[l_ac].all930, #FUN-680019
                                  all80 = g_all[l_ac].all80,  #FUN-710029
                                  all81 = g_all[l_ac].all81,  #FUN-710029 
                                  all82 = g_all[l_ac].all82,  #FUN-710029  
                                  all83 = g_all[l_ac].all83,  #FUN-710029  
                                  all84 = g_all[l_ac].all84,  #FUN-710029  
                                  all85 = g_all[l_ac].all85,  #FUN-710029
                                  all86 = g_all[l_ac].all86,  #FUN-710029
                                  all87 = g_all[l_ac].all87   #FUN-710029
                                  #FUN-850038 --start--
                                 ,allud01 = g_all[l_ac].allud01,
                                  allud02 = g_all[l_ac].allud02,
                                  allud03 = g_all[l_ac].allud03,
                                  allud04 = g_all[l_ac].allud04,
                                  allud05 = g_all[l_ac].allud05,
                                  allud06 = g_all[l_ac].allud06,
                                  allud07 = g_all[l_ac].allud07,
                                  allud08 = g_all[l_ac].allud08,
                                  allud09 = g_all[l_ac].allud09,
                                  allud10 = g_all[l_ac].allud10,
                                  allud11 = g_all[l_ac].allud11,
                                  allud12 = g_all[l_ac].allud12,
                                  allud13 = g_all[l_ac].allud13,
                                  allud14 = g_all[l_ac].allud14,
                                  allud15 = g_all[l_ac].allud15
                                  #FUN-850038 --end-- 
 
               WHERE all01=g_alc.alc01
                 AND all00=g_alc.alc02
                 AND all02=g_all_t.all02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_all[l_ac].all02,SQLCA.sqlcode,0)   #No.FUN-660122
                 CALL cl_err3("upd","all_file",g_alc.alc01,g_all_t.all02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 LET g_all[l_ac].* = g_all_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 UPDATE ala_file SET alamodu=g_user,aladate=g_today
                  WHERE ala01=g_ala.ala01
                 COMMIT WORK
                 CALL t740_bu(1,1)
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_all[l_ac].* = g_all_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_all.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE t740_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032
           CLOSE t740_bcl
           COMMIT WORK
           CALL t740_b_tot()
 
        ON ACTION controlp
           CASE
              #FUN-A60056--add--str--
              WHEN INFIELD(all44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.default1 = g_all[l_ac].all44
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "
                 CALL cl_create_qry() RETURNING g_all[l_ac].all44
                 DISPLAY g_all[l_ac].all44 TO all44
                 NEXT FIELD all44
              #FUN-A60056--add--end
              WHEN INFIELD(all04)
                  #MOD-490420
                #FUN-980094------------(S)
                #CALL q_m_pmm5(FALSE,TRUE,g_all[l_ac].all04,g_dbs_new,g_ala.ala05)
#MOD-B30393   ---begin---
#                CALL q_m_pmm5(FALSE,TRUE,g_all[l_ac].all04,g_plant,g_ala.ala05)
                #FUN-980094------------(E)
#                RETURNING g_all[l_ac].all04
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_all04"
                 LET g_qryparam.default1 = g_all[l_ac].all04
                 LET g_qryparam.where = "alb01 = '",g_alc.alc01,"'"
                 CALL cl_create_qry() RETURNING g_all[l_ac].all04
#MOD-B30393    ---end---
                  DISPLAY BY NAME g_all[l_ac].all04       #No.MOD-490344
                 #--
 
              WHEN INFIELD(all05)
                  #MOD-490420
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmn"
                 LET g_qryparam.arg1 = g_all[l_ac].all04
                 CALL cl_create_qry() RETURNING g_all[l_ac].all05
                  DISPLAY BY NAME g_all[l_ac].all05       #No.MOD-490344
                 #--
 
              WHEN INFIELD(all11)
                 #FUN-530065
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.default1 = g_all[l_ac].all11
                 CALL cl_create_qry() RETURNING g_all[l_ac].all11
                 DISPLAY BY NAME g_all[l_ac].all11
                 NEXT FIELD all11
                 #--
#NO.FUN-710029 start---
               WHEN INFIELD(all80) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_all[l_ac].all80
                    CALL cl_create_qry() RETURNING g_all[l_ac].all80
                    DISPLAY BY NAME g_all[l_ac].all80
                    NEXT FIELD all80
               WHEN INFIELD(all83) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_all[l_ac].all83
                    CALL cl_create_qry() RETURNING g_all[l_ac].all83
                    DISPLAY BY NAME g_all[l_ac].all83
                    NEXT FIELD all83
               WHEN INFIELD(all86) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_all[l_ac].all86
                    CALL cl_create_qry() RETURNING g_all[l_ac].all86
                    DISPLAY BY NAME g_all[l_ac].all86
                    NEXT FIELD all86
#NO.FUN-710029 end------------
               #FUN-680019...............begin
               WHEN INFIELD(all930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_all[l_ac].all930
                  DISPLAY BY NAME g_all[l_ac].all930
                  NEXT FIELD all930
               #FUN-680019...............end
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
#       ON ACTION CONTROLN
#          CALL t740_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(all02) AND l_ac > 1 THEN
              LET g_all[l_ac].* = g_all[l_ac-1].*
              LET g_all[l_ac].all02 = NULL   #TQC-620018
              NEXT FIELD all02
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
  
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
 
   #start FUN-5A0029
    LET g_alc.alcmodu = g_user
    LET g_alc.alcdate = g_today
    UPDATE alc_file SET alcmodu = g_alc.alcmodu,alcdate = g_alc.alcdate
     WHERE alc01 = g_alc.alc01
    DISPLAY BY NAME g_alc.alcmodu,g_alc.alcdate
   #end FUN-5A0029
    CALL t740_delHeader()   #CHI-C30002 add 
    CLOSE t740_bcl
    COMMIT WORK
 
END FUNCTION
 
#CHI-C30002 ------ add ------ begin
FUNCTION t740_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041

   IF g_rec_b = 0 THEN
      #CHI-C80041---begin    
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
         CALL t740_x()
         IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"") 
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE npp01 = g_ala.ala01
                                AND npp011= g_alc.alc02
                                AND nppsys='LC'
                                AND (npp00 = 6 OR npp00 = 7)                       
         DELETE FROM npq_file WHERE npq01 = g_ala.ala01
                                AND npq011= g_alc.alc02
                                AND npqsys='LC'
                                AND (npq00 = 6 OR npq00 = 7)                  
         DELETE FROM tic_file WHERE tic04 = g_ala.ala01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM alc_file WHERE alc01 = g_alc.alc01
         INITIALIZE g_alc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------ add ------ end
FUNCTION t740_all04()
  DEFINE l_pmc04 LIKE pmc_file.pmc04,
         l_sql   LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET g_errno = " "                         #-->check 付款廠商是否一致
#MOD-B30393    ---begin---
# #FUN-A60056--mod--str--
# #SELECT pmc04 INTO l_pmc04 FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm_file.pmm09 = pmc_file.pmc01
# #       WHERE pmm01 = g_all[l_ac].all04
# #         AND pmm18='Y'
#  LET g_sql = "SELECT pmc04 ",
#              "  FROM ",cl_get_target_table(g_all[l_ac].all44,'pmm_file'),
#              "  LEFT OUTER JOIN ",cl_get_target_table(g_all[l_ac].all44,'pmc_file'),
#              "    ON pmm_file.pmm09 = pmc_file.pmc01 ",
#              " WHERE pmm01 = '",g_all[l_ac].all04,"'",   #FUN-A70139
#              "   AND pmm18='Y'" 
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#  CALL cl_parse_qry_sql(g_sql,g_all[l_ac].all44) RETURNING g_sql
#  PREPARE sel_pmc04 FROM g_sql
#  EXECUTE sel_pmc04 INTO l_pmc04
# #FUN-A60056--mod--end
#    CASE WHEN SQLCA.SQLCODE = 100      LET g_errno = 'aap-006'
#         WHEN l_pmc04 != g_ala.ala05   LET g_errno = 'mfg3020'
#         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
     SELECT alb04 FROM alb_file,ala_file WHERE ala01 = alb01 AND alb04 = g_all[l_ac].all04
        AND ala01 = g_alc.alc01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-006'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
#MOD-B30393    ---end----
END FUNCTION
 
FUNCTION t740_all05(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_pmm09         LIKE pmm_file.pmm09,
           l_pmm22         LIKE pmm_file.pmm22,
           l_pmn04         LIKE pmn_file.pmn04,
           l_pmn16         LIKE pmn_file.pmn16,
           l_pmn20         LIKE pmn_file.pmn20,
           l_pmn31         LIKE pmn_file.pmn31,
           l_pmn041        LIKE pmn_file.pmn041,
           l_pmn07         LIKE pmn_file.pmn07 ,
           l_pmn06         LIKE pmn_file.pmn06 ,
           l_sumall07      LIKE all_file.all07,
           l_pmn930        LIKE pmn_file.pmn930 #FUN-680019
    DEFINE l_cnt           LIKE type_file.num5     #MOD-670082  #No.FUN-690028 SMALLINT
 
    LET g_errno = ' '
    #-----MOD-670082---------
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM all_file
      WHERE all00 = g_alc.alc02 AND all01 = g_alc.alc01 AND
            all04 = g_all[l_ac].all04 AND all05 = g_all[l_ac].all05
    IF l_cnt > 0 THEN
       LET g_errno = "-239"
       RETURN
    END IF
    #-----END MOD-670082-----
    IF g_all[l_ac].all04 = 'MISC' THEN RETURN END IF
    LET g_sql = "SELECT pmm09,pmm22,pmn04,pmn16,pmn20,pmn31,pmn041,pmn07,pmn06,pmn930", #FUN-680019
               #FUN-A60056--mod--str--
               #"  FROM pmm_file,pmn_file",  
                "  FROM ",cl_get_target_table(g_all[l_ac].all44,'pmm_file'),",",
                "       ",cl_get_target_table(g_all[l_ac].all44,'pmn_file'),
               #FUN-A60056--mod--end
                " WHERE pmn01 = ? AND pmn02 = ?",
                "   AND pmn01 = pmm01 "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql     #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,g_all[l_ac].all44) RETURNING g_sql    #FUN-A60056
    PREPARE t740_afp51 FROM g_sql
    DECLARE t740_af_51 CURSOR FOR t740_afp51
    OPEN t740_af_51 USING g_all[l_ac].all04,g_all[l_ac].all05
    FETCH t740_af_51 INTO
      l_pmm09,l_pmm22,l_pmn04,l_pmn16,l_pmn20,l_pmn31,l_pmn041,l_pmn07,l_pmn06,l_pmn930 #FUN-680019
    CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-006'
         WHEN l_pmm22 != g_ala.ala20 LET g_errno = 'aap-104'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    #-->採購單狀況必須為(發出狀況)
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF l_pmn20 IS NULL THEN
       LET l_pmn20 = 0
    END IF
    IF l_pmn31 IS NULL THEN
       LET l_pmn31 = 0
    END IF
    #-->檢查採購數量是否多預購
    SELECT sum(alb07) INTO l_sumall07 FROM alb_file
                          WHERE alb04 = g_all[l_ac].all04
                            AND alb05 = g_all[l_ac].all05
    IF l_sumall07 IS NULL OR l_sumall07 = ' ' THEN
       LET l_sumall07 = 0
    END IF
    LET g_all[l_ac].all06 = l_pmn31
    LET g_all[l_ac].all07 = l_pmn20 - l_sumall07
    LET g_all[l_ac].all08 = g_all[l_ac].all06 * g_all[l_ac].all07
    LET g_all[l_ac].all11 = l_pmn04
    LET g_all[l_ac].pmn041 = l_pmn041
    LET g_all[l_ac].pmn07  = l_pmn07
    LET g_all[l_ac].pmn06  = l_pmn06
    LET g_all[l_ac].all930 = l_pmn930 #FUN-680019
    DISPLAY BY NAME g_all[l_ac].all930 #FUN-680019
END FUNCTION
 
FUNCTION t740_b_askkey()
DEFINE
   l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON all02,all44,all04,all05,all11,   #FUN-A60056
                      all83,all84,all85,all80,all81,all82,all86,all87,   #FUN-710029
                      all06,all07,all08,all12,all13
           FROM s_all[1].all02,s_all[1].all44,s_all[1].all04,s_all[1].all05,   #FUN-A60056 add all44
                s_all[1].all11,
                s_all[1].all83,s_all[1].all84,s_all[1].all85,   #FUN-710029
                s_all[1].all80,s_all[1].all81,s_all[1].all82,   #FUN-710029
                s_all[1].all86,s_all[1].all87,                  #FUN-710029 
                s_all[1].all06,s_all[1].all07,
                s_all[1].all08,s_all[1].all12,s_all[1].all13
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
   CALL t740_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t740_g_b()
  DEFINE l_alb    RECORD LIKE alb_file.*
  DEFINE l_all44  LIKE all_file.all44     #MOD-B50034
  DEFINE l_all80  LIKE all_file.all80     #MOD-B40267 
  DEFINE l_all82  LIKE all_file.all82     #MOD-B40267 
  DEFINE l_all83  LIKE all_file.all83     #MOD-B40267 
  DEFINE l_all84  LIKE all_file.all84     #MOD-B40267 
  DEFINE l_all85  LIKE all_file.all85     #MOD-B40267 
  DEFINE l_all86  LIKE all_file.all86     #MOD-B40267 
  DEFINE l_all87  LIKE all_file.all87     #MOD-B40267 
 
 #-MOD-B50034-add-
  LET g_sql = "SELECT alb_file.*,ala97 ", 
              "  FROM alc_file,alb_file,ala_file ",
              " WHERE alb01 = '",g_alc.alc01,"'", 
              "   AND alb01 = alc01 ",
              "   AND alc02 = '",g_alc.alc02,"'",
              "   AND ala01 = alb01 "
  PREPARE t740_alb_pb FROM g_sql
  DECLARE alb_curs CURSOR FOR t740_alb_pb
  FOREACH alb_curs INTO l_alb.*,l_all44 
 #-MOD-B50034-add-
     #No.FUN-710029  --begin
     IF g_sma.sma115 = 'Y' THEN
       #CALL t740_set_du_by_origin('b')                   #MOD-B40267 mark
       #-MOD-B40267-add-
       #-MOD-B50034-mark-
       #SELECT * INTO l_alb.* 
       #  FROM alc_file,alb_file
       # WHERE alb01 = g_alc.alc01 
       #   AND alb01 = alc01
       #   AND alc02 = g_alc.alc02
       #-MOD-B50034-end-
        CALL t740_set_du_by_origin(l_alb.*) RETURNING l_all80,l_all82,l_all83,l_all84,l_all85,
                                                      l_all86,l_all87 
   
        INSERT INTO all_file (all00,all01,all02, all04,all05,
                              all06,all07,all08, all44,all11,  #MOD-B50034 add all44
                              all12,all13,all930,all80,all81,
                              all82,all83,all84, all85,all86, 
                              all87,alllegal)
                     #-MOD-B50034-add-
                      VALUES (g_alc.alc02,l_alb.alb01,l_alb.alb02, l_alb.alb04,l_alb.alb05,
                              l_alb.alb06,l_alb.alb07,l_alb.alb08, l_all44,    l_alb.alb11,
                              l_alb.alb12,l_alb.alb13,l_alb.alb930,l_all80,    l_alb.alb81, 
                              l_all82,    l_all83,    l_all84,     l_all85,    l_all86,
                              l_all87,    l_alb.alblegal)
                     #-MOD-B50034-mark-
                     # SELECT alc02,  alb01,  alb02,  alb04,  alb05,
                     #        alb06,  alb07,  alb08,  alb11,  alb12,
                     #        alb13,  alb930, l_all80,alb81,  l_all82, 
                     #        l_all83,l_all84,l_all85,l_all86,l_all87,
                     #        alblegal
                     #   FROM alc_file,alb_file
                     #  WHERE alb01=g_alc.alc01 AND alb01=alc01
                     #    AND alc02=g_alc.alc02
                     #-MOD-B50034-end-
       #-MOD-B40267-end-
    #END IF   #MOD-B40267 mark
     ELSE     #MOD-B40267
     #No.FUN-710029  --end
        INSERT INTO all_file (all00,all01,all02, all04,all05,
                              all06,all07,all08, all44,all11,      #MOD-B30393 add all44
                              all12,all13,all930,all80,all81, #FUN-680019
                              all82, all83,all84,all85,all86,
                              all87,alllegal)   #FUN-710029 #FUN-9A0099
                     #-MOD-B50034-add-
                      VALUES (g_alc.alc02,l_alb.alb01,l_alb.alb02, l_alb.alb04,l_alb.alb05,
                              l_alb.alb06,l_alb.alb07,l_alb.alb08, l_all44,    l_alb.alb11,
                              l_alb.alb12,l_alb.alb13,l_alb.alb930,l_alb.alb80,l_alb.alb81, 
                              l_alb.alb82,l_alb.alb83,l_alb.alb84, l_alb.alb85,l_alb.alb86,
                              l_alb.alb87,l_alb.alblegal)
                     #-MOD-B50034-mark-
                     # SELECT alc02,alb01,alb02,alb04,alb05,alb06,alb07,alb08,ala97,      #MOD-B30393 add ala97
                     #        alb11,alb12,alb13,alb930,  #FUN-680019
                     #        alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87,alblegal    #FUN-710029 #FUN-9A0099
                     #   FROM alc_file,alb_file,ala_file #MOD-B30393 add ala_file
                     #  WHERE alb01=g_alc.alc01 AND alb01=alc01
                     #    AND alc02=g_alc.alc02
                     #    AND ala01=alb01                #MOD-B30393 add
                     #-MOD-B50034-end-
     END IF   #MOD-B40267
     IF STATUS THEN 
#    CALL cl_err('ins all',STATUS,1) #No.FUN-660122
     CALL cl_err3("ins","all_file",g_alc.alc01,g_alc.alc02,STATUS,"","ins all:",1)  #No.FUN-660122
     END IF
  END FOREACH   #MOD-B50034
END FUNCTION
 
FUNCTION t740_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
  #FUN-A60056--mod--str--拿掉pmn_file相應欄位,在FOREACH中以all44跨庫抓取
  #LET g_sql = "SELECT all02,all44,all04,all05,all11,pmn041,",   #FUN-A60056 add all44
  #            "       all83,all84,all85,all80,all81,all82,all86,all87,",  #FUN-710029
  #            "       pmn07,all06,",
  #            "       all07,all08,all12,all13,pmn06,all930,''", #FUN-680019
  #            #No.FUN-850038 --start--
  #            ",allud01,allud02,allud03,allud04,allud05,",
  #            "allud06,allud07,allud08,allud09,allud10,",
  #            "allud11,allud12,allud13,allud14,allud15", 
  #            #No.FUN-850038 ---end---
  #            " FROM all_file LEFT OUTER JOIN pmn_file ON all_file.all04 = pmn_file.pmn01 AND all_file.all05 = pmn_file.pmn02",
  #            " WHERE all01 ='",g_alc.alc01,"'",
  #            "   AND all00 ='",g_alc.alc02,"'",
  #            "   AND ",p_wc2 CLIPPED,                     #單身
  #            " ORDER BY 1"
   LET g_sql = "SELECT all02,all44,all04,all05,all11,'',",   #FUN-A60056 add all44
               "       all83,all84,all85,all80,all81,all82,all86,all87,",  #FUN-710029
               "       '',all06,",
               "       all07,all08,all12,all13,'',all930,''", #FUN-680019
               ",allud01,allud02,allud03,allud04,allud05,",
               "allud06,allud07,allud08,allud09,allud10,",
               "allud11,allud12,allud13,allud14,allud15",
               " FROM all_file ",
               " WHERE all01 ='",g_alc.alc01,"'",
              #"   AND all00 ='",g_alc.alc02,"'", #CHI-AA0015 mark
               "   AND all00 =",g_alc.alc02, #CHI-AA0015
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   #FUN-A60056--mod--end
   PREPARE t740_pb FROM g_sql
   DECLARE all_curs CURSOR FOR t740_pb
 
   CALL g_all.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH all_curs INTO g_all[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      #FUN-A60056--add--str--抓取pmn041,pmn07,pmn06
      LET g_sql = "SELECT pmn041,pmn07,pmn06",
                  "  FROM ",cl_get_target_table(g_all[g_cnt].all44,'pmn_file'),
                  " WHERE pmn01 = '",g_all[g_cnt].all04,"'",
                  "   AND pmn02 = '",g_all[g_cnt].all05,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_all[g_cnt].all44) RETURNING g_sql
      PREPARE sel_pmn041 FROM g_sql
      EXECUTE sel_pmn041 INTO g_all[g_cnt].pmn041,g_all[g_cnt].pmn07,g_all[g_cnt].pmn06
      #FUN-A60056--add--end
      LET g_all[g_cnt].gem02c=s_costcenter_desc(g_all[g_cnt].all930) #FUN-680019
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_all.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION t740_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_act_visible("maintain_entry2",FALSE)
   END IF
   #No.FUN-680029 --end--
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_all TO s_all.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t740_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t740_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t740_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t740_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t740_fetch('L')
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
         CALL t740_def_form()      #NO.FUN-710029
         #CALL cl_set_field_pic(g_alc.alcfirm,"","","","","")  #CHI-C80041 
         IF g_alc.alcfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_alc.alcfirm,"","","",g_void,"")  #CHI-C80041 
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
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 會計分錄維護
      ON ACTION maintain_entry
         LET g_action_choice="maintain_entry"
         EXIT DISPLAY
      #No.FUN-680029 --start--
      ON ACTION maintain_entry2
         LET g_action_choice="maintain_entry2"
         EXIT DISPLAY
      #No.FUN-680029 --end--
      #@ON ACTION 付款科目
      ON ACTION payment_acct
         LET g_action_choice="payment_acct"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
      #@ON ACTION 付款記錄
      ON ACTION payment_record
         LET g_action_choice="payment_record"
         EXIT DISPLAY
      #@ON ACTION 修改前記錄
      ON ACTION qry_before_update_record
         LET g_action_choice="qry_before_update_record"
         EXIT DISPLAY
      #@ON ACTION 工廠切換
      #--FUN-B10030--start--
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
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
 
      #No.FUN-670060  --Begin                                                                                                       
      ON ACTION carry_voucher #傳票拋轉                                                                                             
         LET g_action_choice="carry_voucher"                                                                                        
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION undo_carry_voucher #傳票拋轉還原                                                                                    
         LET g_action_choice="undo_carry_voucher"                                                                                   
         EXIT DISPLAY                                                                                                               
      #No.FUN-670060  --End 
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t740_bu(u_sw,r_sw)
   DEFINE u_sw,r_sw      LIKE type_file.num5        # No.FUN-690028 SMALLINT
   CALL t740_b_tot()
 
END FUNCTION
 
FUNCTION t740_b_tot()
   LET g_tot = NULL
   SELECT SUM(all08) INTO g_tot FROM all_file
    WHERE all01 = g_alc.alc01
      AND all00 = g_alc.alc02
   DISPLAY g_tot TO tot2
END FUNCTION
 
FUNCTION t740_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("alc01,alc02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t740_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("alc01,alc02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t740_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF INFIELD(all12) OR INFIELD(all13) THEN
      CALL cl_set_comp_entry("all05,all07,all08,all11",TRUE)
    END IF
#NO.FUN-710029 start--
    CALL cl_set_comp_entry("all81,all83,all84,all85,all87",TRUE)
#NO.FUN-710029 end--
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003,004,005> #
#Patch....NO.TQC-610035 <001> #
 
#No.FUN-670060  --Begin
FUNCTION t740_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alc.alc72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_alc.alc72,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl = g_apz.apz02p   #No.FUN-980059
 
    OPEN WINDOW t740p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
     
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
    #No.FUN-680029 --end--
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029
    
       AFTER FIELD gl_no
#         CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_dbs_gl)        #No.TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)      #No.TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
 
       #No.FUN-680088 --start--
       AFTER FIELD gl_no1
#         CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_dbs_gl)       #No.TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)     #No.TQC-9B0162
                RETURNING li_result,l_apygslp1
          IF (NOT li_result) THEN
             NEXT FIELD gl_no1
          END IF
       #No.FUN-680088 --end--
    
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT 
          END IF
          IF cl_null(l_apygslp) THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no  
          END IF
 
          #No.FUN-680088 --start--
          IF cl_null(l_apygslp1) AND g_aza.aza63 = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no1 
          END IF
          #No.FUN-680088 --end--
    
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION CONTROLP
          IF INFIELD(gl_no) THEN
#            CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_apygslp,'1',' ',' ','AGL')     #No.FUN-980059
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp,'1',' ',' ','AGL')   #No.FUN-980059
             RETURNING l_apygslp
             DISPLAY l_apygslp TO FORMONLY.gl_no
             NEXT FIELD gl_no
          END IF
 
          #No.FUN-680088 --start--
          IF INFIELD(gl_no1) THEN
#            CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_apygslp1,'1',' ',' ','AGL')   #No.FUN-980059
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1',' ',' ','AGL') #No.FUN-980059
             RETURNING l_apygslp1
             DISPLAY l_apygslp1 TO FORMONLY.gl_no1
             NEXT FIELD gl_no1
          END IF
          #No.FUN-680088 --end--
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
    
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
    
       ON ACTION exit  #加離開功能genero
          LET INT_FLAG = 1
          EXIT INPUT
 
    END INPUT
    CLOSE WINDOW t740p  
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_alc.alc01,'axr-070',1)
       RETURN
    END IF
    LET g_t1=s_get_doc_no(l_apygslp)
    LET g_wc_gl = 'npp01 = "',g_alc.alc01,'" AND npp011 = ',g_alc.alc02
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '5' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_alc.alc08,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT alc72 INTO g_alc.alc72 FROM alc_file
     WHERE alc01 = g_alc.alc01
       AND alc02 = g_alc.alc02  #No.FUN-680029
    DISPLAY BY NAME g_alc.alc72
    
END FUNCTION
 
FUNCTION t740_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alc.alc72,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_alc.alc72,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_alc.alc72,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT alc72 INTO g_alc.alc72 FROM alc_file
     WHERE alc01 = g_alc.alc01
       AND alc02 = g_alc.alc02  #No.FUN-680029
    DISPLAY BY NAME g_alc.alc72
END FUNCTION
 
#FUN-680019...............begin
FUNCTION t740_set_npq05(p_dept,p_ala930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ala930 LIKE ala_file.ala930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ala930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#FUN-680019...............end
 
#No.FUN-670060  --End   
 
#NO.FUN-710029 start-------------------
FUNCTION t740_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("all83,all85,all80,all82",FALSE)
      CALL cl_set_comp_visible("pmn07,all07",TRUE)
   ELSE
      CALL cl_set_comp_visible("all83,all84,all85,all80,all81,all82",TRUE)
      CALL cl_set_comp_visible("pmn07,all07",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("all86,all87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("all84,all81",FALSE)
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("all82",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("all930,gem02c",g_aaz.aaz90='Y')  #TQC-BB0264 gem02改為gem02c  
END FUNCTION
 
FUNCTION t740_set_required()
   IF g_sma.sma115 = 'Y' THEN
       #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
       IF g_ima906 = '3' THEN
            CALL cl_set_comp_required("all83,all85,all80,all82",TRUE)
       END IF
       #單位不同,轉換率,數量必KEY
       IF NOT cl_null(g_all[l_ac].all80) THEN
          CALL cl_set_comp_required("all82",TRUE)
       END IF
       IF NOT cl_null(g_all[l_ac].all83) THEN
          CALL cl_set_comp_required("all85",TRUE)
       END IF
       IF g_sma.sma116 NOT MATCHES '[02]' THEN
            IF NOT cl_null(g_all[l_ac].all86) THEN
                CALL cl_set_comp_required("all87",TRUE)
            END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t740_set_no_required()
  CALL cl_set_comp_required("all83,all84,all85,all80,all81,all82,all86,all87",FALSE)
END FUNCTION
 
#default 雙單位/轉換率/數量
FUNCTION t740_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima31  LIKE ima_file.ima31,
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_all[l_ac].all11
    SELECT ima44,ima31,ima906,ima907,ima908
      INTO l_ima44,l_ima31,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
 
    LET l_unit1 = l_ima44
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_all[l_ac].all83=l_unit2
       LET g_all[l_ac].all84=l_fac2
       LET g_all[l_ac].all85=l_qty2
       LET g_all[l_ac].all80=l_unit1
       LET g_all[l_ac].all81=l_fac1
       LET g_all[l_ac].all82=l_qty1
       LET g_all[l_ac].all86=l_unit3
       LET g_all[l_ac].all87=l_qty3
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t740_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor LIKE ima_file.ima31_fac,  
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_all[l_ac].all11
    IF SQLCA.sqlcode = 100 THEN
       IF g_all[l_ac].all11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_all[l_ac].all84
    LET l_qty2=g_all[l_ac].all85
    LET l_fac1=g_all[l_ac].all81
    LET l_qty1=g_all[l_ac].all82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_all[l_ac].all86=g_all[l_ac].all80
                   LET g_all[l_ac].all07=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_all[l_ac].all86=l_ima44
                   LET g_all[l_ac].all07=l_tot
          WHEN '3' LET g_all[l_ac].all86=g_all[l_ac].all80
                   LET g_all[l_ac].all07=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_all[l_ac].all84=l_qty1/l_qty2
                   ELSE
                      LET g_all[l_ac].all84=0
                   END IF
       END CASE
    END IF
 
    LET g_factor = 1
    CALL s_umfchk(g_all[l_ac].all11,g_all[l_ac].all86,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
       LET g_all[l_ac].all87 = g_all[l_ac].all07
    END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t740_du_data_to_correct()
   IF cl_null(g_all[l_ac].all80) THEN
      LET g_all[l_ac].all81 = NULL
      LET g_all[l_ac].all82 = NULL
   END IF
 
   IF cl_null(g_all[l_ac].all83) THEN
      LET g_all[l_ac].all84 = NULL
      LET g_all[l_ac].all85 = NULL
   END IF
 
   IF cl_null(g_all[l_ac].all86) THEN
      LET g_all[l_ac].all87 = NULL
   END IF
   DISPLAY BY NAME g_all[l_ac].all81
   DISPLAY BY NAME g_all[l_ac].all82
   DISPLAY BY NAME g_all[l_ac].all84
   DISPLAY BY NAME g_all[l_ac].all85
   DISPLAY BY NAME g_all[l_ac].all86
   DISPLAY BY NAME g_all[l_ac].all87
 
END FUNCTION
 
FUNCTION t740_set_all87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor  LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    #No.FUN-560020  --begin
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_all[l_ac].all11
 
    IF SQLCA.sqlcode =100 THEN
       IF g_all[l_ac].all11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_all[l_ac].all84
       LET l_qty2=g_all[l_ac].all85
       LET l_fac1=g_all[l_ac].all81
       LET l_qty1=g_all[l_ac].all82
    ELSE
       LET l_fac1=g_all[l_ac].all86
       LET l_qty1=g_all[l_ac].all07
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_all[l_ac].all11,l_ima44,g_all[l_ac].all86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_all[l_ac].all87 = l_tot
END FUNCTION
 
#FUNCTION t740_set_du_by_origin(p_code) #MOD-B40267 mark
FUNCTION t740_set_du_by_origin(p_alb)   #MOD-B40267
  DEFINE l_ima44    LIKE ima_file.ima44,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_all11    LIKE all_file.all11,
         l_factor   LIKE ima_file.ima31_fac   #No.FUN-680136  DECIMAL(16,8),
        #p_code     LIKE type_file.chr1       #No.FUN-680136  CHAR(01) #MOD-B40267 mark
  DEFINE p_alb      RECORD LIKE alb_file.*    #MOD-B40267
  DEFINE l_all80    LIKE all_file.all80       #MOD-B40267 
  DEFINE l_all82    LIKE all_file.all82       #MOD-B40267 
  DEFINE l_all83    LIKE all_file.all83       #MOD-B40267 
  DEFINE l_all84    LIKE all_file.all84       #MOD-B40267 
  DEFINE l_all85    LIKE all_file.all85       #MOD-B40267 
  DEFINE l_all86    LIKE all_file.all86       #MOD-B40267 
  DEFINE l_all87    LIKE all_file.all87       #MOD-B40267 
 
   #LET l_all11 = g_all[l_ac].all11    #MOD-B40267 mark
    LET l_all11 = p_alb.alb11          #MOD-B40267 
   #-MOD-B50034-add-
    LET l_all80 = p_alb.alb80          
    LET l_all82 = p_alb.alb82        
    LET l_all83 = p_alb.alb83
    LET l_all84 = p_alb.alb84
    LET l_all85 = p_alb.alb85
    LET l_all86 = p_alb.alb86
    LET l_all87 = p_alb.alb87
   #-MOD-B50034-end-
 
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_all11
 
   #IF cl_null(g_all[l_ac].all80) THEN             #MOD-B40267 mark
    IF cl_null(p_alb.alb80) THEN                   #MOD-B40267
      #LET g_all[l_ac].all80 = g_all[l_ac].all86   #MOD-B40267 mark
       LET l_all80 = p_alb.alb86                   #MOD-B40267
      #LET g_all[l_ac].all82 = g_all[l_ac].all07   #MOD-B40267 mark
       LET l_all82 = p_alb.alb07                   #MOD-B40267
    END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
      #LET g_all[l_ac].all83 = NULL                #MOD-B40267 mark
       LET l_all83 = NULL                          #MOD-B40267 
      #LET g_all[l_ac].all84 = NULL                #MOD-B40267 mark
       LET l_all84 = NULL                          #MOD-B40267 
      #LET g_all[l_ac].all85 = NULL                #MOD-B40267 mark
       LET l_all85 = NULL                          #MOD-B40267 
    ELSE
      #IF cl_null(g_all[l_ac].all83) THEN          #MOD-B40267 mark
       IF cl_null(p_alb.alb83) THEN                #MOD-B40267
         #LET g_all[l_ac].all83 = l_ima907         #MOD-B40267 mark
          LET l_all83 = l_ima907                   #MOD-B40267
         #CALL s_du_umfchk(l_all11,'','','',g_all[l_ac].all86,l_ima907,l_ima906) #MOD-B40267 mark
          CALL s_du_umfchk(l_all11,'','','',p_alb.alb86,l_ima907,l_ima906)       #MOD-B40267
               RETURNING g_errno,l_factor
         #LET g_all[l_ac].all84 = l_factor         #MOD-B40267 mark
          LET l_all84 = l_factor                   #MOD-B40267 
         #LET g_all[l_ac].all85 = 0                #MOD-B40267 mark
          LET l_all85 = 0                          #MOD-B40267 
       END IF
    END IF
   #IF cl_null(g_all[l_ac].all86) THEN             #MOD-B40267 mark
    IF cl_null(p_alb.alb86) THEN                   #MOD-B40267
      #LET g_all[l_ac].all86 = g_all[l_ac].all86   #MOD-B40267 mark
       LET l_all86 = p_alb.alb86                   #MOD-B40267 
      #LET g_all[l_ac].all87 = g_all[l_ac].all07   #MOD-B40267 mark
       LET l_all87 = p_alb.alb07                   #MOD-B40267
    END IF
    RETURN l_all80,l_all82,l_all83,l_all84,l_all85,l_all86,l_all87  #MOD-B40267
END FUNCTION
 
FUNCTION t740_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
 
   IF INFIELD(all12) OR INFIELD(all13) THEN
      IF g_all[l_ac].all12 >0 OR g_all[l_ac].all13 >0 THEN
         CALL cl_set_comp_entry("all05,all07,all08,all11",FALSE)
      END IF
   END IF
 
#NO.FUN-710029 start---
   #No.FUN-540027  --begin
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("all83,all84,all85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("all83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("all84,all81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("all87",FALSE)
   END IF
#NO.FUN-710029 end----
END FUNCTION
 
#No.FUN-730064  --Begin                                                                                                             
FUNCTION t740_bookno()                                                                                                              
   IF g_apz.apz02='Y' THEN          #MOD-BB0212 mod sma03 -> apz02
      LET g_db1 = g_apz.apz02p      #MOD-BB0212 mod sma87 -> apz02p
   ELSE                                                                                                                             
      LET g_db1 = g_plant                                                                                                           
   END IF
   SELECT azp03 INTO g_azp03 FROM azp_file                                                                                          
    WHERE azp01=g_db1                                                                                                               
   LET g_db_type=cl_db_get_database_type()                                                                                             
                                                                                                                                    
#TQC-940178 MARK&ADD START--------------------------
   LET g_plantm = g_db1                      #FUN-980020 
   LET g_dbsm = s_dbstring(g_azp03 CLIPPED)  #ADD

   CALL s_get_bookno1(YEAR(g_alc.alc86),g_plantm)   #FUN-980020
        RETURNING g_flag1,g_bookno1,g_bookno2                                                                                        
   IF g_flag1 =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_err(g_dbsm,'aoo-081',1)                                                                                               
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B90033
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-730064  --end
#FUN-A60056--add--str--
FUNCTION t740_all44()
   LET g_errno = ''

   SELECT * FROM azp_file,azw_file
    WHERE azp01 = azw01
      AND azp01 = g_all[l_ac].all44
      AND azw02 = g_legal

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-171'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE


END FUNCTION
#FUN-A60056--add--end

#No.FUN-BB0086--add--begin--
FUNCTION t810_all82_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_all[l_ac].all82) AND NOT cl_null(g_all[l_ac].all80) THEN
      IF cl_null(g_all_t.all82) OR cl_null(g_all80_t) OR g_all_t.all82 != g_all[l_ac].all82 OR g_all80_t != g_all[l_ac].all80 THEN
         LET g_all[l_ac].all82=s_digqty(g_all[l_ac].all82,g_all[l_ac].all80)
         DISPLAY BY NAME g_all[l_ac].all82
      END IF
   END IF

   IF NOT cl_null(g_all[l_ac].all82) THEN
      IF g_all[l_ac].all82 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF
   CALL t740_set_origin_field()
   IF cl_null(g_all[l_ac].all86) THEN
      LET g_all[l_ac].all87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_all_t.all81 <> g_all[l_ac].all81 OR
             g_all_t.all82 <> g_all[l_ac].all82 OR
             g_all_t.all84 <> g_all[l_ac].all84 OR
             g_all_t.all85 <> g_all[l_ac].all85 OR
             g_all_t.all86 <> g_all[l_ac].all86) THEN
         CALL t740_set_all87()
      END IF
   END IF
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN TRUE
END FUNCTION 

FUNCTION t810_all85_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_all[l_ac].all85) AND NOT cl_null(g_all[l_ac].all83) THEN
      IF cl_null(g_all_t.all85) OR cl_null(g_all83_t) OR g_all_t.all85 != g_all[l_ac].all85 OR g_all83_t != g_all[l_ac].all83 THEN
         LET g_all[l_ac].all85=s_digqty(g_all[l_ac].all85,g_all[l_ac].all83)
         DISPLAY BY NAME g_all[l_ac].all85
      END IF
   END IF

   IF NOT cl_null(g_all[l_ac].all85) THEN
      IF g_all[l_ac].all85 < 0 THEN
         CALL cl_err('','aim-391',1) 
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_all_t.all85 <> g_all[l_ac].all85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_all[l_ac].all85*g_all[l_ac].all84
            IF cl_null(g_all[l_ac].all82) OR g_all[l_ac].all82=0 THEN 
               LET g_all[l_ac].all82=g_tot*g_all[l_ac].all81
               DISPLAY BY NAME g_all[l_ac].all82                                                            
            END IF                                                    
         END IF
      END IF
   END IF
   IF cl_null(g_all[l_ac].all86) THEN
      LET g_all[l_ac].all87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_all_t.all81 <> g_all[l_ac].all81 OR
             g_all_t.all82 <> g_all[l_ac].all82 OR
             g_all_t.all84 <> g_all[l_ac].all84 OR
             g_all_t.all85 <> g_all[l_ac].all85 OR
             g_all_t.all86 <> g_all[l_ac].all86) THEN
         CALL t740_set_all87()
      END IF
   END IF
   CALL cl_show_fld_cont()  
   RETURN TRUE
END FUNCTION 

FUNCTION t810_all87_check()
   IF NOT cl_null(g_all[l_ac].all87) AND NOT cl_null(g_all[l_ac].all86) THEN
      IF cl_null(g_all_t.all87) OR cl_null(g_all86_t) OR g_all_t.all87 != g_all[l_ac].all87 OR g_all86_t != g_all[l_ac].all86 THEN
         LET g_all[l_ac].all87=s_digqty(g_all[l_ac].all87,g_all[l_ac].all86)
         DISPLAY BY NAME g_all[l_ac].all87
      END IF
   END IF

   IF NOT cl_null(g_all[l_ac].all87) THEN
      IF g_all[l_ac].all87 < 0 THEN
         CALL cl_err('','aim-391',1)  
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION 
#No.FUN-BB0086--add--end--
#CHI-C80041---begin
FUNCTION t740_x()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_alc.alc01) OR cl_null(g_alc.alc02) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t740_cl USING g_alc.alc01,g_alc.alc02
   IF STATUS THEN
      CALL cl_err("OPEN t740_cl:", STATUS, 1)
      CLOSE t740_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t740_cl INTO g_alc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t740_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_alc.alcfirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_alc.alcfirm)   THEN 
        LET g_chr=g_alc.alcfirm
        IF g_alc.alcfirm='N' THEN 
            LET g_alc.alcfirm='X' 
        ELSE
            LET g_alc.alcfirm='N'
        END IF
        UPDATE alc_file
            SET alcfirm=g_alc.alcfirm,  
                alcmodu=g_user,
                alcdate=g_today
            WHERE alc01=g_alc.alc01
              AND alc02=g_alc.alc02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","alc_file",g_alc.alc01,"",SQLCA.sqlcode,"","",1)  
            LET g_alc.alcfirm=g_chr 
        END IF
        DISPLAY BY NAME g_alc.alcfirm 
   END IF
 
   CLOSE t740_cl
   COMMIT WORK
   CALL cl_flow_notify(g_alc.alc01,'V')
 
END FUNCTION
#CHI-C80041---end
