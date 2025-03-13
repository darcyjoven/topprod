# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt320.4gl
# Descriptions...: RMA報廢單作業
# Date & Author..: 98/05/07 plum
#        Modify..: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/14 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-560014 05/06/06 By day  單據編號修改
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: NO.TQC-5A0097 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.TQC-630148 06/03/15 By 報廢單號^P查無單據有問題
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-690053 06/12/06 By Claire 僅允許自動產生單身為報廢的單
# Modify.........: No.CHI-6B0070 06/12/19 By jamie 新增刪除功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/14 By sherry 錄入時單身“RMB單號”不能開窗。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.MOD-830101 08/03/12 BY claire 輸入單身資料,料號不會帶出來
# Modify.........: No.FUN-840068 08/04/24 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-840371 08/04/28 By bnlent   插入時rmp011不可為空
# Modify.........: NO.FUN-860018 08/06/26 BY TSD.jarlin 舊報表轉cr報表  
# Modify.........: No.FUN-890102 08/09/24 By baofei  CR追單到31區
# Modify.........: No.TQC-930066 09/03/09 By chenyu 單身RMA單號開窗增加篩選條件rmc23 IS NULL AND rmc14 = '4'
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10012 01/01/06 by lilingyu g_t變量長度過短
# Modify.........: No.TQC-A20029 10/02/08 By lilingyu 查詢狀態下,單身"RMA單號"開窗錯誤
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A60154 10/06/23 By Sarah 1.單身放棄輸入後,若已沒有單身資料,就不需更新單頭
#                                                  2.詢問"是否刪除單頭及單身所有資料"後,若User選擇N不應該將畫面清空
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/19 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rmj   RECORD LIKE rmj_file.*,
    l_rmp   RECORD LIKE rmp_file.*,
    g_rmj_t RECORD LIKE rmj_file.*,
    g_rmj_o RECORD LIKE rmj_file.*,
    g_rmp_paconfo   LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #頁數
    g_rmj01_t  LIKE rmj_file.rmj01,
    g_rmp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmp02     LIKE rmp_file.rmp02,
                    rmp05     LIKE rmp_file.rmp05,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                  #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmp_t         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp05     LIKE rmp_file.rmp05,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                  #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmp_o         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp05     LIKE rmp_file.rmp05,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                  #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                  #FUN-840068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql          string,  #No.FUN-580092 HCN
   #g_t             LIKE type_file.chr4,    #No.FUN-690010 VARCHAR(05), #No.FUN-550064  #TQC-A10012
    g_t             LIKE type_file.chr6,    #TQC-A10012
    p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_rmp10         LIKE rmp_file.rmp10,    #原修復狀態
    g_auto          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_err           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5     #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1	LIKE rmj_file.rmj01 #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE l_table  STRING      #------NO.FUN-860018 BY TSD.jarlin-----#                                                                
DEFINE g_str    STRING      #------NO.FUN-860018 BY TSD.jarlin-----#    
DEFINE g_void            LIKE type_file.chr1  #CHI-C80041

MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0085
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
   #------NO.FUN-860018 BY TSD.jarlin----------(S)                                                                                  
   LET g_sql = "rmj01.rmj_file.rmj01,",                                                                                             
               "rmj02.rmj_file.rmj02,",                                                                                             
               "rmp02.rmp_file.rmp02,",                                                                                             
               "rmp05.rmp_file.rmp05,",                                                                                             
               "rmp06.rmp_file.rmp06,",                                                                                             
               "rmp11.rmp_file.rmp11,",                                                                                             
               "rmp12.rmp_file.rmp12,",                                                                                             
               "rmp13.rmp_file.rmp13,",                                                                                             
               "rmp14.rmp_file.rmp14,",                                                                                             
               "rmp15.rmp_file.rmp15"                                                                                               
                                                                                                                                    
   LET l_table = cl_prt_temptable('armt320',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   #------NO.FUN-860018 BY TSD.jarlin----------(E) 
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_rmp_paconfo = 1                   #現在單身頁次
    LET p_row = 5 LET p_col = 5
    OPEN WINDOW t320_w AT p_row,p_col WITH FORM "arm/42f/armt320"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_forupd_sql =
         "SELECT * FROM rmj_file WHERE rmj01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t320_cl CURSOR FROM g_forupd_sql
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t320_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t320_a()
             END IF
          OTHERWISE 
                CALL t320_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
    CALL t320_menu()
    CLOSE WINDOW t320_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t320_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_rmp.clear()
  IF cl_null(g_argv1) THEN   #FUN-4A0081
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rmj.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rmj01,rmj02,rmjconf,rmjuser,rmjgrup,rmjmodu,rmjdate,rmjvoid,
      #FUN-840068   ---start---
        rmjud01,rmjud02,rmjud03,rmjud04,rmjud05,
        rmjud06,rmjud07,rmjud08,rmjud09,rmjud10,
        rmjud11,rmjud12,rmjud13,rmjud14,rmjud15
      #FUN-840068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rmj01)             #查詢單据
         #--------------No.TQC-630148 modify
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rmj"
                  LET g_qryparam.default1 = g_rmj.rmj01
                  CALL cl_create_qry()
                       RETURNING g_rmj.rmj01
                   DISPLAY BY NAME g_rmj.rmj01            
                  NEXT FIELD rmj01
         #       LET g_t=g_rmj.rmj01[1,g_doc_len]    #No.FUN-560014
#        #       CALL q_oay(0,0,g_t,'73',g_sys) RETURNING g_t
         #       CALL q_oay(TRUE,TRUE,g_t,'73',g_sys) RETURNING g_qryparam.multiret
         #       DISPLAY g_qryparam.multiret TO rmj01
         #       NEXT FIELD rmj01
         #-------------No.TQC-630148 end-
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
 
    CONSTRUCT g_wc2 ON rmp02,rmp05,rmp06,rmp11,rmp13,rmp14,rmp12,rmp15
                     #No.FUN-840068 --start--
                      ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                      ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                      ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                     #No.FUN-840068 ---end---
         FROM s_rmp[1].rmp02, s_rmp[1].rmp05, s_rmp[1].rmp06,
              s_rmp[1].rmp11,s_rmp[1].rmp13, s_rmp[1].rmp14,
              s_rmp[1].rmp12, s_rmp[1].rmp15
            #No.FUN-840068 --start--
             ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
             ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
             ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
             ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
  	     ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
           #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rmp05)             #查詢單据
#TQC-A20029 --begin--
##                 CALL q_rma2(0,0,'70')
##                      RETURNING g_rmp[1].rmp05,g_rmp[1].rmp06
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                 #LET g_qryparam.form = "q_rma2"   #No.TQC-930066 mark
#                  LET g_qryparam.form = "q_rma5"   #No.TQC-930066 add
#                  LET g_qryparam.default1 = g_rmp[1].rmp05
#                  LET g_qryparam.arg1 = '70'
#                  LET g_qryparam.arg2 = g_doc_len     #No.TQC-630148 add
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO rmp05
#                  NEXT FIELD rmp05
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_rmp5" 
                  LET g_qryparam.default1 = g_rmp[1].rmp05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmp05
                  NEXT FIELD rmp05
#TQC-A20029 --end--
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
 
  #FUN-4A0081
  ELSE
      LET g_wc =" rmj01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
  #--
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmjuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmjgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmjgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmjuser', 'rmjgrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT rmj01 FROM rmj_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rmj01"
     ELSE                                         # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rmj01 ",
                   "  FROM rmj_file, rmp_file",
                   " WHERE rmj01 = rmp01 AND rmp00='3' ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rmj01"
    END IF
    PREPARE t320_prepare FROM g_sql
    DECLARE t320_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t320_prepare
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rmj_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rmj01) FROM rmj_file,rmp_file WHERE ",
                  "rmp01=rmj01 AND ",g_wc CLIPPED," AND ", g_wc2 CLIPPED
    END IF
    PREPARE t320_precount FROM g_sql
    DECLARE t320_count CURSOR FOR t320_precount
END FUNCTION
 
FUNCTION t320_menu()
 
   WHILE TRUE
      CALL t320_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth()
               THEN CALL t320_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t320_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t320_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t320_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t320_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output "
            IF cl_chk_act_auth() THEN
               CALL t320_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            CALL t320_y()
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            CALL t320_z()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmp),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rmj.rmj01 IS NOT NULL THEN
                 LET g_doc.column1 = "rmj01"
                 LET g_doc.value1 = g_rmj.rmj01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
 
         #CHI-6B0070---add---str---
         #@WHEN "刪除"
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t320_r()
            END IF
         #CHI-6B0070---add---end---
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t320_v()    #CHI-D20010
               CALL t320_v(1)   #CHI-D20010
               IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid)
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t320_v(2)
               IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t320_a()
   DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
   DEFINE g_i         LIKE type_file.num10         #No.FUN-690010 INTEGER
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_rmp.clear()
   LET g_wc=NULL
   LET g_wc2=NULL
   INITIALIZE g_rmj.* TO NULL
   LET g_rmj_o.* = g_rmj.*
   LET g_rmj01_t = NULL
   CALL cl_opmsg('a')
   SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_rmz.rmz18
   WHILE TRUE
      INITIALIZE g_rmj.* TO NULL
      LET g_success = 'Y'
      LET g_auto = 'N'
      LET g_rmj.rmj01 = g_rmz.rmz18
      LET g_rmj.rmj02 = g_today
      LET g_rmj.rmjconf='N'
      LET g_rmj.rmjpost='N'
      LET g_rmj.rmjvoid="Y"
      LET g_rmj.rmjuser=g_user
      LET g_rmj.rmjoriu = g_user #FUN-980030
      LET g_rmj.rmjorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_rmj.rmjgrup=g_grup
      LET g_rmj.rmjdate=g_today
      LET p_cmd="a"
      BEGIN WORK
      CALL t320_i("a")                #輸入單頭
      IF INT_FLAG THEN
         LET INT_FLAG=0 CALL cl_err('',9044,0)
         EXIT WHILE
      END IF
      IF g_rmj.rmj01 IS NULL THEN CONTINUE WHILE END IF
      #No.FUN-550064 --start--
      CALL s_auto_assign_no("arm",g_rmj.rmj01,g_today,"","rmj_file","rmj01","","","")  #No.FUN-560014
           RETURNING li_result,g_rmj.rmj01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rmj.rmj01
#     IF g_oay.oayauno='Y' THEN
#        CALL s_armauno(g_rmj.rmj01,g_today) RETURNING g_i,g_rmj.rmj01
#        IF g_i THEN CONTINUE WHILE END IF       #有問題
#        DISPLAY BY NAME g_rmj.rmj01
#     END IF
   #No.FUN-550064 ---end---
 
      LET g_rmj.rmjplant = g_plant  #FUN-980007
      LET g_rmj.rmjlegal = g_legal  #FUN-980007
      INSERT INTO rmj_file VALUES (g_rmj.*)
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success = 'N'
 #       CALL cl_err(g_rmj.rmj01,STATUS,1) # FUN-660111
         CALL cl_err3("ins","rmj_file",g_rmj.rmj01,"",STATUS,"","",1) # FUN-660111
         EXIT WHILE
      END IF
      CALL cl_flow_notify(g_rmj.rmj01,'I')
     #str MOD-A60154 add
      IF g_success="N" THEN
         ROLLBACK WORK
         CALL cl_err('',9052,0)
         CLEAR FORM
         CALL g_rmp.clear()
         EXIT WHILE
      ELSE
         COMMIT WORK
      END IF
     #end MOD-A60154 add
     #CALL cl_msgany(0,0,'新增OK!')
      CALL g_rmp.clear()
      #由 RMA單(rmc)依單頭所輸入:rmj  產生單身:rmp
      LET g_rec_b=0                               #No.FUN-680064
      IF cl_confirm('aap-701') THEN
         CALL t320_g_b()
         IF INT_FLAG THEN
            LET INT_FLAG=0 CALL cl_err('',9001,0) EXIT WHILE
         END IF
         IF g_rec_b=0 OR g_success="N" THEN EXIT WHILE END IF
         LET g_auto = 'Y'
      END IF
      LET g_rmj_t.* = g_rmj.*
      SELECT rmj01 INTO g_rmj.rmj01 FROM rmj_file
       WHERE rmj01=g_rmj_t.rmj01
      CALL t320_b()                   #單身的conf
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         CALL t320_show()
         EXIT WHILE
      END IF
      SELECT COUNT(*) INTO g_rec_b FROM rmp_file
       WHERE rmp01=g_rmj.rmj01 AND rmp00="3"
#CHI-C30002 ------- mark ------ begin  #此段刪除提示已經添加到單身函數的結尾
#     IF g_rec_b =0 THEN
#        IF cl_delh(0,0) THEN
#           INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
#           LET g_doc.column1 = "rmj01"         #No.FUN-9B0098 10/02/24
#           LET g_doc.value1 = g_rmj.rmj01      #No.FUN-9B0098 10/02/24
#           CALL cl_del_doc()                                                 #No.FUN-9B0098 10/02/24
#           DELETE FROM rmj_file WHERE rmj01=g_rmj.rmj01
#       #END IF   #MOD-A60154 mark
#           CLEAR FORM
#           CALL g_rmp.clear()
#        END IF   #MOD-A60154 add
#        EXIT WHILE
#     END IF
#CHI-C30002 ------- mark ------ end
     #str MOD-A60154 mark
     #IF g_success="N" THEN
     #   ROLLBACK WORK
     #   CALL cl_err('',9052,0)
     #   CLEAR FORM
     #   CALL g_rmp.clear()
     #   EXIT WHILE
     #ELSE
     #   COMMIT WORK
     #END IF
     #end MOD-A60154 mark
      CALL t320_show()
      EXIT WHILE
   END WHILE
END FUNCTION
 
#依單頭所輸入的:rmj01產生符合的單身(rmc23 is null and rmc14 matches "0" )
FUNCTION t320_g_b()
   DEFINE   g_wc3   LIKE type_file.chr1000,#TQC-5A0134 VARCHAR-->CHAR  #No.FUN-690010 VARCHAR(100)
            l_str   STRING,   #MOD-830101
            g_n,i,j LIKE type_file.num5  #MOD-830101  #No.FUN-690010 SMALLINT 
 
   CONSTRUCT g_wc3 ON rmp05,rmp06,rmp11   
        FROM s_rmp[1].rmp05, s_rmp[1].rmp06, s_rmp[1].rmp11   
 # CONSTRUCT g_wc3 ON rmp02,rmp05,rmp06,rmp11   
 #      FROM s_rmp[1].rmp02,s_rmp[1].rmp05, s_rmp[1].rmp06, s_rmp[1].rmp11  #No.TQC-750041 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds   #MOD-A60154 mod
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 #No.TQC-750041---Begin 
      ON ACTION CONTROLP                                                                                                          
         CASE
            WHEN INFIELD(rmp05)             #查詢單                                                                              
#                CALL q_rma2(0,0,'70')                                                                                             
#                     RETURNING g_rmp[1].rmp05,g_rmp[1].rmp06                                                                      
                 CALL cl_init_qry_var()                                                                                            
                 LET g_qryparam.state = 'c'                                                                                        
                #LET g_qryparam.form = "q_rma2"  #No.TQC-930066 mark
                 LET g_qryparam.form = "q_rma5"  #No.TQC-930066 add
                 LET g_qryparam.default1 = g_rmp[1].rmp05                                                                          
                 LET g_qryparam.arg1 = '70'                                                                                        
                 LET g_qryparam.arg2 = g_doc_len     #No.TQC-630148 add                                                            
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                 DISPLAY g_qryparam.multiret TO rmp05                                                                              
                 NEXT FIELD rmp05                                                                                                  
         END CASE      
 #No.TQC-750041---End          
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
 
   IF INT_FLAG THEN RETURN END IF
   LET l_str=g_wc3 CLIPPED   #MOD-830101
   LET j=FGL_WIDTH(l_str)    #MOD-830101
   FOR i = 1 TO j   #MOD-830101 modify 96
      IF i=j THEN EXIT FOR END IF   #MOD-830101
      CASE g_wc3[i,i+4]
          WHEN "rmp05"
               LET g_wc3[i,i+4]="rmc01"
               LET i=i+5
          WHEN "rmp06"
               LET g_wc3[i,i+4]="rmc02"
               LET i=i+5
          WHEN "rmp11"
               LET g_wc3[i,i+4]="rmc04"
               LET i=i+5
      END CASE
   END FOR
   LET g_sql =" SELECT '3','','','','','',rmc01,rmc02, ",
              " rmc31-rmc311-rmc312-rmc313,0,'',rmc14,rmc04, ",
              " rmc05,rmc06,rmc061,rmc07 ",
              " FROM  rmc_file,rma_file ",
              " WHERE rmc23 IS NULL AND rmc14 IN ('4') ",  #CHI-690053 012->4
              "   AND rmc04 != 'MISC' AND rma01=rmc01 ",
              "   AND rmaconf='Y'     AND rmavoid='Y' AND ",g_wc3 CLIPPED,
              " ORDER BY rmc01,rmc02 "
 
   PREPARE t320_rmppb FROM g_sql
   IF SQLCA.SQLCODE != 0 THEN
      CALL cl_err('pre1: rmc',SQLCA.sqlcode,0)
      LET g_success="N"
      RETURN
   END IF
   DECLARE rmc_curs CURSOR FOR t320_rmppb         #SCROLL CURSOR
 
   LET g_cnt = 1
   LET g_rec_b = 0
  #BEGIN WORK   #MOD-830101 mark
 
   FOREACH rmc_curs INTO l_rmp.*          #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
      ELSE
         LET g_n=0
         SELECT COUNT(*) INTO g_n FROM rmj_file,rmp_file
          WHERE rmp01 <> g_rmj.rmj01
            AND rmp00='3' AND rmp05=l_rmp.rmp05  #MOD-A60154 mod 0->3
            AND rmp06=l_rmp.rmp06 AND rmp01=rmj01 AND rmjvoid='Y'
            AND rmjconf <> 'X' #CHI-C80041
         IF g_n >= 1 THEN CONTINUE FOREACH END IF
         IF l_rmp.rmp07 IS NULL THEN LET l_rmp.rmp07=0 END IF
         IF l_rmp.rmp08 IS NULL THEN LET l_rmp.rmp08=0 END IF
         #NO.TQC-790003 start--
         IF cl_null(l_rmp.rmp01) THEN LET l_rmp.rmp01 = ' ' END IF
         IF cl_null(l_rmp.rmp011) THEN LET l_rmp.rmp011 = 0 END IF
         IF cl_null(l_rmp.rmp02) THEN LET l_rmp.rmp02 = 0 END IF
         #no.TQC-790003 end----
         INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,rmp05,
                              rmp06,rmp07,rmp08,rmp09,rmp10,rmp11,rmp12,
                              rmp13,rmp14,rmp15,rmp909, #No.MOD-470041
                              rmpplant,rmplegal) #FUN-980007
         VALUES ('3',g_rmj.rmj01,l_rmp.rmp011,g_cnt,'','',l_rmp.rmp05,l_rmp.rmp06, #No.MOD-840371 rmp011 not null
                 l_rmp.rmp07,0,'',l_rmp.rmp10,l_rmp.rmp11,l_rmp.rmp12,l_rmp.rmp13,
                 l_rmp.rmp14,l_rmp.rmp15,'',
                 g_plant,g_legal) #FUN-980007
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#           CALL cl_err('ins rmp',STATUS,1)  #FUN-660111
            CALL cl_err3("ins","rmp_file",g_rmj.rmj01,g_cnt,SQLCA.sqlcode,"","ins rmp",1) # FUN-660111
            ROLLBACK WORK
            LET g_success="N"
            EXIT FOREACH
         END IF
         LET g_rec_b = g_rec_b + 1
         LET g_cnt = g_cnt + 1
      END IF
   END FOREACH
   IF g_rec_b =0 THEN
      CALL cl_err('body: ','aap-129',0)
      LET g_success="N"
      ROLLBACK WORK
      RETURN
   ELSE
      IF g_success="N" THEN
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF
   END IF
   CALL t320_b_fill(" 1=1")
   LET g_rmp_paconfo = 0
END FUNCTION
 
#處理INPUT
FUNCTION t320_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
 
    LET g_t = s_get_doc_no(g_rmj.rmj01)     #No.FUN-550064
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t
 
    DISPLAY BY NAME g_rmj.rmj01,g_rmj.rmj02,g_rmj.rmjconf,g_rmj.rmjvoid,
                    g_rmj.rmjuser,g_rmj.rmjgrup,g_rmj.rmjmodu,g_rmj.rmjdate,
                  #FUN-840068     ---start---
                    g_rmj.rmjud01,g_rmj.rmjud02,g_rmj.rmjud03,g_rmj.rmjud04,
                    g_rmj.rmjud05,g_rmj.rmjud06,g_rmj.rmjud07,g_rmj.rmjud08,
                    g_rmj.rmjud09,g_rmj.rmjud10,g_rmj.rmjud11,g_rmj.rmjud12,
                    g_rmj.rmjud13,g_rmj.rmjud14,g_rmj.rmjud15 
                  #FUN-840068     ----end----
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_rmj.rmjoriu,g_rmj.rmjorig,
        g_rmj.rmj01,g_rmj.rmj02,
      #FUN-840068     ---start---
        g_rmj.rmjud01,g_rmj.rmjud02,g_rmj.rmjud03,g_rmj.rmjud04,
        g_rmj.rmjud05,g_rmj.rmjud06,g_rmj.rmjud07,g_rmj.rmjud08,
        g_rmj.rmjud09,g_rmj.rmjud10,g_rmj.rmjud11,g_rmj.rmjud12,
        g_rmj.rmjud13,g_rmj.rmjud14,g_rmj.rmjud15 
      #FUN-840068     ----end----
    WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t320_set_entry(p_cmd)
            CALL t320_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rmj01")
         #No.FUN-550064 ---end---
 
#No.FUN-570109 --start
#       BEFORE FIELD rmj01
#           IF p_cmd="u" THEN NEXT FIELD rmj02 END IF
#No.FUN-570109 --end
 
        AFTER FIELD rmj01
        #No.FUN-550064 --start--
         IF g_rmj.rmj01 != g_rmj01_t OR g_rmj01_t IS NULL THEN
           #CALL s_check_no("arm",g_rmj.rmj01,"","73","rmj_file","rmj01","")   #No.FUN-560014
            CALL s_check_no("arm",g_rmj.rmj01,g_rmj01_t,"73","rmj_file","rmj01","")   #No.FUN-560014  #FUN-B50026 mod 更改時,單號不變欄位會過不去
            RETURNING li_result,g_rmj.rmj01
            DISPLAY BY NAME g_rmj.rmj01
            IF (NOT li_result) THEN
               LET g_rmj.rmj01=g_rmj_o.rmj01
               NEXT FIELD rmj01
            END IF
#           IF NOT cl_null(g_rmj.rmj01) THEN
#               LET g_t=g_rmj.rmj01[1,3]
#               CALL s_axmslip(g_t,'73',g_sys)           #檢查報廢單單別:73
#               IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                  CALL cl_err(g_t,g_errno,0)
#                  NEXT FIELD rmj01
#               END IF
#               IF cl_null(g_rmj.rmj01[5,10]) AND NOT cl_null(g_rmj.rmj01[1,3]) THEN
#                  IF g_oay.oayauno = 'N' THEN
#                     CALL cl_err('','aap-011',0)  #此單別無自動編號,需人工
#                     NEXT FIELD rmj01
#                  ELSE
#                     NEXT FIELD rmj02
#                  END IF
#               END IF
#               IF g_rmj.rmj01 != g_rmj01_t OR g_rmj_t.rmj01 IS NULL THEN
#                   IF g_oay.oayauno = 'Y' AND NOT cl_chk_data_continue(g_rmj.rmj01[5,10]) THEN
#                      CALL cl_err('','9056',0) NEXT FIELD rmj01
#                   END IF
#                   SELECT count(*) INTO g_cnt FROM rmj_file
#                       WHERE rmj01 = g_rmj.rmj01
#                   IF g_cnt > 0 THEN   #資料重複
#                       CALL cl_err(g_rmj.rmj01,-239,0)
#                       LET g_rmj.rmj01 = g_rmj_t.rmj01
#                       DISPLAY BY NAME g_rmj.rmj01
#                       NEXT FIELD rmj01
#                   END IF
#               END IF
#           END IF
#           LET g_rmj_o.rmj01 = g_rmj.rmj01
        END IF
         #No.FUN-550064 ---end---
 
      #FUN-840068     ---start---
        AFTER FIELD rmjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
  
        AFTER FIELD rmjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #FUN-840068     ----end----
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rmj01)             #查詢單据
                 LET g_t = s_get_doc_no(g_rmj.rmj01)     #No.FUN-550064
#                CALL q_oay(0,0,g_t,'73',g_sys) RETURNING g_t
                #CALL q_oay(FALSE,FALSE,g_t,'73',g_sys) RETURNING g_t  #TQC-670008
                 CALL q_oay(FALSE,FALSE,g_t,'73','ARM') RETURNING g_t  #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t )
#                     LET g_rmj.rmj01[1,3]=g_t   #No.TQC-5A0097
                      LET g_rmj.rmj01 = g_t                 #No.FUN-550064
                      DISPLAY BY NAME g_rmj.rmj01
                      NEXT FIELD rmj01
            END CASE
 
        ON ACTION CONTROLF                     #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
END FUNCTION
 
FUNCTION t320_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
    IF g_rmj.rmj01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    LET g_rmj01_t = g_rmj.rmj01  #FUN-B50026 add
    IF g_rmj.rmjvoid = 'N' THEN  CALL cl_err('void=N',9027,0) RETURN END IF
    IF g_rmj.rmjconf = 'Y' THEN  CALL cl_err('conf=Y',9023,0) RETURN END IF
    IF g_rmj.rmjpost = 'Y' THEN  CALL cl_err('post=Y','aap-730',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET p_cmd="u"
    LET g_rmj_o.* = g_rmj.*
    BEGIN WORK
 
    OPEN t320_cl USING g_rmj.rmj01
    IF STATUS THEN
       CALL cl_err("OPEN t320_cl:", STATUS, 1)
       CLOSE t320_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t320_cl INTO g_rmj.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t320_cl ROLLBACK WORK RETURN
    END IF
    CALL t320_show()
    WHILE TRUE
        LET g_rmj.rmjmodu=g_user
        LET g_rmj.rmjdate=g_today
        CALL t320_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rmj.*=g_rmj_t.*
            CALL t320_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rmj_file SET * = g_rmj.* WHERE rmj01 = g_rmj.rmj01
        IF STATUS THEN
#         CALL cl_err(g_rmj.rmj01,STATUS,0)  #FUN-660111
          CALL cl_err3("upd","rmj_file",g_rmj_t.rmj01,"",STATUS,"","",1) # FUN-660111
         CONTINUE WHILE END IF
       #IF g_rmj.rmj01 != g_rmj_t.rmj01 THEN CALL t320_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t320_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rmj.rmj01,'U')
 
END FUNCTION
 
FUNCTION t320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rmj.* TO NULL               #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    LET p_cmd="u"
    LET g_auto="N"
    CALL t320_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_rmj.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t320_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rmj.* TO NULL
    ELSE
        OPEN t320_count
        FETCH t320_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t320_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t320_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t320_cs INTO g_rmj.rmj01
        WHEN 'P' FETCH PREVIOUS t320_cs INTO g_rmj.rmj01
        WHEN 'F' FETCH FIRST    t320_cs INTO g_rmj.rmj01
        WHEN 'L' FETCH LAST     t320_cs INTO g_rmj.rmj01
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
            FETCH ABSOLUTE g_jump t320_cs INTO g_rmj.rmj01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rmj.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
    IF SQLCA.sqlcode THEN
  #      CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0) # FUN-660111
        CALL cl_err3("sel","rmj_file",g_rmj.rmj01,"",SQLCA.sqlcode,"","",1) # FUN-660111
        INITIALIZE g_rmj.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rmj.rmjuser #FUN-4C0055
        LET g_data_group = g_rmj.rmjgrup #FUN-4C0055
        LET g_data_plant = g_rmj.rmjplant #FUN-980030
    END IF
 
    CALL t320_show()
END FUNCTION
 
FUNCTION t320_show()
 
    LET g_rmj_t.* = g_rmj.*                #保存單頭舊值
    DISPLAY BY NAME g_rmj.rmjoriu,g_rmj.rmjorig,
 
 
        g_rmj.rmj01,g_rmj.rmj02,g_rmj.rmjconf,g_rmj.rmjvoid,g_rmj.rmjuser,
        g_rmj.rmjgrup, g_rmj.rmjmodu,g_rmj.rmjdate,
      #FUN-840068     ---start---
        g_rmj.rmjud01,g_rmj.rmjud02,g_rmj.rmjud03,g_rmj.rmjud04,
        g_rmj.rmjud05,g_rmj.rmjud06,g_rmj.rmjud07,g_rmj.rmjud08,
        g_rmj.rmjud09,g_rmj.rmjud10,g_rmj.rmjud11,g_rmj.rmjud12,
        g_rmj.rmjud13,g_rmj.rmjud14,g_rmj.rmjud15 
      #FUN-840068     ----end----
    #CKP
    #CALL cl_set_field_pic(g_rmj.rmjconf  ,"","","","",g_rmj.rmjvoid)  #CHI-C80041
    IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid) #CHI-C80041
 
    CALL t320_b_fill(g_wc2)
    LET g_rmp_paconfo = 0
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#CHI-6B0070---add---str---
FUNCTION t320_r()
 
IF s_shut(0) THEN
RETURN
END IF
 
IF g_rmj.rmj01 IS NULL THEN
CALL cl_err("",-400,0)
RETURN
END IF
 
SELECT * INTO g_rmj.* FROM rmj_file
WHERE rmj01=g_rmj.rmj01
IF g_rmj.rmjconf ='Y' THEN           #檢查資料是否確認
CALL cl_err(g_rmj.rmj01,'9023',0)
RETURN
END IF
BEGIN WORK
 
OPEN t320_cl USING g_rmj.rmj01
 IF STATUS THEN
    CALL cl_err("OPEN t320_cl:", STATUS, 1)
    CLOSE t320_cl
    ROLLBACK WORK
    RETURN
 END IF
 
 FETCH t320_cl INTO g_rmj.*               # 鎖住將被更改或取消的資料
 IF SQLCA.sqlcode THEN
    CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)          #資料被他人LOCK
    ROLLBACK WORK
    RETURN
 END IF
 
 CALL t320_show()
 
 IF cl_delh(0,0) THEN                   #確認一下
     INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
     LET g_doc.column1 = "rmj01"         #No.FUN-9B0098 10/02/24
     LET g_doc.value1 = g_rmj.rmj01      #No.FUN-9B0098 10/02/24
     CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
    DELETE FROM rmj_file WHERE rmj01 = g_rmj.rmj01
    DELETE FROM rmp_file WHERE rmp01 = g_rmj.rmj01
    CLEAR FORM
    CALL g_rmp.clear()
    OPEN t320_count
    #FUN-B50064-add-start--
    IF STATUS THEN
       CLOSE t320_cs
       CLOSE t320_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    FETCH t320_count INTO g_row_count
    #FUN-B50064-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE t320_cs
       CLOSE t320_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t320_cs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL t320_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE
       CALL t320_fetch('/')
    END IF
 END IF
 
 CLOSE t320_cl
 COMMIT WORK
 CALL cl_flow_notify(g_rmj.rmj01,'D')
END FUNCTION
#CHI-6B0070---add---end---
 
FUNCTION t320_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    g_n             LIKE type_file.num5,   #No.FUN-690010 SMALLINT,
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    g_rmp07,g_rmp311,l_total    LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
    IF g_rmj.rmj01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    IF g_rmj.rmjvoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
    IF g_rmj.rmjpost = 'Y' THEN CALL cl_err('post=Y','aap-730',0) RETURN END IF
    IF g_rmj.rmjconf = 'Y' THEN CALL cl_err('conf=Y',9003,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT rmp02,rmp05,rmp06,rmp11,rmp13,rmp14,rmp12,rmp15, ",
   #No.FUN-840068 --start--
     "       rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
     "       rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
     "       rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
   #No.FUN-840068 ---end---
     "  FROM rmp_file ",
     "  WHERE rmp01= ? ",
     "    AND rmp02= ? ",
     "    AND rmp00= '3' ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t320_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET g_rmp_paconfo = 1
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rmp
              WITHOUT DEFAULTS
              FROM s_rmp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_total=ARR_COUNT()
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t320_cl USING g_rmj.rmj01
            IF STATUS THEN
               CALL cl_err("OPEN t320_cl:", STATUS, 1)
               CLOSE t320_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t320_cl INTO g_rmj.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t320_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmp_t.* = g_rmp[l_ac].*  #BACKUP
               LET g_rmp_o.* = g_rmp[l_ac].*  #BACKUP
                OPEN t320_bcl USING g_rmj.rmj01,g_rmp_t.rmp02
                IF STATUS THEN
                    CALL cl_err("OPEN t320_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t320_bcl INTO g_rmp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET p_cmd='u'
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmp02
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,
                                 rmp05,rmp06,rmp07,rmp08,rmp09,
                                 rmp10,rmp11,rmp12,rmp13,rmp14,
                                 rmp15,
                               #FUN-840068 --start--
                                 rmpud01,rmpud02,rmpud03,
                                 rmpud04,rmpud05,rmpud06,
                                 rmpud07,rmpud08,rmpud09,
                                 rmpud10,rmpud11,rmpud12,
                                 rmpud13,rmpud14,rmpud15,
                                 rmpplant,rmplegal) #FUN-980007
                               #FUN-840068 --end--
              VALUES('3',g_rmj.rmj01,0,g_rmp[l_ac].rmp02,
                     '','',g_rmp[l_ac].rmp05,g_rmp[l_ac].rmp06,
                     0,0,'',g_rmp10,g_rmp[l_ac].rmp11,
                     g_rmp[l_ac].rmp12, g_rmp[l_ac].rmp13,
                     g_rmp[l_ac].rmp14, g_rmp[l_ac].rmp15,
                   #FUN-840068 --start--
                     g_rmp[l_ac].rmpud01,
                     g_rmp[l_ac].rmpud02,
                     g_rmp[l_ac].rmpud03,
                     g_rmp[l_ac].rmpud04,
                     g_rmp[l_ac].rmpud05,
                     g_rmp[l_ac].rmpud06,
                     g_rmp[l_ac].rmpud07,
                     g_rmp[l_ac].rmpud08,
                     g_rmp[l_ac].rmpud09,
                     g_rmp[l_ac].rmpud10,
                     g_rmp[l_ac].rmpud11,
                     g_rmp[l_ac].rmpud12,
                     g_rmp[l_ac].rmpud13,
                     g_rmp[l_ac].rmpud14,
                     g_rmp[l_ac].rmpud15,
                     g_plant,g_legal)              #FUN-980007
                   #FUN-840068 --end--
 
              IF SQLCA.sqlcode THEN
 #                 CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0) # FUN-660111
                  CALL cl_err3("ins","rmp_file",g_rmj.rmj01,g_rmp[l_ac].rmp02,SQLCA.sqlcode,"","",1) # FUN-660111
                  #CKP
                  ROLLBACK WORK
                  CANCEL INSERT
              ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_rmp[l_ac].* TO NULL      #900423
            LET g_rmp_t.* = g_rmp[l_ac].*         #新輸入資料
            LET g_rmp_o.* = g_rmp[l_ac].*         #新輸入資料
            NEXT FIELD rmp02
 
        BEFORE FIELD rmp02                        #default 序號
            IF g_rmp[l_ac].rmp02 IS NULL OR
               g_rmp[l_ac].rmp02 = 0 THEN
                SELECT max(rmp02)+1
                   INTO g_rmp[l_ac].rmp02
                   FROM rmp_file
                   WHERE rmp01 = g_rmj.rmj01
                IF g_rmp[l_ac].rmp02 IS NULL THEN
                    LET g_rmp[l_ac].rmp02 = 1
                END IF
           END IF
          IF NOT cl_null(g_rmp[l_ac].rmp05) THEN
              CALL t320_rmp10()
          END IF
 
        AFTER FIELD rmp02                        #check 序號是否重複
          IF NOT cl_null(g_rmp[l_ac].rmp02) THEN
             IF g_rmp[l_ac].rmp02 != g_rmp_o.rmp02 OR
                g_rmp_o.rmp02 IS NULL THEN
                SELECT count(*) INTO l_n FROM rmp_file
                 WHERE rmp00="3" AND rmp01 = g_rmj.rmj01   #MOD-A60154 0->3
                   AND rmp02 = g_rmp[l_ac].rmp02
                IF l_n > 0 THEN
                    LET g_rmp[l_ac].rmp02 = g_rmp_t.rmp02
                    DISPLAY g_rmp[l_ac].rmp02 TO s_rmp[l_sl].rmp02
                    CALL cl_err('',-239,0) NEXT FIELD rmp02
                END IF
             END IF
          END IF
          LET g_rmp_o.rmp02=g_rmp[l_ac].rmp02
 
       AFTER FIELD rmp05
          IF NOT cl_null(g_rmp[l_ac].rmp05) THEN
              IF g_rmp[l_ac].rmp05 != g_rmp_o.rmp05 OR
                 g_rmp_o.rmp05 IS NULL THEN
                 SELECT * FROM rma_file
                  WHERE rma09 !='6' AND rmavoid='Y'
                    AND rmaconf='Y' AND rma01=g_rmp[l_ac].rmp05
                 IF STATUS THEN 
  #               CALL cl_err(g_rmp[l_ac].rmp05,'aap-129',0) # FUN-660111
                 CALL cl_err3("sel","rma_file",g_rmp[l_ac].rmp05,"","aap-129","","",1) # FUN-660111
                    NEXT FIELD rmp05
                 END IF
              END IF
          END IF
          LET g_rmp_o.rmp05=g_rmp[l_ac].rmp05
 
       AFTER FIELD rmp06
          IF NOT cl_null(g_rmp[l_ac].rmp06) THEN
              LET g_n =0
              #檢查同一張報廢單是否有重覆資料: ( RMA 單號+項次+rmp00='3')
              SELECT count(*) INTO g_n FROM rmp_file
               WHERE rmp00='3' AND rmp01 =g_rmj.rmj01
                 AND rmp02 <> g_rmp[l_ac].rmp02
                 AND rmp05 = g_rmp[l_ac].rmp05 AND rmp06 = g_rmp[l_ac].rmp06
              IF g_n>=1 THEN
                  LET g_rmp[l_ac].rmp05 = g_rmp_t.rmp05
                  LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                  DISPLAY g_rmp[l_ac].rmp05,g_rmp[l_ac].rmp06
                       TO s_rmp[l_sl].rmp05,s_rmp[l_sl].rmp06
                  CALL cl_err('',-239,0)
                  NEXT FIELD rmp05
              END IF
              #檢查rmp是否有重覆資料: only one ( RMA 單號+項次+rmp00='3')
              SELECT count(*) INTO g_n FROM rmj_file,rmp_file
               WHERE rmp00='3' AND rmp01 <> g_rmj.rmj01
                 AND rmp05 = g_rmp[l_ac].rmp05 AND rmp06 = g_rmp[l_ac].rmp06
                 AND rmp01=rmj01 AND rmjvoid='Y'
                 AND rmjconf <> 'X' #CHI-C80041
              IF g_n >=1 THEN
                  LET g_rmp[l_ac].rmp05 = g_rmp_t.rmp05
                  LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                  DISPLAY g_rmp[l_ac].rmp05,g_rmp[l_ac].rmp06
                       TO s_rmp[l_sl].rmp05,s_rmp[l_sl].rmp06
                  CALL cl_err('','arm-020',0)
                  NEXT FIELD rmp05
              END IF
              
              LET g_err="N"
              CALL t320_get_rmc()
              IF g_err="Y" THEN
                 CALL cl_err('','aap-129',0)
                 DISPLAY g_rmp[l_ac].* TO s_rmp[l_sl].*
                 NEXT FIELD rmp05
              END IF
              DISPLAY g_rmp[l_ac].* TO s_rmp[l_sl].*
          END IF
          LET g_rmp_o.rmp05 = g_rmp[l_ac].rmp05
          LET g_rmp_o.rmp06 = g_rmp[l_ac].rmp06
 
      #No.FUN-840068 --start--
        AFTER FIELD rmpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmp_t.rmp02 > 0 AND
               g_rmp_t.rmp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmp_file
                 WHERE rmp00="3" AND rmp01 = g_rmj.rmj01
                   AND rmp02 = g_rmp_t.rmp02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,0) # FUN-660111
                   CALL cl_err3("del","rmp_file",g_rmj.rmj01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) # FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmp[l_ac].* = g_rmp_t.*
               CLOSE t320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmp[l_ac].rmp02,-263,1)
                LET g_rmp[l_ac].* = g_rmp_t.*
            ELSE
                UPDATE rmp_file SET
                       rmp02=g_rmp[l_ac].rmp02,
                       rmp05=g_rmp[l_ac].rmp05,
                       rmp06=g_rmp[l_ac].rmp06,
                       rmp11=g_rmp[l_ac].rmp11,
                       rmp12=g_rmp[l_ac].rmp12,
                       rmp13=g_rmp[l_ac].rmp13,
                       rmp14=g_rmp[l_ac].rmp14,
                       rmp15=g_rmp[l_ac].rmp15,
                       rmp10=g_rmp10,
                     #FUN-840068 --start--
                       rmpud01 = g_rmp[l_ac].rmpud01,
                       rmpud02 = g_rmp[l_ac].rmpud02,
                       rmpud03 = g_rmp[l_ac].rmpud03,
                       rmpud04 = g_rmp[l_ac].rmpud04,
                       rmpud05 = g_rmp[l_ac].rmpud05,
                       rmpud06 = g_rmp[l_ac].rmpud06,
                       rmpud07 = g_rmp[l_ac].rmpud07,
                       rmpud08 = g_rmp[l_ac].rmpud08,
                       rmpud09 = g_rmp[l_ac].rmpud09,
                       rmpud10 = g_rmp[l_ac].rmpud10,
                       rmpud11 = g_rmp[l_ac].rmpud11,
                       rmpud12 = g_rmp[l_ac].rmpud12,
                       rmpud13 = g_rmp[l_ac].rmpud13,
                       rmpud14 = g_rmp[l_ac].rmpud14,
                       rmpud15 = g_rmp[l_ac].rmpud15
                     #FUN-840068 --end-- 
                 WHERE rmp00="3" AND rmp01=g_rmj.rmj01 AND
                       rmp02=g_rmp_t.rmp02
                IF SQLCA.sqlcode THEN
 #                   CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0) # FUN-660111
                  CALL cl_err3("upd","rmp_file",g_rmj.rmj01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) # FUN-660111
                    LET g_rmp[l_ac].* = g_rmp_t.*
                    DISPLAY g_rmp[l_ac].* TO s_rmp[l_sl].*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmp[l_ac].* = g_rmp_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030  add
           #CKP
           #LET g_rmp_t.* = g_rmp[l_ac].*          # 900423
            CLOSE t320_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL t320_b_askkey()
       #    EXIT INPUT
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmp05)     #RMA單號
#                 CALL q_rma2(0,0,'70')
#                      RETURNING g_rmp[l_ac].rmp05,g_rmp[l_ac].rmp06
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_rma2"   #No.TQC-930066 mark
                  LET g_qryparam.form = "q_rma5"   #No.TQC-930066 add
                  LET g_qryparam.default1 = g_rmp[l_ac].rmp05
                  LET g_qryparam.arg1 = '70'
                  LET g_qryparam.arg2 = g_doc_len       #No.TQC-630148
                  CALL cl_create_qry()
                       RETURNING g_rmp[l_ac].rmp05,g_rmp[l_ac].rmp06
                   DISPLAY BY NAME g_rmp[l_ac].rmp05            #No.MOD-490371
                   DISPLAY BY NAME g_rmp[l_ac].rmp06            #No.MOD-490371
                  NEXT FIELD rmp05
               OTHERWISE EXIT CASE
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
        END INPUT
 
   #str MOD-A60154 add
   #若已沒有單身資料,就不需更新單頭
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM rmp_file WHERE rmp01=g_rmj.rmj01 AND rmp00='3'
    IF cl_null(g_cnt) THEN LET g_cnt=0 END IF
    IF g_cnt > 0 THEN 
   #end MOD-A60154 add
      #FUN-5B0113-begin
       LET g_rmj.rmjmodu = g_user
       LET g_rmj.rmjdate = g_today
       UPDATE rmj_file SET rmjmodu = g_rmj.rmjmodu,rmjdate = g_rmj.rmjdate
        WHERE rmj01 = g_rmj.rmj01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #    CALL cl_err('upd rmj',SQLCA.SQLCODE,1)
          CALL cl_err3("upd","rmj_file",g_rmj.rmj01,"",SQLCA.sqlcode,"","upd rmj",1) # FUN-660111
       END IF
       DISPLAY BY NAME g_rmj.rmjmodu,g_rmj.rmjdate
      #FUN-5B0113-end
    END IF   #MOD-A60154 add
 
    CLOSE t320_bcl
    LET g_success="Y"
    IF INT_FLAG THEN
       LET g_success = "N"
       IF p_cmd="a" THEN
          RETURN
       ELSE LET INT_FLAG=0 CALL cl_err('',9001,1)
            ROLLBACK WORK
            CALL t320_show()
            RETURN END IF
    END IF
   
    CALL t320_delHeader()     #CHI-C30002 add
    IF NOT cl_null(g_rmj.rmj01) THEN   #CHI-C30002 add
       LET g_t = s_get_doc_no(g_rmj.rmj01)     #No.FUN-550064
       SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t
       IF g_oay.oayconf = 'Y' THEN CALL t320_y() END IF
    END IF      #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t320_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rmj.rmj01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rmj_file ",
                  "  WHERE rmj01 LIKE '",l_slip,"%' ",
                  "    AND rmj01 > '",g_rmj.rmj01,"'"
      PREPARE t320_pb1 FROM l_sql 
      EXECUTE t320_pb1 INTO l_cnt       
      
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
        #CALL t320_v()  #CHI-D20010
         CALL t320_v(1) #CHI-D20010
         IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rmj_file WHERE rmj01 = g_rmj.rmj01
         INITIALIZE g_rmj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t320_get_rmc()
        SELECT rmc04,rmc05,rmc06,rmc061,rmc07,rmc14
           INTO g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,g_rmp[l_ac].rmp13,
                g_rmp[l_ac].rmp14,g_rmp[l_ac].rmp15,g_rmp10
           FROM rmc_file,rma_file
           WHERE rmc01=g_rmp[l_ac].rmp05 AND rmc02=g_rmp[l_ac].rmp06
                #rmc23 IS NULL AND rmc14 ='0'
             AND rmc23 IS NULL AND rmc14 IN ('4')  #CHI-690053 012->4
             AND rma01=rmc01   AND rmaconf='Y'  AND rmavoid='Y'
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rmp[l_ac].rmp11 = g_rmp_t.rmp11
           LET g_rmp[l_ac].rmp12 = g_rmp_t.rmp12
           LET g_rmp[l_ac].rmp13 = g_rmp_t.rmp13
           LET g_rmp[l_ac].rmp14 = g_rmp_t.rmp14
           LET g_rmp[l_ac].rmp15 = g_rmp_t.rmp15
           RETURN
        END IF
END FUNCTION
 
FUNCTION t320_rmp10()  #修復狀況
    DEFINE l_rmp10     LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30),
           g_answer    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
 
     SELECT rmp10 INTO g_rmp10 FROM rmp_file
      WHERE rmp00='3' AND rmp01=g_rmj.rmj01
        AND rmp02=g_rmp[l_ac].rmp02
     LET l_rmp10 = ' '
    #str MOD-A60154 mod
    #CASE g_lang
    #  WHEN '0'
    #    CASE
    #       WHEN g_rmp10='0' LET l_rmp10='未修復'
    #       WHEN g_rmp10='1' LET l_rmp10='修復  '
    #       WHEN g_rmp10='2' LET l_rmp10='不修  '
    #       OTHERWISE EXIT CASE
    #    END CASE
    #  WHEN '2'
    #    CASE
    #       WHEN g_rmp10='0' LET l_rmp10='未修復'
    #       WHEN g_rmp10='1' LET l_rmp10='修復  '
    #       WHEN g_rmp10='2' LET l_rmp10='不修  '
    #       OTHERWISE EXIT CASE
    #    END CASE
    #  OTHERWISE
    #    CASE
    #       WHEN g_rmp10='0' LET l_rmp10='Waiting Repair'
    #       WHEN g_rmp10='1' LET l_rmp10='Repaired'
    #       WHEN g_rmp10='2' LET l_rmp10='No Repaired'
    #       OTHERWISE EXIT CASE
    #    END CASE
    #END CASE
     CASE
        WHEN g_rmp10='0'
             CALL cl_getmsg('arm-507',g_lang) RETURNING l_rmp10  #未修復
        WHEN g_rmp10='1'
             CALL cl_getmsg('arm-508',g_lang) RETURNING l_rmp10  #修復
        WHEN g_rmp10='2'
             CALL cl_getmsg('arm-509',g_lang) RETURNING l_rmp10  #不修
        OTHERWISE EXIT CASE
     END CASE
    #end MOD-A60154 mod
     ERROR 'Ori-repaired status:',l_rmp10
END FUNCTION
 
FUNCTION t320_b_askkey()
   DEFINE l_wc2       LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON rmp02,rmp05,rmp06,rmp11,rmp12,rmp15,rmp13,rmp14
                    #No.FUN-840068 --start--
                     ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                     ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                     ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                    #No.FUN-840068 ---end---
        FROM s_rmp[1].rmp02, s_rmp[1].rmp05, s_rmp[1].rmp06,
             s_rmp[1].rmp11, s_rmp[1].rmp12, s_rmp[1].rmp15,
             s_rmp[1].rmp13, s_rmp[1].rmp14
           #No.FUN-840068 --start--
            ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
            ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
            ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
            ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
            ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
      #No.FUN-840068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds  #MOD-A60154 mod
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
   CALL t320_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t320_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1" END IF
    LET g_sql =" SELECT rmp02,rmp05,rmp06,rmp11,rmp13,rmp14,rmp12,rmp15, ",
            #No.FUN-840068 --start--
               "       rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
               "       rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
               "       rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
            #No.FUN-840068 ---end---
               " FROM rmj_file,rmp_file ",
               " WHERE rmj01=rmp01 AND rmp00='3' ",
               " AND rmp01= '",g_rmj.rmj01,"'"," AND ",p_wc2 CLIPPED,
               " ORDER BY rmp02 "
 
    PREPARE t320_pb FROM g_sql
    DECLARE rmp_curs                       #SCROLL CURSOR
        CURSOR FOR t320_pb
 
    CALL g_rmp.clear()
    LET g_cnt = 1
    FOREACH rmp_curs INTO g_rmp[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmp TO s_rmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t320_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
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
         #CKP
         #CALL cl_set_field_pic(g_rmj.rmjconf  ,"","","","",g_rmj.rmjvoid) #CHI-C80041
         IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid) #CHI-C80041
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
     #CHI-6B0070---add---str---
     #@ON ACTION 刪除
       ON ACTION delete
          LET g_action_choice="delete"
          EXIT DISPLAY
     #CHI-6B0070---add---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t320_y()         # when g_rmj.rmjconf='N' (Turn to 'Y')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ---------------- add ---------------- begin
   IF g_rmj.rmj01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmj.rmjvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmj.rmjconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
   IF g_rmp[1].rmp02 IS NULL THEN CALL cl_err('','arm-034',0) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  
#CHI-C30107 ---------------- add ---------------- end
   SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
   IF g_rmj.rmj01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmj.rmjvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmj.rmjconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
   IF g_rmp[1].rmp02 IS NULL THEN CALL cl_err('','arm-034',0) RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF  #CHI-C30107 mark
 
   BEGIN WORK
 
   OPEN t320_cl USING g_rmj.rmj01
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl:", STATUS, 1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t320_cl INTO g_rmj.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t320_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
   CALL t320_up_rmc('Y')
   IF g_success = 'Y' THEN
      LET g_rmj.rmjconf="Y"
      LET g_rmj.rmjmodu=g_user LET g_rmj.rmjdate=g_today
      UPDATE rmj_file SET rmjconf = 'Y',rmjmodu=g_user,rmjdate=g_today
       WHERE rmj01 = g_rmj.rmj01
      COMMIT WORK
      CALL cl_flow_notify(g_rmj.rmj01,'Y')
   ELSE
      LET g_rmj.rmjconf='N'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rmj.rmjconf,g_rmj.rmjmodu,g_rmj.rmjdate
   MESSAGE ''
    #CKP
    #CALL cl_set_field_pic(g_rmj.rmjconf  ,"","","","",g_rmj.rmjvoid) #CHI-C80041
    IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid) #CHI-C80041
END FUNCTION
 
FUNCTION t320_up_rmc(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_i   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   INITIALIZE l_rmp.* TO NULL
   DECLARE t320_pc CURSOR FOR
     SELECT * FROM rmp_file WHERE rmp00='3' AND rmp01=g_rmj.rmj01
 
   FOREACH t320_pc INTO l_rmp.*
       IF STATUS THEN
          CALL cl_err('FOREACH rmp:',STATUS,0)
          LET g_success='N' EXIT FOREACH
       END IF
       IF l_rmp.rmp02 IS NULL THEN EXIT FOREACH END IF
       IF p_cmd="Y" THEN     #當執行確認時
          UPDATE rmc_file SET rmc23=g_rmj.rmj01,rmc24=l_rmp.rmp02,
                              rmc21="3",rmc22=g_today,rmc14="4",rmc313=1
              WHERE rmc01 = l_rmp.rmp05 AND
                    rmc02 = l_rmp.rmp06
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
  #           CALL cl_err('up rmc! ',SQLCA.sqlcode,1) # FUN-660111
           CALL cl_err3("upd","rmc_file",l_rmp.rmp05,l_rmp.rmp06,SQLCA.sqlcode,"","up rmc!",1) # FUN-660111
             LET g_success="N"
             EXIT FOREACH
          END IF
          UPDATE rmp_file SET rmp09='4'
              WHERE rmp00 ='3' AND rmp01=g_rmj.rmj01
                AND rmp02 = l_rmp.rmp02
       ELSE                 # 當執行取消確認時
          UPDATE rmc_file SET rmc23=NULL,rmc24=NULL,rmc313=0,
                           rmc21="0",rmc22=NULL,rmc14=l_rmp.rmp10
                          #rmc21="0",rmc22=NULL,rmc14='0'
              WHERE rmc01 = l_rmp.rmp05 AND
                    rmc02 = l_rmp.rmp06
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#             CALL cl_err('up rmc! ',SQLCA.sqlcode,1) # FUN-660111
            CALL cl_err3("upd","rmc_file",l_rmp.rmp05,l_rmp.rmp06,SQLCA.sqlcode,"","up rmc!",1) # FUN-660111
             LET g_success="N"
             EXIT FOREACH
          END IF
          UPDATE rmp_file SET rmp09=NULL
              WHERE rmp00 ='3' AND rmp01=g_rmj.rmj01
                AND rmp02 = l_rmp.rmp02
       END IF
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err('up rmp! ',SQLCA.sqlcode,1)
          LET g_success="N"
          EXIT FOREACH
       END IF
   END FOREACH
END FUNCTION
 
FUNCTION t320_z()    # when g_rmj.rmjconf='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
   IF g_rmj.rmj01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rmj.rmjvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rmj.rmjconf  = 'N' THEN CALL cl_err('conf=N',9025,0) RETURN END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   LET g_rmj_t.* = g_rmj.*
   BEGIN WORK
 
 
    OPEN t320_cl USING g_rmj.rmj01
    IF STATUS THEN
       CALL cl_err("OPEN t320_cl:", STATUS, 1)
       CLOSE t320_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t320_cl INTO g_rmj.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t320_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t320_up_rmc('Z')
   IF g_success="N" THEN
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE rmj_file SET rmjconf  = 'N',rmjmodu=g_user,
                       rmjdate=g_today
          WHERE rmj01 = g_rmj.rmj01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err('upd rmjconf',STATUS,1) # FUN-660111
      CALL cl_err3("upd","rmj_file",g_rmj.rmj01,"",STATUS,"","upd rmjconf",1) # FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN LET g_rmj.rmjconf ='N'
           LET g_rmj.rmjmodu=g_user LET g_rmj.rmjdate=g_today
           COMMIT WORK
      ELSE LET g_rmj.rmjconf ='Y'
           ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rmj.rmjconf,g_rmj.rmjmodu,g_rmj.rmjdate
   MESSAGE ''
    #CKP
    #CALL cl_set_field_pic(g_rmj.rmjconf  ,"","","","",g_rmj.rmjvoid) #CHI-C80041
    IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid) #CHI-C80041
END FUNCTION
 
FUNCTION t320_x()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rmj.* FROM rmj_file WHERE rmj01 = g_rmj.rmj01
    IF g_rmj.rmj01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rmj.rmjvoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rmj.rmjconf = 'Y' THEN CALL cl_err('conf=Y',9023,0)  RETURN END IF
    IF cl_exp(0,0,g_rmj.rmjvoid) THEN
       LET g_rmj_t.* = g_rmj.*
 
       BEGIN WORK
 
       OPEN t320_cl USING g_rmj.rmj01
       IF STATUS THEN
          CALL cl_err("OPEN t320_cl:", STATUS, 1)
          CLOSE t320_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t320_cl INTO g_rmj.*          # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)     # 資料被他人LOCK
           CLOSE t320_cl ROLLBACK WORK RETURN
       END IF
 
       CALL t320_show()
       UPDATE rmj_file                    #更改有效碼
           SET rmjvoid="N",rmjmodu=g_user,rmjdate=g_today
           WHERE rmj01=g_rmj.rmj01
       IF SQLCA.SQLERRD[3]=0 THEN
 #         CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)
       CALL cl_err3("upd","rmj_file",g_rmj.rmj01,"",SQLCA.sqlcode,"","",1) # FUN-660111
       END IF
       LET g_rmj.rmjvoid='N' LET g_rmj.rmjmodu=g_user
       LET g_rmj.rmjdate=g_today
       DISPLAY BY NAME g_rmj.rmjvoid,g_rmj.rmjmodu,
                       g_rmj.rmjdate
 
       COMMIT WORK
 
    #CKP
    #CALL cl_set_field_pic(g_rmj.rmjconf  ,"","","","",g_rmj.rmjvoid)  #CHI-C80041
    IF g_rmj.rmjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_rmj.rmjconf,"","","",g_void,g_rmj.rmjvoid) #CHI-C80041
    CALL cl_flow_notify(g_rmj.rmj01,'V')
 
    END IF
END FUNCTION
 
FUNCTION t320_out()
DEFINE
    sr              RECORD
        rmj01       LIKE rmj_file.rmj01,   # 報廢單單號
        rmj02       LIKE rmj_file.rmj02,   # 單據日期
        rmp02       LIKE rmp_file.rmp02,   # 報廢單單號之項次
        rmp05       LIKE rmp_file.rmp05,   # RMA單號
        rmp06       LIKE rmp_file.rmp06,   # RET#
        rmp11       LIKE rmp_file.rmp11,   # 料件編號
        rmp12       LIKE rmp_file.rmp12,   # 單位
        rmp13       LIKE rmp_file.rmp13,   # 品名
        rmp14       LIKE rmp_file.rmp14,   # 規格
        rmp15       LIKE rmp_file.rmp15    # S/N
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
 
#-----NO.FUN-860018 BY TSD.jarlin--------------------------(S)                                                                      
    DEFINE l_sql   STRING                                                                                                           
        CALL cl_del_data(l_table)                                                                                                   
        SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                    
#-----NO.FUN-860018-----------------------------------------(E) 
 
    IF cl_null(g_wc) THEN
        LET g_wc=" rmj01='",g_rmj.rmj01,"'"
    END IF
    IF g_rmj.rmj01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    CALL cl_wait()
#    LET l_name = 'armt320.out'
#    CALL cl_outnam('armt320') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    IF g_wc2 IS NULL THEN LET g_wc2=" 1=1" END IF
    LET g_sql=" SELECT rmj01,rmj02,rmp02,rmp05,rmp06,rmp11,rmp12,",
              "        rmp13,rmp14,rmp15 ",
              " FROM rmj_file,rmp_file",
              " WHERE rmj01=rmp01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              " AND rmjconf <> 'X' ", #CHI-C80041
              " ORDER BY 1,3"
 
    PREPARE t320_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t320_co                         # SCROLL CURSOR
        CURSOR FOR t320_p1
 
#    START REPORT t320_rep TO l_name
 
    FOREACH t320_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #-----NO.FUN-860018 BY TSD.jarlin--------------(S)                                                                          
        EXECUTE insert_prep USING sr.rmj01,sr.rmj02,sr.rmp02,sr.rmp05,                                                              
                                  sr.rmp06,sr.rmp11,sr.rmp12,sr.rmp13,                                                              
                                  sr.rmp14,sr.rmp15                                                                                 
                                                                                                                                    
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('execute:',status,1)                                                                                         
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM                                                                                                             
        END IF                                                                                                                      
        #-----NO.FUN-860018----------------------------(E) 
#        OUTPUT TO REPORT t320_rep(sr.*)
    END FOREACH
#    FINISH REPORT t320_rep
        #-----NO.FUN-860018 BY TSD.jarlin---------------------(S)                                                                   
        LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,                                                                           
                     l_table CLIPPED,                                                                                               
                    " ORDER BY rmj01,rmp02"                                                                                         
        IF g_zz05 = 'Y' THEN                                                                                                        
           CALL cl_wcchp(g_wc,'rmj01,rmj02,rmjuser,rmjgrup,rmjmodu,rmjdate,rmjvoid')                                                
           RETURNING g_str                                                                                                          
        ELSE                                                                                                                        
           LET g_str = ''                                                                                                           
        END IF                                                                                                                      
        LET g_str = g_str                                                                                                           
        CALL cl_prt_cs3('armt320','armt320',l_sql,g_str)                                                                            
        #-----NO.FUN-860018-----------------------------------(E)  
    CLOSE t320_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---begin
#REPORT t320_rep(sr)
#DEFINE
#   l_last_sw       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#   sr              RECORD
#       rmj01       LIKE rmj_file.rmj01,   # 報廢單單號
#       rmj02       LIKE rmj_file.rmj02,   # 單據日期
#       rmp02       LIKE rmp_file.rmp02,   # 報廢單單號之項次
#       rmp05       LIKE rmp_file.rmp05,   # RMA單號
#       rmp06       LIKE rmp_file.rmp06,   # RET#
#       rmp11       LIKE rmp_file.rmp11,   # 料件編號
#       rmp12       LIKE rmp_file.rmp12,   # 單位
#       rmp13       LIKE rmp_file.rmp13,   # 品名
#       rmp14       LIKE rmp_file.rmp14,   # 規格
#       rmp15       LIKE rmp_file.rmp15    # S/N
#                   END RECORD
 
#  OUTPUT
#  TOP MARGIN g_top_margin
#  LEFT MARGIN g_left_margin
#  BOTTOM MARGIN g_bottom_margin
#  PAGE LENGTH g_page_line
 
#  ORDER BY sr.rmj01,sr.rmp02
 
#   FORMAT
#       PAGE HEADER
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#          LET g_pageno = g_pageno + 1
#          LET pageno_total = PAGENO USING '<<<',"/pageno"
#          PRINT g_x[9] CLIPPED,' ',sr.rmj01
#          PRINT g_x[10] CLIPPED,' ',sr.rmj02
 
#          PRINT g_head CLIPPED,pageno_total
#          PRINT g_dash
#          PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#          PRINTX name=H2 g_x[37],g_x[38],g_x[39]
#          PRINT g_dash1
#          LET l_last_sw = 'y'
 
#       BEFORE GROUP OF sr.rmj01
#          SKIP TO TOP OF PAGE
 
#       ON EVERY ROW
#          PRINTX name=D1 COLUMN g_c[31],sr.rmp02 USING '---&',
#                         COLUMN g_c[32],sr.rmp11,
#                         COLUMN g_c[33],sr.rmp12,
#                         COLUMN g_c[34],sr.rmp05,
#                         COLUMN g_c[35],sr.rmp06 USING '---&',
#                         COLUMN g_c[36],sr.rmp15
#          PRINTX name=D2 COLUMN g_c[37],' ',
#                         COLUMN g_c[38],sr.rmp13,
#                         COLUMN g_c[39],sr.rmp14
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7] CLIPPED
#           LET l_last_sw = 'n'
 
#       PAGE TRAILER
#           IF l_last_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED,COLUMN (g_len-10),g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-860018---end
#No.FUN-890102
#genero
#單頭
FUNCTION t320_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rmj01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t320_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' and g_chkey='N' THEN    #No.FUN-570109
           CALL cl_set_comp_entry("rmj01",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <> #
#CHI-C80041---begin
#FUNCTION t320_v()        #CHI-D20010
FUNCTION t320_v(p_type)   #CHI-D20010
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rmj.rmj01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_rmj.rmjconf ='X' THEN RETURN END IF
   ELSE
      IF g_rmj.rmjconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t320_cl USING g_rmj.rmj01
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl:", STATUS, 1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t320_cl INTO g_rmj.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rmj.rmj01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t320_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rmj.rmjconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_rmj.rmjconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_rmj.rmjconf)   THEN   #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN   #CHI-D20010
        LET l_chr=g_rmj.rmjconf
       #IF g_rmj.rmjconf='N' THEN    #CHI-D20010
        IF p_type = 1 THEN           #CHI-D20010
            LET g_rmj.rmjconf='X' 
        ELSE
            LET g_rmj.rmjconf='N'
        END IF
        UPDATE rmj_file
            SET rmjconf=g_rmj.rmjconf,  
                rmjmodu=g_user,
                rmjdate=g_today
            WHERE rmj01=g_rmj.rmj01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rmj_file",g_rmj.rmj01,"",SQLCA.sqlcode,"","",1)  
            LET g_rmj.rmjconf=l_chr 
        END IF
        DISPLAY BY NAME g_rmj.rmjconf
   END IF
 
   CLOSE t320_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rmj.rmj01,'V')
 
END FUNCTION
#CHI-C80041---end
