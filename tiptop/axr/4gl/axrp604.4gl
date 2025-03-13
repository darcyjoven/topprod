# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp604.4gl
# Descriptions...: 待抵变更单整批生成账款作业
# Date & Author..: FUN-C20019 12/02/03 By minpp
# Modify.........: No.TQC-C20204 12/02/15 By xuxz 調整傳入參數的取值方法
# Modify.........: No.TQC-C20209 12/02/16 By minpp 1.s_auto_assign 應該加判斷如果自動編號失敗，則報錯回滾；
#                                                  2.若在artt613拋轉財務，則單別單別默認取FIRST ooytype='33'AND ooyacti='Y'的單別
# Modify.........: No.TQC-C20439 12/02/23 By minpp 產生待抵變更單，第二單身科目默認與第一單身科目一致
# Modify.........: No.TQC-C20484 12/02/24 By minpp 修正贷方oob04,oob06，oob26的赋值
# Modify.........: No.TQC-C20464 12/02/24 By minpp 1.增加判斷。若待抵變更單的狀況碼<>2則報錯
#                                                  2.產生雜項待抵單時，單身條件oob04=‘2’拿掉，在往axrt401插值時oob27不要自動編號，給ooz30
# Modify.........: No.TQC-C20430 12/02/25 By wangrr 產生待抵變更單是ooa35='1',ooa36賦值為待抵變更單單號
# Modify.........: NO:MOD-C30636 12/03/12 By zhangweib 修改g_wc段的BEFORE CONSTRUCT語句,使之只會在初始狀態下賦默認值
#                                                      新增AFTER FIELD ar_slip段資料有效性的判斷
# Modify.........: NO:TQC-C30188 12/03/14 By zhangweib 1.產生的axrt401的資料根據單別的判斷是否拋轉總帳
#                                                      2.拋轉總帳拿到批次的事物結束后再做拋轉
# Modify.........: NO:MOD-C30607 12/03/16 By zhangewib 拋轉傳票時加上單據為已確認才可拋轉的判斷
# Modify.........: NO:FUN-C30029 12/03/19 By minpp 修改賦值 ooa38='1'
# Modify.........: NO:FUN-C30029 12/04/01 By zhangweib 產生的單據都為已審核狀態,去掉ooyconf = 'Y'的判斷
# Modify.........: NO:TQC-C40195 12/04/20 By lujh  azp01再次執行時也能默認值

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_wc       STRING                   #QBE_1的條件
DEFINE g_wc2      STRING                   #QBE_2的條件
DEFINE g_sql      STRING                   #組sql
DEFINE g_plant_new  LIKE type_file.chr21     #營運中心

DEFINE tm         RECORD                   #條件選項
         ar_slip     LIKE oow_file.oow14   #費用類型
                  END RECORD

DEFINE g_t1          LIKE ooy_file.ooyslip
DEFINE g_cnt         LIKE type_file.num5
DEFINE g_t2          LIKE ooy_file.ooyslip
DEFINE t_date        LIKE type_file.dat 
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE li_result     LIKE type_file.num5
DEFINE l_ac          LIKE type_file.num5
DEFINE l_ac_a        LIKE type_file.num5
DEFINE g_change_lang LIKE type_file.chr1 
DEFINE g_luk16       LIKE luk_file.luk16
DEFINE g_n_lum01     LIKE lum_file.lum01
DEFINE g_lum         RECORD LIKE lum_file.*
DEFINE g_oob         RECORD LIKE oob_file.*  
DEFINE g_ooa         RECORD LIKE ooa_file.*
DEFINE g_oma         RECORD LIKE oma_file.*               
DEFINE g_omc         RECORD LIKE omc_file.*
DEFINE g_str         STRING        #No.TQC-C30188   Add
DEFINE g_wc_gl       STRING        #No.TQC-C30188   Add
MAIN 

   DEFINE l_flag  LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
   LET g_wc = ARG_VAL(1)
   LET g_wc       = cl_replace_str(g_wc, "\\\"", "'")  #TQC-C20204
   LET g_wc2 = ARG_VAL(2)
   LET g_wc2      = cl_replace_str(g_wc2, "\\\"", "'") #TQC-C20204
   LET tm.ar_slip = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)  
 
   IF cl_null(g_bgjob) THEN 
      LET g_bgjob ="N"
   END IF 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log 

   
   IF (NOT cl_setup("AXR")) THEN 
      EXIT PROGRAM 
   END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
  #TQC-C20209--ADD--STR 
   LET g_sql="SELECT ooyslip  FROM ooy_file",
           " WHERE ooytype = '33' AND ooyacti='Y'",
           " ORDER BY ooyslip"
  PREPARE p604_ooyslip_prepare FROM g_sql
  DECLARE p604_ooyslip_cs CURSOR FOR p604_ooyslip_prepare
  FOREACH p604_ooyslip_cs INTO  g_ooy.ooyslip
     IF NOT cl_null (g_ooy.ooyslip) THEN
        IF cl_null(tm.ar_slip) THEN
           LET tm.ar_slip = g_ooy.ooyslip
        END IF
        EXIT FOREACH
     END IF
  END FOREACH
 
  #TQC-C20209--ADD--END 
  
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p604()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p604_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
              #No.TQC-C30188   ---start---   Add
               SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
               IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
                  LET g_wc_gl = g_wc_gl,')'
                  LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
                  CALL cl_cmdrun_wait(g_str)
               END IF
              #No.TQC-C30188   ---start---   Add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p604_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p604_1()

         IF g_success = "Y" THEN
            COMMIT WORK 
           #No.TQC-C30188   ---start---   Add
            SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
            IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
               LET g_wc_gl = g_wc_gl,')'
               LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
               CALL cl_cmdrun_wait(g_str)
            END IF
           #No.TQC-C30188   ---start---   Add
            CALL cl_err('','lib-284',1) #TQC-C20430
         ELSE
            ROLLBACK WORK
            CALL cl_err('','abm-020',1) #TQC-C20430
         END IF
         #CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p604()
   DEFINE l_lum01  LIKE lum_file.lum01
   DEFINE l_ooyacti   LIKE ooy_file.ooyacti    #No.MOD-C30636   Add
   DEFINE l_azp01     LIKE azp_file.azp01   #TQC-C40195  add

   LET p_row = 5 LET p_col = 28
   
   OPEN WINDOW p604_w AT p_row,p_col WITH FORM "axr/42f/axrp604"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM 

   
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
      
         BEFORE CONSTRUCT 
           #DISPLAY g_plant TO azp01   #No.MOD-C30636   Mark
            #IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF   #No.MOD-C30636   Add   #TQC-C40195  mark
            #TQC-C40195--add--str--
            LET l_azp01 = GET_FLDBUF(azp01)
            IF cl_null(l_azp01) THEN
               DISPLAY g_plant TO azp01
            END IF
            #TQC-C40195--add--end--
            
      END CONSTRUCT 

      CONSTRUCT BY NAME g_wc2 ON lum01,lum05,lum03

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      INPUT BY NAME tm.ar_slip
        
         AFTER FIELD ar_slip
            IF NOT cl_null(tm.ar_slip) THEN 
              #No.MOD-C30636   ---start---   Add
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(tm.ar_slip,'axr-956',1)
                  NEXT FIELD ar_slip
               END IF
               CALL s_check_no("axr",tm.ar_slip,"","33","","","")
                    RETURNING li_result,tm.ar_slip
               IF (NOT li_result) THEN
                 NEXT FIELD ar_slip
               END IF
               DISPLAY BY NAME tm.ar_slip
              #No.MOD-C30636   ---end---     Add
            END IF 
      END INPUT

      ON ACTION controlp
         CASE 
            WHEN INFIELD(azp01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where ="azw02 = '",g_legal,"'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01
            WHEN INFIELD(lum01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lum01"
               LET g_qryparam.where = "lumconf = 'Y'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lum01
               NEXT FIELD lum01    #No.MOD-C30636   Add
            WHEN INFIELD(lum05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lum05
               NEXT FIELD lum05    #No.MOD-C30636   Add
            WHEN INFIELD(ar_slip)
               CALL q_ooy( FALSE, TRUE, tm.ar_slip,'33','AXR')  RETURNING g_t1
               LET tm.ar_slip = g_t1
               DISPLAY BY NAME tm.ar_slip
               NEXT FIELD ar_slip    #No.MOD-C30636   Add
            OTHERWISE
               EXIT CASE
         END CASE
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
                
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
                 
      ON ACTION about         
         CALL cl_about()      
                  
      ON ACTION help          
         CALL cl_show_help()  
                  
      ON ACTION controlg      
         CALL cl_cmdask()     
              
      ON ACTION accept
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
              
   END DIALOG

   IF INT_FLAG THEN
      CLOSE WINDOW p604_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF        
END FUNCTION 

FUNCTION p604_1()
   DEFINE  amt       LIKE type_file.num20_6    #小数点
   #TQC-C20464--ADD--str
   DEFINE  l_oma54t  LIKE oma_file.oma54t 
   DEFINE  l_oma55   LIKE oma_file.oma55   
   DEFINE  l_luk10   LIKE luk_file.luk10
   DEFINE  l_luk11   LIKE luk_file.luk11
   DEFINE  l_luk12   LIKE luk_file.luk12
   #TQC-C20464--add--end

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init() 
   #1.根据QBE条件选取需要的营运中心，根据营运中心用跨库的方式选取待抵变更单artt613的资料
      #抓取符合用戶QBE1條件的當前法人下的所有營運中心
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "  AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p604_sel_azw FROM g_sql
   DECLARE p604_azw_curs CURSOR FOR p604_sel_azw
   FOREACH p604_azw_curs INTO g_plant_new
      #逐个抓取对应营运中心下待抵变更单资料
       LET g_sql = "SELECT *",
                  "  FROM ",cl_get_target_table(g_plant_new,'lum_file'),
                  " WHERE ",g_wc2 CLIPPED,
                # "   and lum16='2'", #TQC-C20464 MARK
                  "   and lumplant = ? ",
                  "   and lumconf = 'Y'",
                  "   and lum17 is null"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p604_lum_pre FROM g_sql
      DECLARE p604_lum_cs CURSOR FOR p604_lum_pre
      FOREACH p604_lum_cs USING g_plant_new INTO g_lum.*
        #TQC-C20464--ADD--STR
        IF g_lum.lum16 <> '2' THEN
           CALL s_errmsg('','',g_lum.lum16,'axr-105',1)
           LET g_success = 'N'
           CALL s_showmsg()  #TQC-C20430
           RETURN
        END IF
        #TQC-C20464--ADD--END 

        #判斷ar_slip是否有值,若沒值則賦給artt613的變更單單別
         IF cl_null(tm.ar_slip) THEN
            CALL s_get_doc_no(g_lum.lum01) RETURNING g_t2
            LET tm.ar_slip = g_t2
         END IF        
          
         INITIALIZE g_oob.* TO NULL 
         INITIALIZE g_ooa.* TO NULL
         #ooa01自动编号
         IF NOT cl_null(tm.ar_slip) THEN
            CALL s_auto_assign_no("axr",tm.ar_slip,g_today,"33","ooa_file","ooa01","","","")   #
            RETURNING g_cnt,g_ooa.ooa01
         END IF
         #TQC-C20209--ADD--STR
         IF (NOT g_cnt) THEN
            LET g_success = 'N'
            CALL s_showmsg()  #TQC-C20430
            RETURN
         END IF
         #TQC-C20209--ADD--END
          #抓取财务待抵单单号 
        LET g_sql = "SELECT luk16", 
                  "  FROM ",cl_get_target_table(g_plant_new,'luk_file'),
                  " WHERE luk01 = ?",
                  "   and lukconf = 'Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        PREPARE p604_luk_pre FROM g_sql
        EXECUTE p604_luk_pre USING g_lum.lum02 INTO g_luk16
        #TQC-C20464--ADD--STR
        IF cl_null(g_luk16) THEN
           CALL s_errmsg('','',g_lum.lum02,'axr-106',1)
           LET g_success='N'
        ELSE
           LET l_oma54t=0
           LET l_oma55 =0
           SELECT oma54t,oma55 INTO l_oma54t,l_oma55 FROM oma_file where oma01=g_luk16
           IF l_oma54t-l_oma55 < g_lum.lum10-g_lum.lum11-g_lum.lum12  THEN
              CALL s_errmsg('','',g_luk16,'axr-107',1)
              LET g_success='N'
           END IF
        END IF
        #TQC-C20464--ADD--END
         IF g_success='Y' THEN
    #2.产生审核的artt401的单身资料
            CALL p604_ins_oob()
    #3.产生审核的artt401的单头资料 
            IF g_success='Y' THEN 
               CALL p604_ins_ooa()
             END IF   
         END IF 
         
     #4.產生分錄底稿以及雜項待抵單
     #(1)產生分錄底稿
      IF g_success = 'Y' THEN   #No.TQC-C30188   Add
       CALL s_t400_gl(g_ooa.ooa01,'0')				
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 				
	      CALL s_t400_gl(g_ooa.ooa01,'1')			
       END IF     
      #No.TQC-C30188   ---start---   Add
       IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN                              #No.MOD-C30607   Mark   #No.FUN-C30029   Unmark
      #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_ooy.ooyconf = 'Y' THEN      #No.MOD-C30607   Add    #No.FUN-C30029   Mark
          IF cl_null(g_wc_gl) THEN
             LET g_wc_gl = ' npp011 = 1 AND npp01 IN ("',g_ooa.ooa01,'"'
          ELSE
             LET g_wc_gl = g_wc_gl,',"',g_ooa.ooa01,'"'
          END IF
       END IF
      #No.TQC-C30188   ---end---     Add
      END IF   #No.TQC-C30188    Add
     #(2)產生雜項待抵單
     IF g_success='Y' THEN
        CALL p604_ins_oma()
     #更新原财务待抵单的已冲金额	
      LET amt=g_lum.lum10-g_lum.lum11-g_lum.lum12
      UPDATE oma_file SET oma55=oma55+amt,
                          oma57=oma57+amt
      WHERE oma01 = g_luk16
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
         CALL s_errmsg('oma_file','update',g_luk16,'',1)
         LET g_success = 'N'
      END IF                  
     #更新业务端待抵变更单的财务单号
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'lum_file')," SET lum17 = '",g_ooa.ooa01,"'",
                   " WHERE lum01 = '",g_lum.lum01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p604_upd_lum FROM g_sql
       EXECUTE p604_upd_lum
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
          CALL s_errmsg('lum_file','update',g_lum.lum01,'',1)
          LET g_success = 'N'
       END IF                
     #更新业务端产生的新的待抵单的财务待抵单号luk16
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'luk_file')," SET luk16 = '",g_oma.oma01,"'",
                   " WHERE luk05 = '",g_lum.lum01,"'",
                   "   AND luk04='3'",
                   "   AND lukconf='Y'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p604_upd_luk FROM g_sql
       EXECUTE p604_upd_luk
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
          CALL s_errmsg('luk_file','update',g_lum.lum01,'',1)
          LET g_success = 'N'
       END IF 
    END IF    
   END FOREACH  
  END FOREACH
   CALL s_showmsg()
END FUNCTION  

FUNCTION p604_ins_oob() 
    DEFINE  l_oma18   LIKE oma_file.oma18
    DEFINE  l_ool25   LIKE ool_file.ool25  

     #借方  
     LET g_oob.oob03='1'  #借
     LET g_oob.oob01=g_ooa.ooa01

     SELECT max(oob02)+1 INTO g_oob.oob02 FROM oob_file
      WHERE oob01 = g_oob.oob01
     IF g_oob.oob02 IS NULL THEN
        LET g_oob.oob02 = 1
     END IF
     
    LET g_oob.oob04='3'
    LET g_oob.oob06=g_luk16
    LET g_oob.oob07=g_aza.aza17
    LET g_oob.oob08='1'
    LET g_oob.oob09 = g_lum.lum10-g_lum.lum11-g_lum.lum12
    LET g_oob.oob10 = g_oob.oob09
    SELECT oma18 INTO l_oma18 FROM oma_file WHERE oma01=g_luk16
    LET g_oob.oob11 = l_oma18  
    LET g_oob.oob19='1'  #TQC-C20464  ADD
    LET g_oob.ooblegal=g_legal
    INSERT INTO oob_file VALUES (g_oob.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
       CALL s_errmsg('oob_file','insert',g_oob.oob01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF             

     #贷方
   LET g_oob.oob03='2'  #贷
   LET g_oob.oob01=g_ooa.ooa01

     SELECT max(oob02)+1 INTO g_oob.oob02 FROM oob_file
      WHERE oob01 = g_oob.oob01
       IF g_oob.oob02 IS NULL THEN
          LET g_oob.oob02 = 1
       END IF
    #LET g_oob.oob04='2'   #TQC-C20484 MARK
    LET g_oob.oob04 = g_ooz.ooz27 #TQC-C20484 add
    LET g_oob.oob06 = NULL        #TQC-C20484 add
    LET g_oob.oob07= g_aza.aza17
    LET g_oob.oob08= '1'
    LET g_oob.oob09= g_lum.lum10-g_lum.lum11-g_lum.lum12
    LET g_oob.oob10= g_oob.oob09
    LET g_oob.oob19= NULL  #TQC-C20464  ADD
    LET g_oob.oob24= g_lum.lum051
    LET g_oob.oob25= g_lum.lum04
   #TQC-C20484---MOD--STR--
   #SELECT occ67 INTO g_oma.oma13 FROM  occ_file
   # WHERE occ01=g_lum.lum051
   #IF cl_null(g_oma.oma13) THEN
   #   LET g_oma.oma13=g_ooz.ooz08
   #END IF
   #LET g_oob.oob26 = g_oma.oma13
   LET g_oob.oob26 = g_ooz.ooz27
    #TQC-C20484---MOD--END--
   
   #TQC-C20439--MARK--STR
   #SELECT ool25 INTO l_ool25 FROM ool_file WHERE ool01=g_oma.oma13
   #LET g_oob.oob11 = l_ool25
   #TQC-C20439--MARK--END 
   #TQC-C20464--MOD--STR-- 
    #CALL s_auto_assign_no("AXR",g_ooz.ooz30,g_oob.oob25,"22","oma_file","oma01","","","")
    #RETURNING li_result,g_oob.oob27
    LET g_oob.oob27=g_ooz.ooz30
    #TQC-C20209--ADD--STR
    # IF (NOT li_result) THEN
    #    LET g_success = 'N'
    #    RETURN
    # END IF
    #TQC-C20209--ADD--END
    #TQC-C20464--MOD--END
    LET g_oob.ooblegal=g_legal
    INSERT INTO oob_file VALUES (g_oob.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
       CALL s_errmsg('oob_file','insert',g_oob.oob01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF

 END FUNCTION

FUNCTION p604_ins_ooa() 
 DEFINE  l_occ02   LIKE occ_file.occ02
 DEFINE  l_oob09   LIKE oob_file.oob09
 DEFINE  l_oob09_1 LIKE oob_file.oob09
 DEFINE  l_oob10   LIKE oob_file.oob10
 DEFINE  l_oob10_1 LIKE oob_file.oob10
 
    LET g_ooa.ooa00='1'
    LET g_ooa.ooa01=g_oob.oob01
    LET g_ooa.ooa02=g_lum.lum04
    LET g_ooa.ooa03=g_lum.lum05
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_lum.lum05
    LET g_ooa.ooa032=l_occ02
    LET g_ooa.ooa37='3'
    SELECT occ67 INTO g_oma.oma13 FROM occ_file
     WHERE occ01=g_lum.lum05
     IF cl_null(g_oma.oma13) THEN 
        LET g_oma.oma13= g_ooz.ooz08
     END IF 
     LET g_ooa.ooa13=g_oma.oma13
     LET g_ooa.ooa14=g_lum.lum13
     LET g_ooa.ooa15=g_lum.lum14
     LET g_ooa.ooa23=g_aza.aza17
     LET g_ooa.ooa31d = 0
     LET g_ooa.ooa31c = 0
     LET g_ooa.ooa32d = 0
     LET g_ooa.ooa32c = 0
     LET g_ooa.ooaconf='Y'
     LET g_ooa.ooa40='02'
     LET g_ooa.ooa021=g_today
     LET g_ooa.ooa20='Y'
    #LET g_ooa.ooa38 = '2' #FUN-C30029 mark
     LET g_ooa.ooa38 = '1' #FUN-C30029 add       
     LET g_ooa.ooalegal = g_azw.azw02
    
     SELECT SUM (oob09)  INTO l_oob09 FROM oob_file
     WHERE oob01=g_ooa.ooa01
      AND  oob03='1'
     LET g_ooa.ooa31d = l_oob09
     
     SELECT SUM (oob09) INTO l_oob09_1 FROM oob_file
     WHERE oob01=g_ooa.ooa01
      AND  oob03='2'
     LET g_ooa.ooa31c=l_oob09_1

     SELECT SUM (oob10) INTO l_oob10 FROM oob_file
     WHERE oob01=g_ooa.ooa01
      AND  oob03='1'
     LET g_ooa.ooa32d =l_oob10

     SELECT SUM (oob10) INTO l_oob10_1 FROM oob_file
     WHERE oob01=g_ooa.ooa01
      AND  oob03='2'
     LET g_ooa.ooa32c=l_oob10_1			
     LET g_ooa.ooaprsw = 0						
     LET g_ooa.ooauser = g_user						
     LET g_ooa.ooaoriu = g_user				
     LET g_ooa.ooaorig = g_grup 						
     LET g_ooa.ooagrup = g_grup						
     LET g_ooa.ooadate = g_today						
     LET g_ooa.ooamksg = "N"     					
     LET g_ooa.ooa34 = "0"       					
     LET g_ooa.ooalegal = g_legal 					
     #TQC-C20430--add--begin
     LET g_ooa.ooa35='1'
     LET g_ooa.ooa36=g_lum.lum01
     #TQC-C20430--add--end 
     INSERT INTO ooa_file VALUES (g_ooa.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
        CALL s_errmsg('ooa_file','insert',g_ooa.ooa01,SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF   
 END FUNCTION

FUNCTION p604_ins_oma()
DEFINE  l_oob_t      DYNAMIC ARRAY OF RECORD
         oob06       LIKE oob_file.oob06,
         oob09       LIKE oob_file.oob09,
         oob10       LIKE oob_file.oob10  
                     END RECORD 
DEFINE  l_oob        RECORD LIKE oob_file.*
DEFINE  l_oma        RECORD LIKE oma_file.*
DEFINE  l_omc        RECORD LIKE omc_file.*
DEFINE  l_occ        RECORD LIKE occ_file.*
DEFINE  li_result    LIKE type_file.num5
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  i            LIKE type_file.num5 
DEFINE  l_oma13      LIKE oma_file.oma13
DEFINE  l_oma18      LIKE oma_file.oma18
DEFINE  l_oma181     LIKE oma_file.oma181 
DEFINE  exT          LIKE type_file.chr1 
DEFINE  l_ooy        RECORD LIKE ooy_file.*

   IF g_success ='N' THEN RETURN END IF
    FOR i =1 TO l_oob_t.getlength()
      IF cl_null(l_oob_t[i].oob09) THEN LET l_oob_t[i].oob09 = 0 END IF 
      IF cl_null(l_oob_t[i].oob10) THEN LET l_oob_t[i].oob10 = 0 END IF 

      IF cl_null(l_oma13) AND cl_null(l_oma18) THEN 
         SELECT oma13,oma18,oma181 INTO l_oma13,l_oma18,l_oma181 FROM oma_file WHERE oma01 = l_oob_t[i].oob06
         IF cl_null(l_oma13) OR cl_null(l_oma18) THEN 
            LET l_oma13 = NULL 
            LET l_oma18 = NULL 
         END IF 
      END IF   
      LET i = i + 1     
   END FOR
   
   DECLARE p604_sel_oob CURSOR  FOR 
   SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 AND oob03 ='2'  #AND oob04='2'  #TQC-C20464 MARK
   
   FOREACH p604_sel_oob INTO l_oob.*
      IF STATUS THEN CALL cl_err('sel oob',STATUS,1) EXIT FOREACH END IF 
         INITIALIZE g_oma.* TO NULL
         INITIALIZE g_omc.* TO NULL 
         LET g_oma.oma02  = l_oob.oob25 
         LET g_oma.oma09  = g_oma.oma02 
         LET g_oma.oma00  = '22'
         CALL s_auto_assign_no("AXR",l_oob.oob27,l_oob.oob25,"22","oma_file","oma01","","","")
              RETURNING li_result,l_oob.oob27
         IF  li_result THEN
             LET g_oma.oma01  = l_oob.oob27             
             UPDATE oob_file SET oob27 = l_oob.oob27
              WHERE oob01 = g_ooa.ooa01
                AND oob02 = l_oob.oob02
                AND oob03 = '2'
           #     AND oob04 = '2'   #TQC-C20464 MARK
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
                CALL s_errmsg('oob_file','update',g_ooa.ooa01,'',1)
                LET g_success = 'N'
             END IF    
         ELSE
             CALL s_errmsg('','',g_oma.oma01,'mfg-059',1)      
             LET g_success = 'N'
             RETURN 
         END IF 
         
         LET g_oma.oma03  = l_oob.oob24
         SELECT occ02 INTO g_oma.oma032 FROM occ_file WHERE occ01 = g_oma.oma03
         LET g_oma.oma04  = l_oob.oob24
         LET g_oma.oma08  = '1'
         SELECT * INTO l_occ.*  FROM occ_file WHERE occ01 = g_oma.oma03
         LET g_oma.oma23  = l_oob.oob07
         LET g_oma.oma24  = l_oob.oob08
         LET g_oma.oma13  = g_ooz.ooz28
         #IF g_ooz.ooz29 = 'N' THEN   #TQC-C20430 mark--
            LET g_oma.oma18  = l_oob.oob11
            LET g_oma.oma181 = l_oob.oob111   
         #TQC-C20430--mark--str
         #ELSE
         #   SELECT ool11,ool111 INTO g_oma.oma18,g_oma.oma181 FROM ool_file WHERE ool01=g_oma.oma13
         #END IF
         #TQC-C20430--mark--end   
         SELECT occ45 INTO g_oma.oma32 FROM occ_file WHERE occ01 = g_oma.oma03 
         LET g_oma.oma04 = g_oma.oma03
         LET g_oma.oma05 = l_occ.occ08 
         LET g_oma.oma14 = l_occ.occ04 
         SELECT gen03 INTO g_oma.oma15 FROM gen_file
          WHERE gen01=g_oma.oma14
         LET g_oma.oma930=s_costcenter(g_oma.oma15)
         LET g_oma.oma21 = l_occ.occ41 
         LET g_oma.oma40 = l_occ.occ37 
         LET g_oma.oma25 = l_occ.occ43
         LET g_oma.oma32 = l_occ.occ45
         LET g_oma.oma042= l_occ.occ11
         LET g_oma.oma043= l_occ.occ18
         LET g_oma.oma044= l_occ.occ231
         CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,
                       g_oma.oma02,g_plant)
         RETURNING g_oma.oma11,g_oma.oma12  
         SELECT gec04,gec05,gec07
           INTO g_oma.oma211,g_oma.oma212,g_oma.oma213
           FROM gec_file 
          WHERE gec01=g_oma.oma21
            AND gec011='2' 

         IF g_oma.oma08='1' THEN
            LET exT=g_ooz.ooz17
         ELSE
            LET exT=g_ooz.ooz63
         END IF
         IF g_oma.oma23=g_aza.aza17 THEN
            LET g_oma.oma24=1
            LET g_oma.oma58=1
         ELSE
            IF g_oma.oma24=0 OR g_oma.oma24=1 THEN
               CALL s_curr3(g_oma.oma23,g_oma.oma02,exT)
                RETURNING g_oma.oma24
            END IF
            CALL s_curr3(g_oma.oma23,g_oma.oma09,exT)
            RETURNING g_oma.oma58
         END IF
         LET g_oma.oma66  = g_plant   
         LET g_oma.oma50 = 0
         LET g_oma.oma51 = 0
         LET g_oma.oma51f= 0
         LET g_oma.oma50t= 0
         LET g_oma.oma52 = 0
         LET g_oma.oma53 = 0
         LET g_oma.oma54 = l_oob.oob09
         LET g_oma.oma54t= l_oob.oob09
         LET g_oma.oma56 = l_oob.oob10
         LET g_oma.oma56t= l_oob.oob10
         LET g_oma.oma54x= 0
         LET g_oma.oma55 = 0
         LET g_oma.oma56x= 0
         LET g_oma.oma57 = 0
         LET g_oma.oma58 = 0
         LET g_oma.oma59 = 0
         LET g_oma.oma59x= 0
         LET g_oma.oma59t= 0
         LET g_oma.oma60 = l_oob.oob08
         LET g_oma.oma61 = l_oob.oob10
         LET g_oma.omaconf='Y'
         LET g_oma.oma64 = '1'         
         LET g_oma.omavoid='N'
         LET g_oma.oma65 = '1'  
         LET g_oma.oma66 = g_plant           
         LET g_oma.oma68 = g_oma.oma03                                                                   
         LET g_oma.oma69 = g_oma.oma032  
         LET g_oma.oma70 = '1' 
         LET g_oma.omauser= g_user
         LET g_oma.omagrup= g_grup
         LET g_oma.omadate= g_today
         LET g_oma.omaoriu= g_user
         LET g_oma.omaorig= g_grup
         LET g_oma.omalegal=g_legal
         IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
         IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
         IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
         LET g_oma.oma16=l_oob.oob01    #TQC-C20430
         INSERT INTO oma_file VALUES(g_oma.*)  
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                    
            CALL s_errmsg('','','ins oma err',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH 
         ELSE
            SELECT azi04 INTO t_azi04 FROM azi_file                                                                                          
             WHERE azi01 = g_oma.oma23 
            LET g_omc.omc01 = g_oma.oma01
            LET g_omc.omc02 = 1
            LET g_omc.omc03 = g_oma.oma32
            LET g_omc.omc04 = g_oma.oma11
            LET g_omc.omc05 = g_oma.oma12
            LET g_omc.omc06 = g_oma.oma24
            LET g_omc.omc07 = g_oma.oma60
            LET g_omc.omc08 = g_oma.oma54t
            LET g_omc.omc09 = g_oma.oma56t
            LET g_omc.omc10 = 0
            LET g_omc.omc11 = 0
            LET g_omc.omc12 = g_oma.oma10
            LET g_omc.omc13 = g_omc.omc09-g_omc.omc11
            LET g_omc.omc14 = 0
            LET g_omc.omc15 = 0
            CALL cl_digcut(g_omc.omc08,t_azi04) RETURNING g_omc.omc08
            CALL cl_digcut(g_omc.omc09,g_azi04) RETURNING g_omc.omc09
            CALL cl_digcut(g_omc.omc13,g_azi04) RETURNING g_omc.omc13
            LET g_omc.omclegal = g_ooa.ooalegal
            INSERT INTO omc_file VALUES(g_omc.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL s_errmsg('','','ins omc err',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            IF g_success ='N' THEN RETURN END IF
       END IF           
   END FOREACH 
END FUNCTION 
#FUN-C20019 
   
