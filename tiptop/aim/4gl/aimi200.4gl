# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aimi200.4gl
# Descriptions...: 倉庫別資料維護作業
# Date & Author..: 91/10/09 By Nora
# Modify.........: 92/06/18 新增 銷售領料優先順序 (imd15 ) By Lin
#                           發料/領料優先順序值越小,優先順序越高(By Jeans 說的)
# Modify.........: 94/12/06 By Danny (將畫面改成多行式)
# Modify.........: By Melody  Insert 至 ime_file 且儲位=' '  97/06/21
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4C0032 04/12/13 By Mandy 將CALL i200_upd_ime_img()包在Transation之內
# Modify.........: No.MOD-510089 05/01/12 By ching imd12詢問
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By day    修正建檔程式key值是否可更改  
# Modify.........: No.TQC-620122 06/02/23 By Claire g_wc2 不可define string
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-670032 06/07/12 By kim GP3.5 利潤中心
# Modify.........: No.FUN-650128 06/07/24 By rainy 資料改成無效時，檢查是否有庫存量
# Modify.........: No.FUN-680048 06/08/15 By Joe (1)add action(APS相關資料)
#                                                (2)若與APS整合時,異動資料時,一併異動APS相關資料
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-690046 06/12/08 By pengu 修改可用與不可用倉庫更新時，應自動更新img，不再詢問
#                                                  並且提是必須執行aimp610重新計算ima_file。
# Modify.........: No.TQC-690047 06/12/08 By pengu 設定發料優先順序時，應一併更新img_file
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-720043 07/03/20 By Mandy APS 相關調整
# Modify.........: No.TQC-750013 07/05/04 By Mandy 一進入程式,不查詢直接按APS相關資料,的控管
# Modify.........: No.TQC-790077 07/09/18 By Carrier after field imd14/imd15 加入非負提示
# Modify.........: No.TQC-7A0082 07/10/22 By xufeng 當"可用"欄位選中的時候,"MRP可用"才可選中
# Modify.........: No.FUN-810099 07/12/25 By Cockroach 報表改成p_query 實現
# Modify.........: NO.FUN-7C0002 08/01/08 BY yiting apsi206->apsi305
# Modify.........: No.FUN-810099 08/04/10 By destiny p_query新增功能修改 
# Modify.........: No.FUN-870012 08/06/30 BY DUKE update vmf06 default=0
# Modify.........: No.FUN-870101 08/09/10 BY jamie MES整合
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.MOD-890182 08/11/24 By liuxqa 修改aim-125的錯誤信息，應將l_buff反饋至界面上
# Modify.........: No.MOD-910019 09/01/05 By chenyu 庫存為0的倉庫允許無效或刪除，但是要提示用戶確認
# Modify.........: No.FUN-910005 09/01/06 By duke 串接 apsi305時,新增 vmf_file.vmf07 = 0
# Modify.........: No.FUN-920053 09/02/10 By jan 將i200_upd_ime_img()包成一個 sub 的函數,新的 s_upd_ime_img.4gl
# Modify.........: No.MOD-920314 09/02/24 BY claire construct 加入imdacti
# Modify.........: No.FUN-930108 09/03/17 By zhaijie增加倉庫管理員權限條件(imd17)
# Modify.........: No.FUN-870100 09/07/30 By Cockroach 零售超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/18 By douzh 给ime17设定默认值,避免栏位为NULL情况出现
# Modify.........: No.TQC-9C0012 09/12/02 By lilingyu "參與自動補貨"欄位未賦予初值
# Modify.........: No.MOD-9C0257 09/12/21 By mike 通过价格条件管控未取到价格时单价栏位是否可以人工输入 
# Modify.........: No.TQC-9C0164 09/12/23 By Carrier azw04<>'2'时,没有给imd18赋值,导致insert失败
# Modify.........: No.FUN-A10012 10/01/05 By destiny流通零售for業態管控
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:TQC-A40105 10/04/21 By houlia TQC-7A0082修改還原
# Modify.........: No:FUN-AA0023 10/10/20 By lixia 增加默認倉庫字段
# Modify.........: No:FUN-AC0003 10/10/25 By Carrier imd20 字段不分业态都要显示&此字段需必录字段
# Modify.........: No:FUN-AC0040 10/12/15 By lixia 完工待測
# Modify.........: No:TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:MOD-B30163 11/01/11 By lixia 新增時，所屬營運中心Default為g_plant
# Modify.........: No:MOD-B30336 11/03/15 By baogc 新增歸屬營運中心為空時的報錯，且為空時不允許離開本行
# Modify.........: No:FUN-9A0056 11/03/31 By abby MES整合追版
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No.TQC-BC0080 11/12/12 By zhangll 單身插入異常修正
# Modify.........: No:MOD-BC0311 12/01/02 By ck2yuan 在倉庫刪除時,也應刪除ime_file
# Modify.........: No:MOD-C30100 12/03/09 By chenjing 單身修改和插入時錯誤信息修改
# Modify.........: No:FUN-C80107 12/09/17 By suncx 負庫存按照倉庫進行設定
# Modify.........: No.FUN-CB0052 12/11/15 By xianghui imd10欄位增加發票倉選項
# Modify.........: No.FUN-D10143 13/01/28 By suncx 修改imd23的處理邏輯，當為發票倉時，imd23不可維護，預設值為Y
# Modify.........: No.FUN-D30024 13/01/13 By lixh1 新增action 設置負庫存,點擊此ACTION允許進入單身修改
# Modify.........: No.TQC-D30044 13/01/18 By lixh1 aimi200倉庫性質為I:發票倉時imd23給值'Y'
# Modify.........: No.FUN-BC0062 13/03/19 By lixh1 當成本計算方式ccz28 ='6'时，不可使用設置負庫存ACTION
# Modify.........: No.FUN-D40103 13/05/07 By fengrui ime_file表添加imeacti字段

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_imd          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imd01       LIKE imd_file.imd01,   
        imd02       LIKE imd_file.imd02,  
        imd09       LIKE imd_file.imd09,  
        imd10       LIKE imd_file.imd10,  
        imd11       LIKE imd_file.imd11,  
        imd12       LIKE imd_file.imd12,  
        imd13       LIKE imd_file.imd13,  
        imd14       LIKE imd_file.imd14,  
        imd15       LIKE imd_file.imd15,  
        imd16       LIKE imd_file.imd16,   #FUN-670032
        gem02       LIKE gem_file.gem02,   #FUN-670032
        imd20       LIKE imd_file.imd20,   #No.FUN-870100
        imd20_desc  LIKE azp_file.azp02,   #No.FUN-870100
        imd18       LIKE imd_file.imd18,   #No.FUN-870100
        imd19       LIKE imd_file.imd19,   #No.FUN-870100
        imdpos      LIKE imd_file.imdpos,  #No.FUN-870100  
        imdacti     LIKE imd_file.imdacti, #FUN-660078    
        imd17       LIKE imd_file.imd17,   #FUN-930108--add 
        imd22       LIKE imd_file.imd22,   #FUN-AA0023--add#FUN-AC0040 
        imd23       LIKE imd_file.imd23    #FUN-C80107  
                    END RECORD,
    g_imd_t         RECORD                 #程式變數 (舊值)
        imd01       LIKE imd_file.imd01,   
        imd02       LIKE imd_file.imd02,  
        imd09       LIKE imd_file.imd09,  
        imd10       LIKE imd_file.imd10,  
        imd11       LIKE imd_file.imd11,  
        imd12       LIKE imd_file.imd12,  
        imd13       LIKE imd_file.imd13,  
        imd14       LIKE imd_file.imd14,  
        imd15       LIKE imd_file.imd15,
        imd16       LIKE imd_file.imd16,   #FUN-670032
        gem02       LIKE gem_file.gem02,   #FUN-670032
        imd20       LIKE imd_file.imd20,   #No.FUN-870100                                                                           
        imd20_desc  LIKE azp_file.azp02,   #No.FUN-870100                                                                           
        imd18       LIKE imd_file.imd18,   #No.FUN-870100                                                                           
        imd19       LIKE imd_file.imd19,   #No.FUN-870100                                                                           
        imdpos      LIKE imd_file.imdpos,  #No.FUN-870100     
        imdacti     LIKE imd_file.imdacti, #FUN-660078
        imd17       LIKE imd_file.imd17,   #FUN-930108--add  
        imd22       LIKE imd_file.imd22,   #FUN-AA0023--add
        imd23       LIKE imd_file.imd23    #FUN-C80107   
                    END RECORD,
    g_sql           string,  #No.FUN-580092 HCN
    g_wc2           STRING,  #TQC-630166 
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_account       LIKE type_file.num5    #會計維護 #FUN-670032  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql           STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr                  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                  LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                    LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done    LIKE type_file.num5    #No.FUN-570110     #No.FUN-690026 SMALLINT
DEFINE g_cmd                  LIKE type_file.chr1000 #FUN-680048 #No.FUN-690026 VARCHAR(70)
DEFINE g_flag                 LIKE type_file.chr1    #FUN-680048 #No.FUN-690026 VARCHAR(1)
#DEFINE g_sma894               STRING   #FUN-C80107 add     #FUN-D30024
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
   LET p_row = 3 LET p_col = 6
 
   OPEN WINDOW i200_w AT p_row,p_col WITH FORM "aim/42f/aimi200"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("imd16,gem02",g_aaz.aaz90='Y')
   CALL cl_set_act_visible("account",g_aaz.aaz90='Y')
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('imdpos',FALSE)
   END IF
   CALL cl_set_comp_visible('imdpos',FALSE)  #TQC-B30004 ADD
#FUN-D30024 ---------Begin--------
#  #FUN-C80107 add begin------------------------   
#  LET g_sma894 = g_sma.sma894
#  IF g_sma894.getIndexOf('Y',1) > 0 THEN
#     CALL cl_set_comp_visible('imd23',TRUE)
#  ELSE 
#     CALL cl_set_comp_visible('imd23',FALSE)
#  END IF
#  #FUN-C80107 add end -------------------------
#FUN-D30024 ---------End---------
   
   #No.FUN-AC0003  --Begin
   #CALL cl_set_comp_visible('imd18,imd19,imd20,imd20_desc',g_azw.azw04='2')  #No.FUN-A10012 
   CALL cl_set_comp_visible('imd18,imd19',g_azw.azw04='2') 
   #No.FUN-AC0003  --End  
  
   LET g_wc2 = '1=1' 
   CALL i200_b_fill(g_wc2)
   LET g_flag = 'N'        #FUN-680048
   CALL i200_menu()
   CLOSE WINDOW i200_w                    #結束畫面
   CALL  cl_used(g_prog,g_time,2)          #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION i200_menu()
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET g_account=FALSE #FUN-670032
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
      #FUN-D30024 ------Begin--------
         WHEN "set_negative_inventory"
            IF cl_chk_act_auth() THEN
               CALL i200_b1()
            END IF 
      #FUN-D30024 ------End----------
         WHEN "output"  
            IF cl_chk_act_auth() THEN
              CALL i200_out()
            END IF
         WHEN "account"
            IF cl_chk_act_auth() THEN
               CALL i200_acc()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
         WHEN "exporttoexcel"      #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imd),'','')
            END IF
         WHEN "aps_related_data"   #FUN-680048
            IF cl_chk_act_auth() THEN #FUN-720043 add
                CALL i200_aps()
            END IF
         WHEN "limitedright" 
            IF cl_chk_act_auth() THEN
               IF g_imd[l_ac].imd17='Y' THEN
                  CALL s_i200tr(g_imd[l_ac].imd01)
               ELSE
                  CALL cl_err('','aim-016',1)
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

#FUN-D30024 ----------Begin-----------
FUNCTION i200_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY  
   l_n             LIKE type_file.num5,    #檢查重複用   
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否   
   l_allow_insert  LIKE type_file.num5,    #可新增否     
   l_allow_delete  LIKE type_file.num5     #可刪除否    
 
   LET g_action_choice = ""
   LET g_chr = '1'       
   CALL cl_opmsg('b')                      
  #FUN-BC0062 ------Begin----------
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28 = '6' THEN
      CALL cl_err('','apm-941',1)
      RETURN
   END IF
  #FUN-BC0062 ------End------------

   LET g_forupd_sql = " SELECT imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd16,'',imd20,'',imd18,imd19,imdpos,imdacti,imd17,imd22,imd23",#FUN-AA0023 add imd22 #FUN-670032 #FUN-930108 add imd17 #FUN-870100   #FUN-C80107 add imd23 
                      "   FROM imd_file ",
                      "  WHERE imd01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_bcl_1 CURSOR FROM g_forupd_sql  
 
   LET l_ac_t = 0

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_imd WITHOUT DEFAULTS FROM s_imd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
   BEFORE INPUT
       CALL fgl_set_arr_curr(l_ac)
       CALL i200_b1_set_no_entry()
 
   BEFORE ROW
      LET l_ac = ARR_CURR()
      LET l_lock_sw = 'N'             
      LET l_n  = ARR_COUNT()
      IF g_rec_b>=l_ac THEN
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE                                                                                       

         LET g_success = 'Y'             
         BEGIN WORK
         LET g_imd_t.* = g_imd[l_ac].*   
 
         OPEN i200_bcl_1 USING g_imd_t.imd01
         IF STATUS THEN
            CALL cl_err("OPEN i200_bcl_1:", STATUS, 1)
            LET l_lock_sw = 'Y' 
         ELSE  
            FETCH i200_bcl_1 INTO g_imd[l_ac].* 
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_imd_t.imd01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL i200_imd20('d')    
            LET g_imd[l_ac].gem02=s_costcenter_desc(g_imd[l_ac].imd16)  
            END IF
            CALL cl_show_fld_cont()      
         END IF

         AFTER FIELD imd23
            IF g_imd[l_ac].imd23 NOT MATCHES '[YN]' THEN
                NEXT FIELD imd23
            END IF
         #TQC-D30044 -------Begin---------
            IF g_imd[l_ac].imd10 MATCHES '[Ii]' THEN
               LET g_imd[l_ac].imd23 = 'Y'
            END IF
         #TQC-D30044 -------End-----------
 
        ON ROW CHANGE
           IF INT_FLAG THEN                  
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_imd[l_ac].* = g_imd_t.*
              CLOSE i200_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF g_aza.aza88 ='Y' THEN    
              IF g_imd[l_ac].imd01<>g_imd_t.imd01 OR g_imd[l_ac].imd02<>g_imd_t.imd02 OR g_imd[l_ac].imd09<>g_imd_t.imd09 OR g_imd[l_ac].imd10<>g_imd_t.imd10
                 OR g_imd[l_ac].imd11<>g_imd_t.imd11 OR g_imd[l_ac].imd12<>g_imd_t.imd12 OR g_imd[l_ac].imd13<>g_imd_t.imd13 OR g_imd[l_ac].imd14<>g_imd_t.imd14
                 OR g_imd[l_ac].imd15<>g_imd_t.imd15 OR g_imd[l_ac].imd20<>g_imd_t.imd20 OR g_imd[l_ac].imd18<>g_imd_t.imd18 OR g_imd[l_ac].imd19<>g_imd_t.imd19
                 OR g_imd[l_ac].imdacti<>g_imd_t.imdacti OR g_imd[l_ac].imd17<>g_imd_t.imd17 OR g_imd[l_ac].imd22<>g_imd_t.imd22 THEN #add imd22 FUN-AA0023
              END IF
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_imd[l_ac].imd01,-263,1)
              LET g_imd[l_ac].* = g_imd_t.*
           ELSE
              UPDATE imd_file 
                 SET imd01   = g_imd[l_ac].imd01,
                     imd02   = g_imd[l_ac].imd02,
                     imd09   = g_imd[l_ac].imd09,
                     imd10   = g_imd[l_ac].imd10,
                     imd11   = g_imd[l_ac].imd11,
                     imd12   = g_imd[l_ac].imd12,
                     imd13   = g_imd[l_ac].imd13,
                     imd14   = g_imd[l_ac].imd14,
                     imd15   = g_imd[l_ac].imd15,
                     imd16   = g_imd[l_ac].imd16,                       
                     imd18   = g_imd[l_ac].imd18,  
                     imd19   = g_imd[l_ac].imd19,  
                     imd20   = g_imd[l_ac].imd20,                                            
                     imdacti = g_imd[l_ac].imdacti,
                     imd17   = g_imd[l_ac].imd17,  
                     imd22   = g_imd[l_ac].imd22,  
                     imd23   = g_imd[l_ac].imd23,  
                     imdmodu = g_user,
                     imddate = g_today
               WHERE imd01= g_imd_t.imd01
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","imd_file",g_imd_t.imd01,"",
                                SQLCA.sqlcode,"","",1)   
                  LET g_imd[l_ac].* = g_imd_t.*
                  ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
              #  CALL s_upd_ime_img(g_imd_t.imd01,g_imd[l_ac].imd01,g_imd[l_ac].imd10,g_imd_t.imd10,
              #                     g_imd[l_ac].imd14,g_imd_t.imd14,g_imd[l_ac].imd15,g_imd_t.imd15,
              #                     g_imd[l_ac].imd11,g_imd_t.imd11,g_imd[l_ac].imd12,g_imd_t.imd12,
              #                     g_imd[l_ac].imd13,g_imd_t.imd13) RETURNING g_success
              #  IF g_success = 'Y' THEN
              #  #   IF l_recal_ima1 = 'Y' THEN
              #  #      CALL cl_err('','aim-143',1)
              #  #   ELSE
              #  #      IF l_recal_ima2 = 'Y' THEN
              #  #         CALL cl_err('','aim-144',1)
              #  #      END IF
              #  #   END IF
              #  ELSE
              #  #   LET g_imd[l_ac].* = g_imd_t.*
              #  #   ROLLBACK WORK
              #  #   NEXT FIELD imd01
              #  END IF
              #  IF g_aza.aza90 MATCHES "[Yy]" THEN
              #     CASE
              #        WHEN (g_imd_t.imdacti='Y' AND g_imd[l_ac].imdacti='N')  #有效變無效
              #             CALL i200_mes('delete',g_imd[l_ac].imd01)
              #        WHEN (g_imd_t.imdacti='N' AND g_imd[l_ac].imdacti='Y')  #無效變有效
              #             CALL i200_mes('insert',g_imd[l_ac].imd01)
              #        WHEN (g_imd_t.imdacti='Y' AND g_imd[l_ac].imdacti='Y')  #有效資料異動內容
              #             CALL i200_mes('update',g_imd[l_ac].imd01)
              #     END CASE
              #  END IF

              #  IF g_success = 'N' THEN
              #     ROLLBACK WORK
              #     RETURN
              #  ELSE
              #     COMMIT WORK
              #  END IF
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imd[l_ac].* = g_imd_t.*
               CLOSE i200_bcl_1  
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_imd_t.* = g_imd[l_ac].*
            CLOSE i200_bcl_1  
            COMMIT WORK         
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION HELP           
         CALL cl_show_help()   
   END INPUT
END FUNCTION
#FUN-D30024 ----------End-------------
 
FUNCTION i200_q()
   CALL i200_b_askkey()
END FUNCTION
 
FUNCTION i200_imd20(p_cmd)         
DEFINE    l_imd20_desc  LIKE azp_file.azp02,  
          p_cmd      LIKE type_file.chr1
 
  SELECT azp02 INTO l_imd20_desc from azp_file where azp01 = g_imd[l_ac].imd20  
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_imd[l_ac].imd20_desc = l_imd20_desc
     DISPLAY BY NAME g_imd[l_ac].imd20_desc
  END IF
 
END FUNCTION
 
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_possible      LIKE type_file.num5,    #用來設定判斷重複的可能性  #No.FUN-690026 SMALLINT
    l_dir1          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_recal_ima1    LIKE type_file.chr1,    #No.TQC-690046 add
    l_recal_ima2    LIKE type_file.chr1,    #No.TQC-690046 add
    l_buf           LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(80)
    l_allow_insert  LIKE type_file.chr1,    #可新增否  #No.FUN-690026 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1,    #可刪除否  #No.FUN-690026 VARCHAR(1)
    l_cnt           LIKE type_file.num10,   #FUN-670032  #No.FUN-690026 INTEGER
    l_imd           RECORD LIKE imd_file.*, #FUN-670035 add
    l_change        LIKE type_file.chr1     #FUN-670035 add  #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET g_forupd_sql = " SELECT imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd16,'',imd20,'',imd18,imd19,imdpos,imdacti,imd17,imd22,imd23",#FUN-AA0023 add imd22 #FUN-670032 #FUN-930108 add imd17 #FUN-870100   #FUN-C80107 add imd23 
                       "   FROM imd_file ",
                       "  WHERE imd01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_imd WITHOUT DEFAULTS FROM s_imd.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              CALL i200_set_entry_b() #FUN-670032
              LET p_cmd = 'u'
              LET g_before_input_done = FALSE
              CALL i200_b1_set_entry()      #FUN-D30024
              CALL i200_set_entry(p_cmd)                                                                                           
              CALL i200_set_no_entry(p_cmd)                                                                                        
              LET g_before_input_done = TRUE                                                                                       

              LET g_success = 'Y'             #FUN-9A0056 add 
              BEGIN WORK
              LET p_cmd='u'
              LET g_imd_t.* = g_imd[l_ac].*  #BACKUP
 
              OPEN i200_bcl USING g_imd_t.imd01
              IF STATUS THEN
                 CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                 LET l_lock_sw = 'Y' 
              ELSE  
                 FETCH i200_bcl INTO g_imd[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_imd_t.imd01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i200_imd20('d')   #FUN-870100 ADD by cockroach
                 LET g_imd[l_ac].gem02=s_costcenter_desc(g_imd[l_ac].imd16) #FUN-670063
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                                                                      
           CALL i200_set_entry(p_cmd)                                                                                           
           CALL i200_set_no_entry(p_cmd)                                                                                        
           LET g_before_input_done = TRUE                                                                                       
           INITIALIZE g_imd[l_ac].* TO NULL    
           LET g_imd[l_ac].imd11='Y'             #BugNo:6825
           LET g_imd[l_ac].imd12='Y'             #BugNo:6825
           LET g_imd[l_ac].imd13='N'             #BugNo:6825
           LET g_imd[l_ac].imdacti='Y'
           LET g_imd[l_ac].imd17='N'             #FUN-930108 add imd17
           LET g_imd[l_ac].imd22='N'             #FUN-AA0023 add imd22
           LET g_imd[l_ac].imd23='N'             #FUN-C80107 add 
           LET g_imd[l_ac].imd18='0'             #No.TQC-9C0164
           LET g_imd[l_ac].imd19='N'             #TQC-9C0012
           LET g_imd[l_ac].imd14=0
           LET g_imd[l_ac].imd15=0
           #LET g_imd[l_ac].imdpos='N'            #FUN-870100 #FUN-B50042 mark
           LET g_imd[l_ac].imd20 = g_plant       #MOD-B30163
           #DISPLAY BY NAME g_imd[l_ac].imdpos    #FUN-870100 #FUN-B50042 mark
           DISPLAY BY NAME g_imd[l_ac].imd19     #TQC-9C0012
           LET g_imd_t.* = g_imd[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD imd01
 
        AFTER FIELD imd01                        #check 編號是否重複
           IF g_imd[l_ac].imd01 != g_imd_t.imd01 OR
              (g_imd[l_ac].imd01 IS NOT NULL AND g_imd_t.imd01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM imd_file
                   WHERE imd01 = g_imd[l_ac].imd01
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_imd[l_ac].imd01 = g_imd_t.imd01
                   NEXT FIELD imd01
               END IF
           END IF
 
 
        AFTER FIELD imd10  #不可空白
           IF g_imd[l_ac].imd10 IS NULL OR g_imd[l_ac].imd10 = ' ' OR
              g_imd[l_ac].imd10 NOT MATCHES '[SsWwIi]' THEN          #FUN-CB0052 add Ii
              NEXT FIELD imd10
#FUN-AA0023---add---str--
           ELSE
              IF g_imd[l_ac].imd10 != g_imd_t.imd10 THEN
              #FUN-D30024 ------Begin---------
                 IF g_imd[l_ac].imd10 MATCHES '[Ii]' THEN
                    LET g_imd[l_ac].imd23 = 'Y' 
                 END IF
              #FUN-D30024 ------End----------- 
                 CALL i200_imd22()
                 IF NOT cl_null(g_errno) THEN   
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD imd10
                 END IF
              END IF 
#FUN-AA0023---add---end--
           END IF
        #FUN-CB0052---add---str---
        ON CHANGE imd10
           IF NOT cl_null(g_imd[l_ac].imd10) THEN 
              IF g_imd[l_ac].imd10 MATCHES '[Ii]' THEN 
                 LET g_imd[l_ac].imd11 = 'N'
                 LET g_imd[l_ac].imd12 = 'N'
                 LET g_imd[l_ac].imd23 = 'Y'                       #FUN-D10143 add
                 CALL cl_set_comp_entry("imd11,imd12,imd23",FALSE) #FUN-D10143 add imd23
              ELSE
                 #FUN-D10143 add begin----------------
                 IF cl_null(g_imd_t.imd23) OR g_imd_t.imd10 MATCHES '[Ii]' THEN 
                    LET g_imd[l_ac].imd23 = 'N'
                 ELSE
                    LET g_imd[l_ac].imd23 = g_imd_t.imd23
                 END IF 
                 #FUN-D10143 add end------------------
              #  CALL cl_set_comp_entry("imd11,imd12,imd23",TRUE)  #FUN-D10143 add imd23  #FUN-D30024 mark imd23  
                 CALL cl_set_comp_entry("imd11,imd12",TRUE)        #FUN-D30024 mark imd23 
              END IF
           END IF
        #FUN-CB0052---add---end--
 
        BEFORE FIELD imd11
           LET g_imd_t.imd11 = g_imd[l_ac].imd11
 
        AFTER FIELD imd11  #不可空白
           IF g_imd[l_ac].imd11 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD imd11
           END IF
           LET l_recal_ima1 = 'N'    #No.TQC-690046 add
           IF p_cmd = 'u' AND 
               (g_imd_t.imd11 != g_imd[l_ac].imd11) THEN
               LET l_recal_ima1 = 'Y'
           END IF
           IF g_imd_t.imd11 = 'N' AND g_imd[l_ac].imd11 = 'Y' AND 
              p_cmd = 'u' THEN
           END IF
           LET l_dir1 = 'U'

#TQC-A40105------begin------
#       ON CHANGE imd11
#          IF g_imd[l_ac].imd11 = 'N' THEN
#            CALL cl_set_comp_entry("imd12",FALSE) 
#            LET g_imd[l_ac].imd12 = 'N'
#          ELSE
#            CALL cl_set_comp_entry("imd12",TRUE) 
#          END IF
           
#       BEFORE FIELD imd12 
#          IF g_imd[l_ac].imd11 = 'N' THEN
#            CALL cl_set_comp_entry("imd12",FALSE) 
#          END IF
#TQC-A40105------end------
#FUN-AA0023------begin------
        ON CHANGE imd22
           IF g_imd_t.imd22!='Y' THEN 
              CALL i200_imd22()
              IF NOT cl_null(g_errno) THEN             
                 CALL cl_err('',g_errno,0)
                 LET g_imd[l_ac].imd22 = g_imd_t.imd22
                 NEXT FIELD imd22
              END IF
           END IF
#FUN-AA0023------end------
 
        AFTER FIELD imd12  #不可空白
           IF g_imd[l_ac].imd12 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD imd12
           END IF
           LET l_recal_ima2 = 'N'    #No.TQC-690046 add
           IF p_cmd = 'u' AND 
               (g_imd_t.imd12 != g_imd[l_ac].imd12) THEN
               LET l_recal_ima2 = 'Y'   
           END IF
 
        AFTER FIELD imd13  #不可空白
           IF g_imd[l_ac].imd13 NOT MATCHES '[YyNn]' THEN
              NEXT FIELD imd13
           END IF
           LET l_dir1 = 'D'
 
        AFTER FIELD imd14
           IF g_imd[l_ac].imd14 <0 THEN
              CALL cl_err(g_imd[l_ac].imd14,'aim-223',0)
              LET g_imd[l_ac].imd14 = g_imd_t.imd14
              NEXT FIELD imd14
           END IF
 
        AFTER FIELD imd15
           IF g_imd[l_ac].imd15 <0 THEN
              CALL cl_err(g_imd[l_ac].imd15,'aim-223',0)
              LET g_imd[l_ac].imd15 = g_imd_t.imd15
              NEXT FIELD imd15
           END IF
 
        AFTER FIELD imd16
           IF g_account THEN
              IF NOT cl_null(g_imd[l_ac].imd16) THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM gem_file 
                                           WHERE gem01=g_imd[l_ac].imd16
                                             AND gem09 IN ('1','2')
                                             AND gemacti='Y'
                 IF l_cnt=0 THEN
                    CALL cl_err('',100,1)
                    LET g_imd[l_ac].imd16=g_imd_t.imd16
                    LET g_imd[l_ac].gem02=g_imd_t.gem02
                    DISPLAY BY NAME g_imd[l_ac].imd16,g_imd[l_ac].gem02
                    NEXT FIELD imd16
                 END IF
                 CALL i200_get_gem02(g_imd[l_ac].imd16)
                    RETURNING g_imd[l_ac].gem02
              ELSE
                 LET g_imd[l_ac].gem02=NULL
                 DISPLAY BY NAME g_imd[l_ac].gem02
              END IF
           END IF
 
        AFTER FIELD imd20
           IF NOT cl_null(g_imd[l_ac].imd20) THEN
              #No.FUN-AC0003  --Begin
              IF p_cmd = 'u' AND g_imd[l_ac].imd20 <> g_imd_t.imd20 OR cl_null(g_imd_t.imd20) THEN
                 SELECT COUNT(*) INTO l_cnt FROM img_file 
                  WHERE img02 = g_imd[l_ac].imd01
                    AND imgplant <> g_imd[l_ac].imd20
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_imd[l_ac].imd20,'aim-030',1)
                    LET g_imd[l_ac].imd20=g_imd_t.imd20
                    NEXT FIELD imd20
                 END IF 
#FUN-AA0023---add---str--
                 CALL i200_imd22()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD imd20
                 END IF 
#FUN-AA0023---add---end--
              END IF
              #No.FUN-AC0003  --End  

              SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01 = g_imd[l_ac].imd20 
              IF l_n>0 THEN
                    CALL i200_imd20('a')
              ELSE
                 CALL cl_err('','aim1009',0)
                 LET g_imd[l_ac].imd20=g_imd_t.imd20
                 DISPLAY BY NAME g_imd[l_ac].imd20
                 NEXT FIELD imd20
              END IF
    ###-MOD-B30336 - ADD - BEGIN --------------------------
           ELSE
              CALL cl_err('','aim-028',1)
              NEXT FIELD imd20
    ###-MOD-B30336 - ADD -  END  --------------------------
           END IF

    #FUN-D30024 ---------Begin----------
    #  #FUN-C80107 add ---begin---------------------
    #   AFTER FIELD imd23
    #      IF g_imd[l_ac].imd23 NOT MATCHES '[YN]' THEN
    #          NEXT FIELD imd23
    #      END IF
    #  #FUN-C80107 add ---end-----------------------
    #FUN-D30024 ---------End------------
        
        AFTER FIELD imdacti
           IF g_imd[l_ac].imdacti NOT MATCHES '[YN]' THEN
               NEXT FIELD imdacti
           END IF
           IF g_imd[l_ac].imdacti = 'N' THEN
              CALL i200_check() RETURNING l_buf
              IF g_chr = 'E' THEN  #不可改為無效
                 CALL cl_err(l_buf,'aim-125',0) #No.MOD-890182 add by liuxqa
                 LET g_imd[l_ac].imdacti=g_imd_t.imdacti
                 DISPLAY BY NAME g_imd[l_ac].imdacti
                 NEXT FIELD imdacti
              END IF
              IF g_chr = 'F' THEN  #庫存為0，要確認是否設為無效
                 IF NOT cl_confirm('aim-147') THEN
                    LET g_imd[l_ac].imdacti=g_imd_t.imdacti
                    DISPLAY BY NAME g_imd[l_ac].imdacti
                    NEXT FIELD imdacti
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_imd_t.imd01 IS NOT NULL THEN
              #TQC-B30004 mark begin----------------
              #IF g_aza.aza88='Y' THEN
              #   IF NOT (g_imd[l_ac].imdacti='N' AND g_imd[l_ac].imdpos='Y') THEN
              #      CALL cl_err("", 'art-648', 1)   #FUN-A30030 aim-944-->art-648
              #      CANCEL DELETE
              #   END IF
              #END IF
              #TQC-B30004 mark end------------------
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
             #檢查此筆資料之下游檔案imf_file,img_file是否尚在使用中
              LET l_buf=''
              CALL i200_check() RETURNING l_buf
              IF g_chr = 'E' THEN  #表示無法刪除此筆資料
                 ERROR l_buf
                 CANCEL DELETE
              END IF
              IF g_chr = 'F' THEN  #庫存為0，要確認是否刪除
                 IF NOT cl_confirm('aim-147') THEN
                    CANCEL DELETE
                 END IF
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM imd_file 
               WHERE imd01 = g_imd_t.imd01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","imd_file",g_imd_t.imd01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 ROLLBACK WORK
                 CANCEL DELETE

                #FUN-9A0056 mark str---------- 
                # IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
                #     ELSE 
                #       # CALL aws_mescli()
                #       # 傳入參數: (1)程式代號
                #       #           (2)功能選項：insert(新增),update(修改),delete(刪除)
                #       #           (3)Key
                #       CASE aws_mescli('aimi200','delete',g_imd_t.imd01)
                #          WHEN 0  #無與 MES 整合
                #               MESSAGE 'DELETE O.K'
                #          WHEN 1  #呼叫 MES 成功
                #               MESSAGE 'DELETE O.K, DELETE MES O.K'
                #          WHEN 2  #呼叫 MES 失敗
                #               RETURN FALSE
                #       END CASE
                # END IF  #TQC-8B0011  ADD
                #FUN-9A0056 mark end ---------
              END IF

              #-------MOD-BC0311 str add-------
              DELETE FROM ime_file
               WHERE ime01 = g_imd_t.imd01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ime_file",g_imd_t.imd01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              #-------MOD-BC0311 end add-------

             
              IF g_sma.sma901 = 'Y' THEN 
                 DELETE FROM vmf_file 
                  WHERE vmf01 = g_imd_t.imd01
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","vmf_file",g_imd_t.imd01,"",
                                  SQLCA.sqlcode,"","",1)  
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
 
             #FUN-9A0056 add str ------
             #若刪除的資料為有效資料,則傳送MES
              IF g_aza.aza90 MATCHES "[Yy]" AND g_imd_t.imdacti = 'Y' THEN
                CALL i200_mes('delete',g_imd_t.imd01)
              END IF

              IF g_success = 'N' THEN
                ROLLBACK WORK
                CANCEL DELETE
              ELSE
                COMMIT WORK
              END IF
             #FUN-9A0056 add end ------

              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
             #COMMIT WORK                         #FUN-9A0056 mark
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_imd[l_ac].* = g_imd_t.*
              CLOSE i200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF g_aza.aza88 ='Y' THEN   #FUN-A30030 ADD
              IF g_imd[l_ac].imd01<>g_imd_t.imd01 OR g_imd[l_ac].imd02<>g_imd_t.imd02 OR g_imd[l_ac].imd09<>g_imd_t.imd09 OR g_imd[l_ac].imd10<>g_imd_t.imd10
                 OR g_imd[l_ac].imd11<>g_imd_t.imd11 OR g_imd[l_ac].imd12<>g_imd_t.imd12 OR g_imd[l_ac].imd13<>g_imd_t.imd13 OR g_imd[l_ac].imd14<>g_imd_t.imd14
                 OR g_imd[l_ac].imd15<>g_imd_t.imd15 OR g_imd[l_ac].imd20<>g_imd_t.imd20 OR g_imd[l_ac].imd18<>g_imd_t.imd18 OR g_imd[l_ac].imd19<>g_imd_t.imd19
                 OR g_imd[l_ac].imdacti<>g_imd_t.imdacti OR g_imd[l_ac].imd17<>g_imd_t.imd17 OR g_imd[l_ac].imd22<>g_imd_t.imd22 THEN #add imd22 FUN-AA0023
                 #LET g_imd[l_ac].imdpos = 'N'       #FUN-B50042 mark
                 #DISPLAY BY NAME g_imd[l_ac].imdpos #FUN-B50042 mark
              END IF
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_imd[l_ac].imd01,-263,1)
              LET g_imd[l_ac].* = g_imd_t.*
           ELSE
              UPDATE imd_file 
                   SET imd01   = g_imd[l_ac].imd01,
                       imd02   = g_imd[l_ac].imd02,
                       imd09   = g_imd[l_ac].imd09,
                       imd10   = g_imd[l_ac].imd10,
                       imd11   = g_imd[l_ac].imd11,
                       imd12   = g_imd[l_ac].imd12,
                       imd13   = g_imd[l_ac].imd13,
                       imd14   = g_imd[l_ac].imd14,
                       imd15   = g_imd[l_ac].imd15,
                       imd16   = g_imd[l_ac].imd16, #FUN-670032                        
                       imd18   = g_imd[l_ac].imd18, #No.FUN-870100
                       imd19   = g_imd[l_ac].imd19, #No.FUN-870100
                       imd20   = g_imd[l_ac].imd20, #No.FUN-870100                       
                       #imdpos  = g_imd[l_ac].imdpos,#No.FUN-870100 #FUN-B50042 mark
                       imdacti = g_imd[l_ac].imdacti,
                       imd17   = g_imd[l_ac].imd17, #FUN-930108
                       imd22   = g_imd[l_ac].imd22, #FUN-AA0023
                       imd23   = g_imd[l_ac].imd23, #FUN-C80107 
                       imdmodu = g_user,
                       imddate = g_today
               WHERE imd01= g_imd_t.imd01
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","imd_file",g_imd_t.imd01,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660156
                  LET g_imd[l_ac].* = g_imd_t.*
                  ROLLBACK WORK
              ELSE
                  MESSAGE 'UPDATE O.K'
                 CALL s_upd_ime_img(g_imd_t.imd01,g_imd[l_ac].imd01,g_imd[l_ac].imd10,g_imd_t.imd10,
                                    g_imd[l_ac].imd14,g_imd_t.imd14,g_imd[l_ac].imd15,g_imd_t.imd15,
                                    g_imd[l_ac].imd11,g_imd_t.imd11,g_imd[l_ac].imd12,g_imd_t.imd12,
                                    g_imd[l_ac].imd13,g_imd_t.imd13) RETURNING g_success
                  IF g_success = 'Y' THEN
                      IF l_recal_ima1 = 'Y' THEN
                         CALL cl_err('','aim-143',1)
                      ELSE
                         IF l_recal_ima2 = 'Y' THEN
                            CALL cl_err('','aim-144',1)
                         END IF
                      END IF
                      #COMMIT WORK                    #FUN-9A0056 mark
                  ELSE
                      LET g_imd[l_ac].* = g_imd_t.*
                      ROLLBACK WORK
                      NEXT FIELD imd01
                  END IF

                #FUN-9A0056 mark str ----------- 
                # IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
                #    # CALL aws_mescli()
                #    # 傳入參數: (1)程式代號
                #    #           (2)功能選項：insert(新增),update(修改),delete(刪除)
                #    #           (3)Key
                #    CASE aws_mescli('aimi200','update',g_imd[l_ac].imd01)
                #       WHEN 0  #無與 MES 整合
                #            MESSAGE 'UPDATE O.K'
                #       WHEN 1  #呼叫 MES 成功
                #            MESSAGE 'UPDATE O.K, UPDATE MES O.K'
                #       WHEN 2  #呼叫 MES 失敗
                #            RETURN FALSE
                #    END CASE
                # END IF  #TQC-8B0011 ADD
                #FUN-9A0056 mark end -----------

                #FUN-9A0056 add str ------
                 IF g_aza.aza90 MATCHES "[Yy]" THEN
                    CASE
                       WHEN (g_imd_t.imdacti='Y' AND g_imd[l_ac].imdacti='N')  #有效變無效
                            CALL i200_mes('delete',g_imd[l_ac].imd01)
                       WHEN (g_imd_t.imdacti='N' AND g_imd[l_ac].imdacti='Y')  #無效變有效
                            CALL i200_mes('insert',g_imd[l_ac].imd01)
                       WHEN (g_imd_t.imdacti='Y' AND g_imd[l_ac].imdacti='Y')  #有效資料異動內容
                            CALL i200_mes('update',g_imd[l_ac].imd01)
                    END CASE
                 END IF

                 IF g_success = 'N' THEN
                    ROLLBACK WORK
                    RETURN
                 ELSE
                    COMMIT WORK
                 END IF
                #FUN-9A0056 add end ------
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#TQC-BC0080 mark
#    ###-MOD-B30336 - ADD - BEGIN ------------------------------------
#          IF cl_null(g_imd[l_ac].imd20) AND p_cmd = 'u' THEN
#             CALL cl_err('','aim-028',1)
#             NEXT FIELD imd20
#          END IF
#    ###-MOD-B30336 - ADD -  END  ------------------------------------
#TQC-BC0080 mark--end
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_imd[l_ac].* = g_imd_t.*
              END IF
              CLOSE i200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE i200_bcl
           COMMIT WORK
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i200_bcl
              CANCEL INSERT
           END IF
       
           INSERT INTO imd_file(imd01,imd02,imd09,imd10,imd11,imd12,imd13,
                                imd14,imd15,imd16,imd20,imd18,imd19,imdacti,imd17,imd22,imd23,imduser,imddate,imdoriu,imdorig) #FUN-670032 #FUN-930108 add imd17 #FUN-870100#FUN-AA0023 add imd22 #FUN-C80107 add imd23 
             VALUES(g_imd[l_ac].imd01,g_imd[l_ac].imd02,g_imd[l_ac].imd09,
                    g_imd[l_ac].imd10,g_imd[l_ac].imd11,g_imd[l_ac].imd12,
                    g_imd[l_ac].imd13,g_imd[l_ac].imd14,g_imd[l_ac].imd15,
                    g_imd[l_ac].imd16,g_imd[l_ac].imd20,g_imd[l_ac].imd18,g_imd[l_ac].imd19,   #FUN-670032 #FUN-870100 #FUN-B50042 remove POS 
                    g_imd[l_ac].imdacti,g_imd[l_ac].imd17,g_imd[l_ac].imd22,g_imd[l_ac].imd23,g_user,g_today, g_user, g_grup)   #FUN-930108 add imd17      #No.FUN-980030 10/01/04  insert columns oriu, orig#FUN-AA0023 add imd22 #FUN-C80107 add imd23 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","imd_file",g_imd[l_ac].imd01,g_imd[l_ac].imd02,
                            SQLCA.sqlcode,"","",1)  #No.FUN-660156
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              CALL i200_ins()
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2  
 
             #FUN-9A0056 mark str ---------- 
             # IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
             #    # CALL aws_mescli()
             #    # 傳入參數: (1)程式代號
             #    #           (2)功能選項：insert(新增),update(修改),delete(刪除)
             #    #           (3)Key
             #    CASE aws_mescli('aimi200','insert',g_imd[l_ac].imd01)
             #      WHEN 0  #無與 MES 整合
             #           MESSAGE 'INSERT O.K'
             #      WHEN 1  #呼叫 MES 成功
             #           MESSAGE 'INSERT O.K, INSERT MES O.K'
             #      WHEN 2  #呼叫 MES 失敗
             #           RETURN FALSE
             #    END CASE
             # END IF #TQC-8B0011 ADD
             #FUN-9A0056 mark end -------------

             #FUN-9A0056 add begin -------
             #有效資料才傳送MES
              IF g_aza.aza90 MATCHES "[Yy]" AND g_imd[l_ac].imdacti='Y' THEN
                 CALL i200_mes('insert',g_imd[l_ac].imd01)

                 IF g_success = 'N' THEN
                    ROLLBACK WORK
                    RETURN FALSE
                 END IF
              END IF
             #FUN-9A0056 add end ----------
           END IF
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(imd01) AND l_ac > 1 THEN
              LET g_imd[l_ac].* = g_imd[l_ac-1].*
              NEXT FIELD imd01
           END IF
            
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(imd16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_imd[l_ac].imd16
                 DISPLAY BY NAME g_imd[l_ac].imd16
                 NEXT FIELD imd16

              WHEN INFIELD(imd20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_imd[l_ac].imd20
                 DISPLAY BY NAME g_imd[l_ac].imd20
                 CALL i200_imd20('a')
                 NEXT FIELD imd20
           END CASE
 
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
 
    END INPUT
 
    CLOSE i200_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i200_b_askkey()
    CLEAR FORM
    CALL g_imd.clear()
    CONSTRUCT g_wc2 ON imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd16,imd20,imd18,imd19,imdacti, #FUN-670032  #MOD-920314 add imdacti #FUN-870100 #FUN-B50042 remove POS
                       imd17,imd22,imd23                  #FUN-930108 add imd17 #FUN-AA0023 add imd22 #FUN-C80107 add imd23
            FROM s_imd[1].imd01,s_imd[1].imd02,
                 s_imd[1].imd09,
                 s_imd[1].imd10,s_imd[1].imd11,
                 s_imd[1].imd12,s_imd[1].imd13,
                 s_imd[1].imd14,s_imd[1].imd15,
                 s_imd[1].imd16,s_imd[1].imd20,s_imd[1].imd18,s_imd[1].imd19,s_imd[1].imdacti, #FUN-670032  #MOD-920314 add imdacti #FUN-870100 #FUN-B50042 remove POS
                 s_imd[1].imd17,s_imd[1].imd22,s_imd[1].imd23   #FUN-930108 add imd17#FUN-AA0023 add imd22 #FUN-C80107 add imd23
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(imd16)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imd16
               NEXT FIELD imd16
            WHEN INFIELD(imd20)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imd20"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imd20
               NEXT FIELD imd20
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('imduser', 'imdgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0   #MOD-C30100
      RETURN
   END IF
    CALL i200_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql = "SELECT imd01,imd02,imd09,imd10,imd11,",
                "       imd12,imd13,imd14,imd15,imd16,'',imd20,'',imd18,imd19,imdpos,imdacti,imd17,imd22,imd23",  #FUN-670032  #FUN-930108 add imd17 #FUN-870100#FUN-AA0023 add imd22 #FUN-C80107 add imd23
                "  FROM imd_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY imd01"
    PREPARE i200_pb FROM g_sql
    DECLARE imd_curs CURSOR FOR i200_pb
 
    CALL g_imd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH imd_curs INTO g_imd[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL i200_get_gem02(g_imd[g_cnt].imd16)
          RETURNING g_imd[g_cnt].gem02  #FUN-670032
       SELECT azp02 INTO g_imd[g_cnt].imd20_desc FROM azp_file
        WHERE azp01=g_imd[g_cnt].imd20
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
 
    END FOREACH
    MESSAGE ""
    CALL g_imd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imd TO s_imd.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
        IF g_sma.sma901!='Y' THEN
           CALL cl_set_act_visible("aps_related_data",FALSE)
        END IF
        IF g_flag = 'Y' THEN
           CALL fgl_set_arr_curr(l_ac)
           LET g_flag = 'N'
        END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION account
         LET g_action_choice="account"
         EXIT DISPLAY
   
    #FUN-D30024 -------Begin-------
      ON ACTION set_negative_inventory 
         LET g_action_choice="set_negative_inventory"
         EXIT DISPLAY
    #FUN-D30024 -------End---------

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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION aps_related_data
         LET g_action_choice="aps_related_data"
         LET g_flag = 'Y'
         EXIT DISPLAY
 
      ON ACTION limitedright
         LET g_action_choice="limitedright"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i200_out()
  DEFINE    l_cmd       LIKE type_file.chr1000        #NO.FUN-810099    
    IF cl_null(g_wc2) THEN                                                                                                          
       CALL cl_err("","9057",0)                                                                                                     
       RETURN                                                                                                                       
    END IF 
    LET l_cmd = ' p_query "aimi200" "',g_wc2 CLIPPED,'"'                                                                            
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN  
END FUNCTION
 
#---- 97/06/21  insert 至 ime_file , 儲位=' '
FUNCTION i200_ins()
    DEFINE l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_imd[l_ac].imd01
    IF l_cnt=0 THEN
        INSERT INTO ime_file(ime01,ime02,ime03,ime04,ime05,ime06,   #No.MOD-470041
                            ime07,ime08,ime09,ime10,ime11,ime17,imeacti)    #FUN-9B0099 add ime17 #FUN-D40103
            VALUES(g_imd[l_ac].imd01,' ',' ',g_imd[l_ac].imd10,
                   g_imd[l_ac].imd11,g_imd[l_ac].imd12,g_imd[l_ac].imd13,
                   '0','',g_imd[l_ac].imd14,g_imd[l_ac].imd15,g_imd[l_ac].imd17,'Y')  #FUN-9B0099 add ime17的资料值#FUN-D40103
    END IF
END FUNCTION
 
FUNCTION i200_check()
    DEFINE l_buf LIKE ze_file.ze03   #No.FUN-690026 VARCHAR(80)
 
    SELECT COUNT(*) INTO g_i FROM imf_file WHERE imf02 = g_imd_t.imd01
    IF g_i > 0 THEN
       CALL cl_getmsg('mfg1011',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    SELECT COUNT(*) INTO g_i FROM img_file WHERE img02 = g_imd_t.imd01
                                             AND img10 != 0  #No.MOD-910019 add
    IF g_i > 0 THEN
       CALL cl_getmsg('mfg1012',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    IF l_buf IS NOT NULL THEN
       CALL cl_getmsg('mfg1013',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
       LET g_chr = 'E'
    ELSE
       LET g_chr = ''
    END IF
    #No.MOD-910019 add --begin
    SELECT COUNT(*) INTO g_i FROM img_file 
     WHERE img02 = g_imd_t.imd01 AND img10 = 0
    IF g_i > 0 THEN
       IF cl_null(g_chr) THEN
          LET g_chr = 'F'
       END IF
    END IF
    RETURN l_buf
END FUNCTION

FUNCTION i200_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("imd01",TRUE)                                                                                           
     CALL cl_set_comp_entry("imd23",FALSE)   #FUN-D30024
   END IF                                                                                                                           
#  CALL cl_set_comp_entry("imd11,imd12,imd23",TRUE)     #FUN-CB0052  #FUN-D10143 add imd23   #FUN-D30024
   CALL cl_set_comp_entry("imd11,imd12",TRUE)           #FUN-D30024  
 
#  CALL cl_set_comp_entry("imd12",TRUE)     #No.TQC-7A0082   #TQC-A40105  ---mark---
 
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i200_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("imd01",FALSE)                                                                                          
     CALL cl_set_comp_entry("imd23",FALSE)   #FUN-D30024 
     IF g_imd[l_ac].imd10 MATCHES '[Ii]' THEN        #FUN-CB0052
        CALL cl_set_comp_entry("imd11,imd12,imd23",FALSE)  #FUN-CB0052  #FUN-D10143 add imd23
     END IF                                          #FUN-CB0052
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
 
#FUN-D30024 ------------Begin------------
FUNCTION i200_b1_set_entry()
   CALL cl_set_comp_entry("imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd16,imd18,imd19,imd20,imdpos,imdacti,imd17,imd22",TRUE)   
END FUNCTION 
FUNCTION i200_b1_set_no_entry()
   IF g_chr = '1' THEN 
      CALL cl_set_comp_entry("imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd16,imd18,imd19,imd20,imdpos,imdacti,imd17,imd22",FALSE)  
      CALL cl_set_comp_entry("imd23",TRUE)
   END IF    
END FUNCTION 
#FUN-D30024 ------------End--------------
FUNCTION i200_get_gem02(p_imd16)
DEFINE p_imd16 LIKE imd_file.imd16,
       l_gem02 LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=p_imd16
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION
 
FUNCTION i200_acc()
   LET g_account=TRUE
   CALL i200_b()
   LET g_account=FALSE
END FUNCTION
 
FUNCTION i200_set_entry_b()
   CASE g_account
      WHEN TRUE
         CALL cl_set_comp_entry("imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd20,imd18,imd19,imdacti,imd17,imd22,imd23",FALSE)   #FUN-930108 add imd17 #FUN-870100#FUN-AA0023addimd22 #FUN-C80107 add imd23
         CALL cl_set_comp_entry("imd16",TRUE)
      OTHERWISE
      #  CALL cl_set_comp_entry("imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd20,imd18,imd19,imdacti,imd17,imd22,imd23",TRUE)   #FUN-930108 add imd17 #FUN-870100#FUN-AA0023addimd22 #FUN-C80107 add imd23    #FUN-D30024 mark
         CALL cl_set_comp_entry("imd01,imd02,imd09,imd10,imd11,imd12,imd13,imd14,imd15,imd20,imd18,imd19,imdacti,imd17,imd22",TRUE)         #FUN-D30024
         CALL cl_set_comp_entry("imd16",FALSE)
   END CASE
END FUNCTION
 
FUNCTION i200_aps()     #FUN-680048
    DEFINE l_vmf         RECORD LIKE vmf_file.*     #NO.FUN-7C0002
 
    LET g_action_choice="aps_related_data"                     
    IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF  #TQC-750013 add
    IF cl_null(g_imd[l_ac].imd01) THEN
       CALL cl_err('',-400,1)
       RETURN #TQC-750013 add
    END IF
    IF NOT cl_null(g_imd[l_ac].imd01) THEN #FUN-720043--mod
 
       #--no.FUN-7C0002 改呼叫apsi305.4gl add-----:-
       SELECT vmf01 FROM vmf_file WHERE vmf01 = g_imd[l_ac].imd01
       IF SQLCA.sqlcode=100 THEN
          LET l_vmf.vmf01 = g_imd[l_ac].imd01
          LET l_vmf.vmf04 = 0
          LET l_vmf.vmf05 = 0
          LET l_vmf.vmf06 = 0  #add vmf06  FUN-870012
          LET l_vmf.vmf07 = 0  #FUN-910005  ADD
          INSERT INTO vmf_file(vmf01,vmf04,vmf05,vmf06,vmf07)  #FUN-910005 ADD vmf07 
                        VALUES(l_vmf.vmf01,l_vmf.vmf04,l_vmf.vmf05,l_vmf.vmf06,l_vmf.vmf07)  #FUN-910005 ADD vmf07
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmf_file",g_imd[l_ac].imd01,"",SQLCA.sqlcode,
                          "","",1)  
          END IF
       END IF
       LET g_cmd = "apsi305 '",g_imd[l_ac].imd01,"'"
       CALL cl_cmdrun(g_cmd)
    END IF
END FUNCTION
#FUN-AA0023 add---str---
FUNCTION i200_imd22()
   DEFINE l_n LIKE type_file.num5
   
   LET g_errno = " "
   LET l_n = 0
   IF g_imd[l_ac].imd22 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd10=g_imd[l_ac].imd10 
         AND imd22='Y' AND imd20 = g_imd[l_ac].imd20
         IF l_n > 0 THEN             
            LET g_errno = 'aim-161'
         END IF
   END IF
END FUNCTION

#FUN-AA0023 add---end---
#No.FUN-9C0072 精簡程式碼 
#FUN-9A0056 -- add i200_mes() for MES
FUNCTION i200_mes(p_key1,p_key2)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('aimi200',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
        LET g_success = 'N'
 END CASE

END FUNCTION
