# Prog. Version..: '5.30.07-13.05.31(00010)'     #
# Pattern name...: axcp100.4gl
# Descriptions...: 暂估差异抛转材料金额作业
# Date & Author..: 10/07/01 No.FUN-A70112 By xiaofeizhu
# Modify.........: No.TQC-AB0062 10/11/17 By Elva 增加退货暂估差异处理
# Modify.........: No:TQC-B10186 11/01/19 By shiwuying Bug修改
# Modify.........: No:MOD-BC0024 11/12/02 By yinhy 1.MISC料件的差異不應考慮
# Modify.........:                                 2.暫估金額取值改變
# Modify.........: No:MOD-C30019 12/03/02 By yinhy 只處理暫估差異，不需要去考慮庫存量和當月發生量
# Modify.........: No:FUN-C50131 12/05/28 By minpp 增加分錄底稿產生，拋轉總帳，拋轉還原按鈕
# Modify.........: No:FUN-C50131 12/06/05 By minpp 增加insert前的条件判断，增加汇总报错
# Modify.........: No:FUN-C60016 12/06/05 By minpp 增加产生分录的判断及报错汇总
# Modify.........: No:FUN-C60034 12/06/13 By minpp 增加憑證編號顯示
# Modify.........: No:FUN-C60065 12/06/25 By minpp 畫面無資料時單擊拋轉憑證等按鈕需要提示無資料
# Modify.........: No:FUN-C80092 12/09/12 By xujing 成本相關作業程式日誌
# Modify.........: No:MOD-D10077 13/01/09 By wujie 单身与产生分录时数据需要对应，sql判断条件要一致
# Modify.........: No:MOD-D20157 13/02/25 By wujie 当抓到的暂估为单身数量为0的折让类型时，暂估金额cap11=应付单数量*暂估单价
# Modify.........: No:CHI-D10059 13/03/11 By bart 月份改為期別
# Modify.........: No:MOD-D50148 13/05/17 By wujie 暂估金额的来源方式改变
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:MOD-D70020 13/07/04 By wujie aag00的条件不能写死为00
# Modify.........: No:MOD-D70024 13/07/04 By wujie 科目按ccz07取，不能写死ima39
#                                                  科目要考虑部门管理
# Modify.........: No:MOD-D70086 13/07/12 By wujie 期初分摊数量应该是SUM（imk09）
# Modify.........: No:MOD-D80008 13/08/01 By wujie 分录借方与贷方分开计算

DATABASE ds

#TQC-B10186 Begin---
GLOBALS "../../config/top.global"
#TQC-B10186 End-----

DEFINE tm               RECORD
          yy      LIKE type_file.num5,
          mm      LIKE type_file.num5
                        END RECORD
DEFINE g_cap         DYNAMIC ARRAY OF RECORD LIKE cap_file.*
DEFINE g_tot_h    RECORD
         cap15 LIKE cap_file.cap15,
         cap16 LIKE cap_file.cap16,
         cap17 LIKE cap_file.cap17
                  END RECORD
DEFINE g_tot      DYNAMIC ARRAY OF RECORD
         t01      LIKE ima_file.ima01,       #产品编号
         ima02    LIKE ima_file.ima02,       #品名
         ima021   LIKE ima_file.ima021,      #规格
         ima39    LIKE ima_file.ima39,       #料件所属科目     #No.100326
         aag02    LIKE aag_file.aag02,       #科目名称         #No.100326
         t02      LIKE apb_file.apb09,       #入库数量
         t03      LIKE type_file.num20_6,    #入库金y
         t04      LIKE type_file.num20_6,    #暂估金额
         t05      LIKE type_file.num20_6,    #差异金额
         t06      LIKE type_file.num20_6,    #差异单价
         t07      LIKE apb_file.apb09,       #期初库存数量(取值是取上月的库存期末结存)
         t08      LIKE type_file.num20_6     #分摊金额
                  END RECORD
DEFINE l_ac       LIKE type_file.num10
DEFINE g_success  LIKE type_file.chr1
DEFINE g_npp01    LIKE npp_file.npp01  #FUN-C50131
DEFINE g_cka00    LIKE cka_file.cka00  #FUN-C80092
DEFINE g_cka09    LIKE cka_file.cka09  #FUN-C80092
DEFINE g_aag44    LIKE aag_file.aag44   #FUN-D40118 add

MAIN 

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

    LET tm.yy = ARG_VAL(1)
    LET tm.mm = ARG_VAL(2)

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF

   #SELECT ccz01,ccz02 INTO g_ccz.ccz01,g_ccz.ccz02 FROM ccz_file
   # WHERE ccz00 = '0'
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err("未取得成本参数值(ccz01,ccz02):",SQLCA.SQLCODE,1)
   #   EXIT PROGRAM
   #END IF

    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

    OPEN WINDOW p100_w AT 0,0 WITH FORM "axc/42f/axcp100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    CALL cl_set_comp_visible("t06,t08",FALSE)

    #FUN-C50131---ADD--STR
    IF g_aza.aza63='Y' THEN
       CALL cl_set_act_visible("entry_sheet2",TRUE)
    ELSE
       CALL cl_set_act_visible("entry_sheet2",FALSE)
    END IF
    #FUN-C50131---ADD---END
    CALL p100_menu()
    CLOSE WINDOW p100_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
          RETURNING g_time

END MAIN
      
FUNCTION p100_menu()
   DEFINE l_nppglno LIKE npp_file.nppglno
    WHILE TRUE
        CALL p100_bp('G')
        CASE g_action_choice
            WHEN "query"
                IF cl_chk_act_auth() THEN
                    CALL p100_q()
                END IF
            WHEN "show_detail"
                IF cl_chk_act_auth() THEN
                   CALL p100_show_detail()
                END IF
            WHEN "refresh_mydata"
                IF cl_chk_act_auth() THEN
                   LET l_nppglno=''
                   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'   #FUN-C50131
                   SELECT nppglno  INTO l_nppglno FROM npp_file where npp01=g_npp01 AND npptype='0'  #FUN-C50131
                   IF cl_null (l_nppglno) THEN                                                        #FUN-C50131
                      LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm    #FUN-C80092
                      CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
                      CALL p100_refresh_mydata()
                   ELSE
                      CALL cl_err('','aim-162',0)
                   END IF                                                                              #FUN-C50131
                END IF 
            WHEN "transf"
                IF cl_chk_act_auth() THEN
                   LET l_nppglno='' 
                   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'   #FUN-C50131
                   SELECT nppglno  INTO l_nppglno FROM npp_file where npp01=g_npp01 AND npptype='0'  #FUN-C50131
                   IF cl_null (l_nppglno) THEN                                                       #FUN-C50131
                      CALL p100_transf()
                   ELSE
                      CALL cl_err('','aim-162',0)
                   END IF                                                                             #FUN-C50131
                END IF
            WHEN "retransf"
                IF cl_chk_act_auth() THEN
                   LET l_nppglno=''
                   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'   #FUN-C50131
                   SELECT nppglno  INTO l_nppglno FROM npp_file where npp01=g_npp01 AND npptype='0'  #FUN-C50131
                   IF cl_null (l_nppglno) THEN                                                       #FUN-C50131
                      CALL p100_retransf()
                    ELSE
                      CALL cl_err('','aim-162',0)
                   END IF                                                                             #FUN-C50131
                END IF
          #FUN-C50131---add---str
            WHEN "carry_voucher"
                IF cl_chk_act_auth() THEN
                   CALL p100_carry_voucher()
                END IF
            WHEN "undo_carry_voucher"
                IF cl_chk_act_auth() THEN
                   CALL p100_undo_carry_voucher()
                END IF
            WHEN "gen_entry"
                IF cl_chk_act_auth() THEN
                   CALL p100_gen_entry()
                END IF
            WHEN "entry_sheet"
                IF cl_chk_act_auth() THEN
                   IF cl_null(tm.yy) or cl_null(tm.mm) then   #FUN-C60065
                      call cl_err('',-400,1)                  #FUN-C60065
                   ELSE                                       #FUN-C60065
                      LET l_nppglno=''
                      LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
                      SELECT nppglno  INTO l_nppglno FROM npp_file where npp01=g_npp01 AND npptype='0'
                      IF cl_null (l_nppglno) THEN
                         CALL s_fsgl('CA',1,g_npp01,0,g_ccz.ccz12,'1','N','0',g_ccz.ccz11)
                      ELSE
                         CALL s_fsgl('CA',1,g_npp01,0,g_ccz.ccz12,'1','Y','0',g_ccz.ccz11)
                      END IF
                   END IF      #FUN-C60065
                END IF
             WHEN "entry_sheet2"
                IF cl_chk_act_auth() THEN
                   IF cl_null(tm.yy) or cl_null(tm.mm) then   #FUN-C60065
                      call cl_err('',-400,1)                  #FUN-C60065
                   ELSE                                       #FUN-C60065
                      LET l_nppglno=''
                      LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&' 
                      SELECT nppglno  INTO l_nppglno FROM npp_file where npp01=g_npp01 AND npptype='1'
                      IF cl_null (l_nppglno) THEN
                         CALL s_fsgl('CA',1,g_npp01,0,g_ccz.ccz121,'1','N','1',g_ccz.ccz11)
                      ELSE
                         CALL s_fsgl('CA',1,g_npp01,0,g_ccz.ccz121,'1','Y','1',g_ccz.ccz11)
                      END IF
                   END IF
                END IF    #FUN-C60065
          #FUN-C50131---add---end
            WHEN "help"
               CALL cl_show_help()
            WHEN "exit"
               EXIT WHILE
            WHEN "controlg"
               CALL cl_cmdask()
            WHEN "exporttoexcel"
               IF cl_chk_act_auth() THEN
                 IF g_tot.getLength() > 0 THEN 
                    CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tot),'','')
                 END IF 
               END IF
        END CASE
    END WHILE

END FUNCTION 

FUNCTION p100_tm()

    INITIALIZE tm TO NULL
    LET tm.yy = g_ccz.ccz01
    LET tm.mm = g_ccz.ccz02
    DISPLAY BY NAME tm.yy,tm.mm

    INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS

        BEFORE INPUT
            CALL cl_qbe_init()

        AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.mm > 12 OR tm.mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               ELSE
                  IF tm.mm > 13 OR tm.mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               END IF
            END IF
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

    END INPUT

END FUNCTION

FUNCTION p100_q()

    CALL p100_tm()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       LET tm.yy=''  #FUN-C60065
       LET tm.mm=''  #FUN-C60065
       RETURN 
    END IF 

    CALL p100_get_detail()
    IF g_success = 'N' THEN 
       CLEAR FORM
       LET tm.yy=''  #FUN-C60065
       LET tm.mm=''  #FUN-C60065
       CALL g_tot.clear()
       CALL cl_err('','axc-034',0)
       RETURN 
    END IF 
    
    CALL p100_show()
    IF g_success = 'N' THEN 
       CLEAR FORM 
       LET tm.yy=''  #FUN-C60065
       LET tm.mm=''  #FUN-C60065
       CALL g_tot.clear()
       CALL cl_err('','axc-034',0)
       RETURN 
    END IF 

END FUNCTION 

#取明细资料
FUNCTION p100_get_detail()
DEFINE l_cnt            LIKE type_file.num10
DEFINE i                LIKE type_file.num10
DEFINE l_apb            DYNAMIC ARRAY OF RECORD
         apa00          LIKE apa_file.apa00,      #账款类型
         apa01          LIKE apa_file.apa01,      #账款单号
         apa02          LIKE apa_file.apa02,      #账款日期
         apa14          LIKE apa_file.apa14,      #汇率
         apa72          LIKE apa_file.apa72,      #重估汇率
         apb02          LIKE apb_file.apb02,      #项次
         apb12          LIKE apb_file.apb12,      #料号
         apb29          LIKE apb_file.apb29,      #异动类型
         apb21          LIKE apb_file.apb21,      #入库单号
         apb22          LIKE apb_file.apb22,      #项次
         apb10          LIKE apb_file.apb10,      #本币金额
         apb09          LIKE apb_file.apb09,      #数量
         apb34          LIKE apb_file.apb34,      #暂估否
         apb08          LIKE apb_file.apb08
                        END RECORD
DEFINE l_cap         RECORD LIKE cap_file.*
DEFINE l_apb08          LIKE apb_file.apb08
DEFINE l_apb09          LIKE apb_file.apb09
DEFINE l_apb10          LIKE apb_file.apb10       #MOD-BC0024
DEFINE l_correct        LIKE type_file.chr1  #CHI-D10059
DEFINE l_bdate,l_edate  LIKE type_file.dat  #CHI-D10059
DEFINE l_apb24          LIKE apb_file.apb24 #No.MOD-D50148

    LET g_success = 'Y'
    CALL g_cap.clear()
    #查找当月明细档中是否已经有明细资料，如果有直接抓取明细资料
    SELECT COUNT(*) INTO l_cnt FROM cap_file 
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm   
    IF l_cnt > 0 THEN 
        
       DECLARE p100_get_detail_cs CURSOR FOR 
        SELECT * FROM cap_file 
         WHERE cap01 = tm.yy
           AND cap02 = tm.mm
       IF SQLCA.SQLCODE THEN 
          CALL cl_err('DECLARE p100_get_detail_cs:',SQLCA.SQLCODE,1)
          LET g_success = 'N'
          CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
          RETURN 
       END IF 
  
       LET i = 1
       FOREACH p100_get_detail_cs INTO g_cap[i].*
           
           LET i = i + 1

       END FOREACH
       CALL g_cap.deleteElement(i) 
       
       RETURN
    END IF 
    CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_bdate, l_edate  #CHI-D10059
    #若果没有明细档，则按照入库单及项次，抓取应付单。
    #抓取应付
    DECLARE p100_get_apa_cs CURSOR FOR 
     SELECT apa00,apa01,apa02,apa14,apa72,apb02,apb12,apb29,apb21,apb22,apb10,apb09,apb34,apb08 
       FROM apa_file,apb_file
      WHERE apa01 = apb01
       #AND apa00 = '11'             #应付账款  #TQC-AB0062
        AND apa00 IN ('11','21')     #应付账款  #TQC-AB0062
        #AND YEAR(apa02) = tm.yy      #年度  #CHI-D10059
        #AND MONTH(apa02)= tm.mm      #月份  #CHI-D10059
        AND apa02 BETWEEN l_bdate AND l_edate  #CHI-D10059
       #AND apb29 = '1'              #异动类型 1-入库  #TQC-AB0062
        AND apb29 IN ('1','3')       #异动类型 1-入库,3-仓退  #TQC-AB0062
        AND apb34 = 'Y'              #暂估否
        AND apa41 = 'Y'              #已确认
        AND apb12 != 'MISC'          #MOD-BC0024
      ORDER BY apa01,apb02
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('DECLARE p100_get_apa_cs:',SQLCA.SQLCODE,1)
       LET g_success = 'N'
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
       RETURN 
    END IF 

    
    CALL l_apb.clear()
    LET i = 1
    FOREACH p100_get_apa_cs INTO l_apb[i].*
        SELECT COUNT(*) INTO l_cnt FROM rvv_file
         WHERE rvv01=l_apb[i].apb21
           AND rvv02=l_apb[i].apb22
           AND rvv32 NOT IN (SELECT jce02 FROM jce_file)
        IF l_cnt = 0 THEN
           CONTINUE FOREACH
        END IF
        LET i = i + 1
    END FOREACH
    CALL l_apb.deleteElement(i)

    #以应付资料为基础，相继找出对应的暂估单，项次；入库数量
    FOR i = 1 TO l_apb.getLength()
        INITIALIZE l_cap TO NULL 
        LET l_cap.cap01 = tm.yy
        LET l_cap.cap02 = tm.mm
        LET l_cap.cap03 = l_apb[i].apb12  #产品编号
        LET l_cap.cap04 = l_apb[i].apa01  #账款编号
        LET l_cap.cap05 = l_apb[i].apb02  #项次
        LET l_cap.cap08 = l_apb[i].apb21  #入库单号
        LET l_cap.cap09 = l_apb[i].apb22  #项次
        LET l_cap.cap10 = l_apb[i].apb10  #本币金额
        LET l_cap.cap12 = l_apb[i].apa14  #汇率
        LET l_cap.cap14 = l_apb[i].apa72  #重估汇率
        LET l_cap.cap15 = 'N'
        LET l_cap.cap18 = l_apb[i].apb08
        
        #抓取暂估信息，原则上不应报错，如有报错应跟踪错误信息
        #SELECT apb01,apb02,apb08 INTO l_cap.cap06,l_cap.cap07,l_apb08  # l_cap.cap11 
        SELECT apb01,apb02,apb08,apb09,apb10,apb24 INTO l_cap.cap06,l_cap.cap07,l_apb08,l_apb09,l_apb10,l_apb24  #MOD-BC0024  #No.MOD-D50148 add apb24
          FROM apa_file,apb_file
         WHERE apa01 = apb01
          #AND apa00 = '16'              #应付账款 #TQC-AB0062
           AND apa00 IN ('16','26')      #应付账款 #TQC-AB0062
          #AND apb29 = '1'               #异动类型 1-入库 #TQC-AB0062
           AND apb29 IN ('1','3')        #异动类型 1-入库,3-仓退 #TQC-AB0062
           AND apb21 = l_cap.cap08 #入库单号
           AND apb22 = l_cap.cap09 #入库项次
           AND apa41 = 'Y'               #已确认
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('SELECT FROM apb_file(16):',SQLCA.SQLCODE,1)
           LET l_cap.cap06 = NULL
           LET l_cap.cap07 = NULL
           LET l_cap.cap11 = 0
        END IF 

        #LET l_cap.cap11 = l_apb08 * l_apb[i].apb09           #MOD-BC0024
#        LET l_cap.cap11 =  l_apb[i].apb09 * l_apb10/l_apb09   #MOD-BC0024
        LET l_cap.cap11 = l_apb[i].apa14*l_apb24*l_apb[i].apb09/l_apb09   #No.MOD-D50148 
        IF l_apb09 = 0 THEN LET l_cap.cap11 = l_apb08 * l_apb[i].apb09 END IF  #No.MOD-D20157 add  
        LET l_cap.cap11 = cl_digcut(l_cap.cap11,g_azi04)
        LET l_cap.cap19 = l_apb08
        
        #抓取入库数量，原则上不应该报错，若有报错，需跟踪错误。
        SELECT rvv17 INTO l_cap.cap13 FROM rvv_file 
         WHERE rvv01 = l_cap.cap08
           AND rvv02 = l_cap.cap09
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('SELECT rvv17:',SQLCA.SQLCODE,1)
           LET l_cap.cap13 = 0
        END IF 
        
        #插入到明细档中
        CALL g_cap.appendElement()
        LET g_cap[g_cap.getLength()].* = l_cap.*
    END FOR
    
    #将插入动作放入到事务当中，以便出错时不会有资料插入进表中。
    IF g_cap.getLength() > 0 THEN 
       BEGIN WORK 
       FOR i = 1 TO g_cap.getLength() 
           INSERT INTO cap_file VALUES(g_cap[i].*)
           IF SQLCA.SQLCODE THEN 
              LET g_success = 'N'
              CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
              RETURN 
           END IF 
       END FOR 
       IF g_success = 'N' THEN 
          CALL cl_err('INSERT INTO cap_file:',SQLCA.SQLCODE,1)
          ROLLBACK WORK
          CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
          RETURN 
       ELSE
          COMMIT WORK
          CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
       END IF  
    ELSE
       LET g_success = 'N'  #如果数组中没有资料，则直接退出，不要走显示程序
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
       RETURN 
    END IF 

END FUNCTION

#显示资料
FUNCTION p100_show()
DEFINE l_gen02          LIKE gen_file.gen02   
DEFINE l_tot_amount     LIKE type_file.num20_6
DEFINE i                LIKE type_file.num10
DEFINE l_nppglno        LIKE npp_file.nppglno  #FUN-C60034
    LET g_success = 'Y'
    INITIALIZE g_tot_h TO NULL
    INITIALIZE l_gen02 TO NULL

    SELECT DISTINCT cap15,cap16,cap17 
      INTO g_tot_h.cap15,g_tot_h.cap16,g_tot_h.cap17 
      FROM cap_file
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('SELECT FROM cap_file:',SQLCA.SQLCODE,1)
       LET g_success = 'N'
       RETURN 
    END IF
    DISPLAY BY NAME g_tot_h.cap15,g_tot_h.cap16,g_tot_h.cap17

    IF NOT cl_null(g_tot_h.cap16) THEN 
       SELECT gen02 INTO l_gen02 FROM gen_file 
        WHERE gen01 = g_tot_h.cap16
       IF SQLCA.SQLCODE THEN 
          LET l_gen02 = ''
       END IF 
    END IF 
    DISPLAY l_gen02 TO FORMONLY.gen02

    CALL p100_deal_data()
    IF g_success = 'N' THEN 
       RETURN 
    END IF 
    
    LET l_tot_amount = 0
    IF g_tot.getLength() > 0 THEN 
       FOR i = 1 TO g_tot.getLength()
          #LET l_tot_amount = l_tot_amount + g_tot[i].t08
           LET l_tot_amount = l_tot_amount + g_tot[i].t05
       END FOR
    END IF 
    DISPLAY l_tot_amount TO FORMONLY.tot_amount
    #FUN-C60034---ADD--STR
    LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
    SELECT nppglno INTO l_nppglno FROM npp_file
     where nppsys='CA' AND npp01=g_npp01 AND npp011=1 AND npp00=1 and npptype='0'
    DISPLAY l_nppglno TO nppglno
    #FUN-C60034--ADD--END
END FUNCTION 

#处理明细资料，汇总后插入到g_tot数组中以便显示
FUNCTION p100_deal_data()
DEFINE i                LIKE type_file.num10
DEFINE j                LIKE type_file.num10
DEFINE l_cap         RECORD LIKE cap_file.*
DEFINE l_cap03       LIKE cap_file.cap03
DEFINE l_yy             LIKE type_file.num5
DEFINE l_mm             LIKE type_file.num5
DEFINE l_cap10_s     LIKE cap_file.cap10
DEFINE l_cap11_s     LIKE cap_file.cap11
DEFINE l_cap13_s     LIKE cap_file.cap13
DEFINE l_cy             LIKE type_file.num20_6    #差异金额
DEFINE l_imk09       LIKE imk_file.imk09
DEFINE l_tlf10       LIKE tlf_file.tlf10
DEFINE l_azm02       LIKE azm_file.azm02  #CHI-D10059
DEFINE l_correct        LIKE type_file.chr1  #CHI-D10059
DEFINE l_bdate,l_edate  LIKE type_file.dat  #CHI-D10059
    
    LET g_success = 'Y'
    IF g_cap.getLength() = 0 THEN 
       LET g_success = 'N'
       RETURN 
    END IF 
   
    LET i = 0
    SELECT COUNT(DISTINCT cap03) INTO i FROM cap_file 
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm
    IF i = 0 THEN 
       LET g_success = 'N'
       RETURN 
    END IF 

    DECLARE p100_get_cap_cs CURSOR FOR 
     SELECT DISTINCT cap03 FROM cap_file WHERE cap01 = tm.yy AND cap02 = tm.mm ORDER BY cap03   #No.MOD-D10077 add order by cap03
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('DECLARE p100_get_cap_cs:',SQLCA.SQLCODE,1)
       LET g_success = 'N'
       RETURN 
    END IF

    CALL g_tot.clear()
    FOREACH p100_get_cap_cs INTO l_cap03 
        LET l_cap10_s = 0
        LET l_cap11_s = 0
        LET l_cy         = 0
        LET l_cap13_s = 0
        SELECT SUM(cap10),SUM(cap11),SUM(cap10-cap11),SUM(cap13) 
          INTO l_cap10_s,   #应付账款本币金额
               l_cap11_s,   #暂估账款本币金额
               l_cy,           #差异金额
               l_cap13_s    #入库数量
          FROM cap_file 
         WHERE cap01 = tm.yy
           AND cap02 = tm.mm
           AND cap03 = l_cap03
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('',SQLCA.SQLCODE,1)
           LET g_success  = 'N'
           EXIT FOREACH 
        END IF 
        
        IF l_cy = 0 THEN 
           CONTINUE FOREACH
        END IF 

        CALL g_tot.appendElement()
        LET g_tot[g_tot.getLength()].t01 = l_cap03
        
        LET g_tot[g_tot.getLength()].t02 = l_cap13_s
        LET g_tot[g_tot.getLength()].t03 = l_cap10_s
        LET g_tot[g_tot.getLength()].t04 = l_cap11_s
        LET g_tot[g_tot.getLength()].t05 = l_cy
#No.MOD-D70024 --begin
#        SELECT ima02,ima021,ima39 INTO g_tot[g_tot.getLength()].ima02,   #No.100326 add ,ima39
#                                       g_tot[g_tot.getLength()].ima021,  
#                                       g_tot[g_tot.getLength()].ima39    #No.100326 
#          FROM ima_file
#         WHERE ima01 = l_cap03
#        IF SQLCA.SQLCODE THEN 
#          LET g_tot[g_tot.getLength()].ima02 = ''
#          LET g_tot[g_tot.getLength()].ima021= ''
#          LET g_tot[g_tot.getLength()].ima39 = ''   #No.100326
#        END IF 

        SELECT ima02,ima021 INTO g_tot[g_tot.getLength()].ima02,   #No.100326 add ,ima39
                                       g_tot[g_tot.getLength()].ima021                                         
          FROM ima_file
         WHERE ima01 = l_cap03
        IF SQLCA.SQLCODE THEN 
          LET g_tot[g_tot.getLength()].ima02 = ''
          LET g_tot[g_tot.getLength()].ima021= ''
        END IF 

        LET g_tot[g_tot.getLength()].ima39 = ''  
        CASE WHEN g_ccz.ccz07='1' SELECT ima39 INTO g_tot[g_tot.getLength()].ima39 FROM ima_file
                                   WHERE ima01=l_cap03
             WHEN g_ccz.ccz07='2' SELECT imz39 INTO g_tot[g_tot.getLength()].ima39 FROM ima_file,imz_file
                                   WHERE ima01=l_cap03 AND ima06=imz01
#3,4是取仓库资料，这边没仓库
             OTHERWISE            SELECT ima39 INTO g_tot[g_tot.getLength()].ima39 FROM ima_file
                                   WHERE ima01=l_cap03 
        END CASE
#No.MOD-D70024 --end
       #No.100326--begin--
         IF NOT cl_null(g_tot[g_tot.getLength()].ima39) THEN 
            SELECT aag02 INTO g_tot[g_tot.getLength()].aag02 FROM aag_file 
             WHERE aag00 = g_aza.aza81 AND aag01 = g_tot[g_tot.getLength()].ima39   #No.MOD-D70020
#            WHERE aag00 = '00' AND aag01 = g_tot[g_tot.getLength()].ima39
            IF SQLCA.SQLCODE THEN 
               LET g_tot[g_tot.getLength()].aag02 = ''
            END IF 
         END IF 
       #No.100326---end---

        LET g_tot[g_tot.getLength()].t06 = g_tot[g_tot.getLength()].t05 / g_tot[g_tot.getLength()].t02 #差异单价
    
        #取得该料件上月期末结存数量
        IF tm.mm = 1 THEN 
           LET l_yy = tm.yy - 1
           #CHI-D10059---begin
           #LET l_mm = 12
           SELECT azm02 INTO l_azm02 FROM azm_file
                 WHERE azm01 = tm.yy
           IF l_azm02 = '1' THEN
              LET l_mm = 12
           ELSE 
              LET l_mm = 13
           END IF
           #CHI-D10059---end
        ELSE 
           LET l_yy = tm.yy
           LET l_mm = tm.mm - 1
        END IF 
      # SELECT ccc91 INTO g_tot[g_tot.getLength()].t07 FROM ccc_file
      #  WHERE ccc01 = l_cap03
      #    AND ccc02 = tm.yy
      #    AND ccc03 = tm.mm
      #    AND ccc07 = '1'
      #    AND ccc08 = ' ' 
     #  IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN 
     #     CALL cl_err('SELECT ccc91:',SQLCA.SQLCODE,1)
     #     LET g_success = 'N'
     #     RETURN 
     #  END IF 
     #  IF SQLCA.SQLCODE = 100 THEN 
     #     LET g_tot[g_tot.getLength()].t07 = 0
     #  END IF 
        SELECT SUM(imk09) INTO l_imk09 FROM imk_file   #No.MOD-D70086 imk09 -->SUM(imk09)
         WHERE imk01 = l_cap03
        #  AND imk05 = tm.yy
        #  AND imk06 = tm.mm - 1
           AND imk05 = l_yy
           AND imk06 = l_mm
           AND imk02 NOT IN (SELECT jce02 FROM jce_file)
           
        CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_bdate, l_edate  #CHI-D10059 
        SELECT SUM(tlf10) INTO l_tlf10 FROM tlf_file
         WHERE tlf01 = l_cap03
           AND tlf907 = 1
           #AND YEAR(tlf06)=tm.yy  #CHI-D10059
           #AND MONTH(tlf06)=tm.mm  #CHI-D10059
           AND tlf06 BETWEEN l_bdate AND l_edate  #CHI-D10059
           AND tlf902 NOT IN (SELECT jce02 FROM jce_file)
        IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF
        IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF
        LET g_tot[g_tot.getLength()].t07 = l_imk09 + l_tlf10

        #计算分摊的金额
      # LET g_tot[g_tot.getLength()].t08 = g_tot[g_tot.getLength()].t06 * g_tot[g_tot.getLength()].t07
        LET g_tot[g_tot.getLength()].t08 = g_tot[g_tot.getLength()].t05 

        LET g_tot[g_tot.getLength()].t08 = cl_digcut(g_tot[g_tot.getLength()].t08,g_azi04)
        
    END FOREACH 
    IF g_success = 'N' THEN 
       RETURN 
    END IF 

END FUNCTION 

#删除明细档中的资料，有返回值，Y-表示删除成功 ；N-表示删除失败
FUNCTION p100_del()
    DELETE FROM cap_file WHERE cap01 = tm.yy AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('DELETE FROM cap_file:',SQLCA.SQLCODE,1)
       RETURN 'N'
    END IF 
    RETURN 'Y'

END FUNCTION 

#刷新资料--仅当没有进行抛转axct002的情况下，才能做重新刷新。
FUNCTION p100_refresh_mydata()
DEFINE l_cap15       LIKE cap_file.cap15

    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end
   
    IF g_tot.getLength() = 0 THEN 
       RETURN 
    END IF 

    SELECT DISTINCT cap15 INTO l_cap15 FROM cap_file 
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err("SELECT cap15:",SQLCA.SQLCODE,1)
       RETURN 
    END IF 
    IF l_cap15 = 'Y' THEN 
    ELSE
       IF p100_del() = 'N' THEN 
          RETURN 
       END IF 
    END IF


    CALL p100_get_detail()
    IF g_success = 'N' THEN 
       CLEAR FORM
       CALL cl_err('','axc-034',0)
       RETURN 
    END IF 
    
    CALL p100_show()
    IF g_success = 'N' THEN 
       CLEAR FORM 
       CALL cl_err('','axc-034',0)
       RETURN 
    END IF 
    
#   CALL cl_err("数据已更新","!",0)
    CALL cl_err('','9062',0)

END FUNCTION 

FUNCTION p100_bp(p_ud)
DEFINE p_ud       LIKE type_file.chr1

   IF p_ud <> "G"  THEN
      RETURN
   END IF

   
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tot TO s_tot.* ATTRIBUTE(COUNT=g_tot.getLength())

      BEFORE DISPLAY
         CALL cl_navigator_setting(0,0)
         DISPLAY g_tot.getLength() TO FORMONLY.cnt

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         DISPLAY l_ac TO FORMONLY.cn

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION show_detail
         IF l_ac > 0 THEN
            LET g_action_choice="show_detail"
            EXIT DISPLAY
         ELSE                              #FUN-C60065
           CALL cl_err('',-400,1)          #FUN-C60065
         END IF

      #重新抓取数据
      ON ACTION refresh_mydata
         LET g_action_choice = "refresh_mydata"
         EXIT DISPLAY

      ON ACTION transf
         LET g_action_choice = "transf"
         EXIT DISPLAY

      ON ACTION retransf
         LET g_action_choice = "retransf"
         EXIT DISPLAY

     #FUN-C50131---ADD---STR
      ON ACTION carry_voucher
         LET g_action_choice = "carry_voucher"
         EXIT DISPLAY
      
      ON ACTION undo_carry_voucher
         LET g_action_choice = "undo_carry_voucher"
         EXIT DISPLAY
      
      ON ACTION gen_entry

         LET g_action_choice = "gen_entry"
         EXIT DISPLAY
      
      ON ACTION entry_sheet
         LET g_action_choice = "entry_sheet"
         EXIT DISPLAY
 
      ON ACTION entry_sheet2
         LET g_action_choice = "entry_sheet2"
         EXIT DISPLAY

     #FUN-C50131---ADD---END

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
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

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION p100_show_detail()
DEFINE l_cap    DYNAMIC ARRAY OF RECORD 
         cap01  LIKE cap_file.cap01,
         cap02  LIKE cap_file.cap02,
         cap03  LIKE cap_file.cap03,
         ima02     LIKE ima_file.ima02,
         ima021    LIKE ima_file.ima021,
         cap04  LIKE cap_file.cap04,
         cap05  LIKE cap_file.cap05,
         cap06  LIKE cap_file.cap06,
         cap07  LIKE cap_file.cap07,
         cap08  LIKE cap_file.cap08,
         cap09  LIKE cap_file.cap09,
         cap18  LIKE cap_file.cap18,
         cap10  LIKE cap_file.cap10,
         cap19  LIKE cap_file.cap19,
         cap11  LIKE cap_file.cap11,
         cap12  LIKE cap_file.cap12,
         cap13  LIKE cap_file.cap13,
         cap14  LIKE cap_file.cap14,
         cap15  LIKE cap_file.cap15,
         cap16  LIKE cap_file.cap16,
         cap17  LIKE cap_file.cap17
                   END RECORD
DEFINE i           LIKE type_file.num10
DEFINE l_tot_cap10 LIKE cap_file.cap10
DEFINE l_tot_cap11 LIKE cap_file.cap11
DEFINE l_tot_cap13 LIKE cap_file.cap13

    IF g_cap.getLength() = 0 OR g_tot.getLength() = 0 THEN 
       CALL cl_err('',-400,1)    #FUN-C60065---ADD
       RETURN 
    END IF 


    CALL l_cap.clear()

    FOR i = 1 TO g_cap.getLength()
        IF g_tot[l_ac].t01 = g_cap[i].cap03 THEN 
           CALL l_cap.appendElement()
           LET l_cap[l_cap.getLength()].cap01 = g_cap[i].cap01 
           LET l_cap[l_cap.getLength()].cap02 = g_cap[i].cap02
           LET l_cap[l_cap.getLength()].cap03 = g_cap[i].cap03
           LET l_cap[l_cap.getLength()].cap04 = g_cap[i].cap04
           LET l_cap[l_cap.getLength()].cap05 = g_cap[i].cap05
           LET l_cap[l_cap.getLength()].cap06 = g_cap[i].cap06
           LET l_cap[l_cap.getLength()].cap07 = g_cap[i].cap07
           LET l_cap[l_cap.getLength()].cap08 = g_cap[i].cap08
           LET l_cap[l_cap.getLength()].cap09 = g_cap[i].cap09
           LET l_cap[l_cap.getLength()].cap18 = g_cap[i].cap18
           LET l_cap[l_cap.getLength()].cap10 = g_cap[i].cap10
           LET l_cap[l_cap.getLength()].cap19 = g_cap[i].cap19
           LET l_cap[l_cap.getLength()].cap11 = g_cap[i].cap11
           LET l_cap[l_cap.getLength()].cap12 = g_cap[i].cap12
           LET l_cap[l_cap.getLength()].cap13 = g_cap[i].cap13
           LET l_cap[l_cap.getLength()].cap14 = g_cap[i].cap14
           LET l_cap[l_cap.getLength()].cap15 = g_cap[i].cap15
           LET l_cap[l_cap.getLength()].cap16 = g_cap[i].cap16
           LET l_cap[l_cap.getLength()].cap17 = g_cap[i].cap17
           SELECT ima02,ima021 INTO l_cap[l_cap.getLength()].ima02,l_cap[l_cap.getLength()].ima021 
             FROM ima_file
            WHERE ima01 = l_cap[l_cap.getLength()].cap03
           IF SQLCA.SQLCODE THEN 
              LET l_cap[l_cap.getLength()].ima02 = ''
              LET l_cap[l_cap.getLength()].ima021= ''
           END IF 
        END IF 
    END FOR
    
    IF l_cap.getLength() = 0 THEN 
       RETURN
    END IF
    LET l_tot_cap10 = 0
    LET l_tot_cap11 = 0
    LET l_tot_cap13 = 0
    FOR i = 1 TO l_cap.getLength()
        LET l_tot_cap10 = l_tot_cap10 + l_cap[i].cap10
        LET l_tot_cap11 = l_tot_cap11 + l_cap[i].cap11
        LET l_tot_cap13 = l_tot_cap13 + l_cap[i].cap13
    END FOR 
          

   OPEN WINDOW p100_1_w AT 0,0 WITH FORM "axc/42f/axcp100_1"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()

   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY l_cap TO s_cap.* ATTRIBUTE(COUNT=l_cap.getLength())

       BEFORE DISPLAY
          CALL cl_navigator_setting(0,0)
          DISPLAY l_tot_cap10 TO FORMONLY.tot_cap10
          DISPLAY l_tot_cap11 TO FORMONLY.tot_cap11
          DISPLAY l_tot_cap13 TO FORMONLY.tot_cap13
          DISPLAY l_cap.getLength() TO FORMONLY.cnt

       BEFORE ROW
          LET i = ARR_CURR()
          CALL cl_show_fld_cont()
          DISPLAY i TO FORMONLY.cn

       AFTER DISPLAY
          CONTINUE DISPLAY

       
       ON ACTION exporttoexcel
          IF l_cap.getLength() > 0 THEN 
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_cap),'','')           
          END IF 

       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY

       ON ACTION controlg
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


    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)

    CLOSE WINDOW p100_1_w

END FUNCTION 

#将资料抛转到axct002材料费用中
FUNCTION p100_transf()
DEFINE l_cap15       LIKE cap_file.cap15
DEFINE l_cap16       LIKE cap_file.cap16
DEFINE l_cap17       LIKE cap_file.cap17
DEFINE i                LIKE type_file.num10
DEFINE l_success        LIKE type_file.chr1
DEFINE l_ccb            RECORD LIKE ccb_file.*
DEFINE l_msg            STRING
DEFINE g_t           LIKE type_file.chr1
DEFINE l_count       LIKE type_file.num5

    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end

    IF g_tot.getLength() = 0 THEN 
       RETURN
    END IF 

   OPEN WINDOW p100_2_w AT 0,0 WITH FORM "axc/42f/axcp100_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axcp100_2")
   
    LET g_t = '1'
    DISPLAY BY NAME g_t

    INPUT BY NAME g_t WITHOUT DEFAULTS

        BEFORE INPUT
            CALL cl_qbe_init()

        AFTER FIELD g_t
          IF g_t IS NOT NULL THEN
            IF g_t NOT MATCHES '[12345]' THEN
               NEXT FIELD g_t
            END IF
          END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION exit  
            LET INT_FLAG = 1
            EXIT INPUT

    END INPUT
 
    IF INT_FLAG THEN CLOSE WINDOW p100_2_w RETURN END IF
    CLOSE WINDOW p100_2_w
    
    SELECT DISTINCT cap15 INTO l_cap15 FROM cap_file 
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('SQL ERROR FOR sel cap15:',SQLCA.SQLCODE,1)
       RETURN 
    END IF 
    IF l_cap15 = 'Y' THEN 
#      CALL cl_err('已处理，不可再抛转','!',1)
       LET l_count = 0
       SELECT COUNT(*) INTO l_count
         FROM ccb_file
        WHERE ccb02 = tm.yy
          AND ccb03 = tm.mm
          AND ccb04 LIKE 'axcp100%'
          AND ccb06 = g_t
          AND ccb07 = ' '
       IF l_count >0  THEN     
          CALL cl_err('','axc-706',1)
          RETURN
       END IF    
    END IF 

#   IF NOT cl_prompt(0,0,"抛转前请务必确认数据已正确，分摊金额为零的请手动调整!是否继续?") THEN
    CALL cl_getmsg('axc-707',g_lang) RETURNING l_msg
    IF NOT cl_prompt(0,0,l_msg) THEN 
       RETURN 
    END IF    

    LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";type='",g_t CLIPPED,"'"    #FUN-C80092
    CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
    LET l_success = 'Y'
    BEGIN WORK
    FOR i = 1 TO g_tot.getLength()
        #No.MOD-C30019  --Begin
        #IF g_tot[i].t07 = 0 THEN 
        #   CONTINUE FOR
        #END IF
        #No.MOD-C30019  --End
        INITIALIZE l_ccb TO NULL 
        LET l_ccb.ccb01 = g_tot[i].t01
        LET l_ccb.ccb02 = tm.yy
        LET l_ccb.ccb03 = tm.mm
        LET l_ccb.ccb04 = "axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
        LET l_ccb.ccb05 = cl_getmsg('axc-910',g_lang)
        LET l_ccb.ccb06 = g_t
        LET l_ccb.ccb07 = ' '
       #LET l_ccb.ccb22a= g_tot[i].t08
        LET l_ccb.ccb22a= g_tot[i].t05
        LET l_ccb.ccb22b= 0
        LET l_ccb.ccb22c= 0
        LET l_ccb.ccb22d= 0
        LET l_ccb.ccb22e= 0
        LET l_ccb.ccb22f= 0
        LET l_ccb.ccb22g= 0
        LET l_ccb.ccb22h= 0
       #LET l_ccb.ccb22 = g_tot[i].t08
        LET l_ccb.ccb22 = g_tot[i].t05
        LET l_ccb.ccbacti = 'Y'
        LET l_ccb.ccbuser = g_user
        LET l_ccb.ccbgrup = g_clas
        LET l_ccb.ccblegal= g_legal
        LET l_ccb.ccb23 = '2'
        INSERT INTO ccb_file VALUES(l_ccb.*)
        IF SQLCA.SQLCODE THEN 
           LET l_success = 'N'
           EXIT FOR
        END IF 
    END FOR 
    IF l_success = 'N' THEN 
       CALL cl_err('INSERT INTO ccb_file:',SQLCA.SQLCODE,1)
       ROLLBACK WORK 
#      MESSAGE "数据抛转失败!"
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
       CALL cl_getmsg('axc-708',g_lang) RETURNING l_msg                                                                                                                                                 
       MESSAGE l_msg       
       RETURN 
    END IF 

    UPDATE cap_file SET cap15 = 'Y',cap16 = g_user,cap17=g_today
     WHERE cap01 = tm.yy AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('UPDATE cap_file:',SQLCA.SQLCODE,1)
       ROLLBACK WORK 
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
#      MESSAGE "数据抛转失败!"
       CALL cl_getmsg('axc-708',g_lang) RETURNING l_msg                                                                                                                                                 
       MESSAGE l_msg       
       RETURN 
    END IF
    COMMIT WORK 
    CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
    CALL p100_refresh_mydata()
#   MESSAGE "数据抛转成功!"
    CALL cl_getmsg('axc-709',g_lang) RETURNING l_msg                                                                                                                                                 
    MESSAGE l_msg
    
END FUNCTION 

#抛转还原
FUNCTION p100_retransf()
DEFINE l_cap15       LIKE cap_file.cap15
DEFINE l_msg            STRING
DEFINE g_t           LIKE type_file.chr1
DEFINE l_count       LIKE type_file.num5


    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end

    IF g_tot.getLength() = 0 THEN 
       RETURN 
    END IF 
   
    SELECT DISTINCT cap15 INTO l_cap15 FROM cap_file 
     WHERE cap01 = tm.yy
       AND cap02 = tm.mm
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('sel cap15 from cap_file:',SQLCA.SQLCODE,1)
       RETURN 
    END IF 
    
    IF l_cap15 = 'N' OR cl_null(l_cap15) THEN
       CALL cl_err('','axm-077','1') 
       RETURN 
    END IF

   OPEN WINDOW p100_3_w AT 0,0 WITH FORM "axc/42f/axcp100_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axcp100_2")
   
    LET g_t = '1'
    DISPLAY BY NAME g_t

    INPUT BY NAME g_t WITHOUT DEFAULTS

        BEFORE INPUT
            CALL cl_qbe_init()

        AFTER FIELD g_t
          IF g_t IS NOT NULL THEN
            IF g_t NOT MATCHES '[12345]' THEN
               NEXT FIELD g_t
            END IF
          END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION exit  
            LET INT_FLAG = 1
            EXIT INPUT

    END INPUT
 
    IF INT_FLAG THEN CLOSE WINDOW p100_3_w RETURN END IF
    CLOSE WINDOW p100_3_w 

    IF l_cap15 = 'Y' THEN 
       LET l_count = 0
       SELECT COUNT(*) INTO l_count
         FROM ccb_file
        WHERE ccb02 = tm.yy
          AND ccb03 = tm.mm
          AND ccb04 LIKE 'axcp100%'
          AND ccb06 = g_t
          AND ccb07 = ' '
       IF l_count = 0  THEN     
          CALL cl_err('','axc-918',1)
          CLOSE WINDOW p100_3_w
          RETURN
       END IF    
    END IF

    LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";type='",g_t CLIPPED,"'"    #FUN-C80092
    CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
    BEGIN WORK 
    DELETE FROM ccb_file WHERE ccb02 = tm.yy AND ccb03 = tm.mm AND ccb04 LIKE 'axcp100-%' AND ccb06 = g_t
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('DELETE FROM ccb_file:',SQLCA.SQLCODE,1)
       ROLLBACK WORK 
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
#      MESSAGE "数据还原失败!"
       CALL cl_getmsg('axc-710',g_lang) RETURNING l_msg                                                                                                                                                 
       MESSAGE l_msg       
       RETURN 
    END IF
    
    LET l_count = 0
    SELECT COUNT(*) INTO l_count
      FROM ccb_file
     WHERE ccb02 = tm.yy
       AND ccb03 = tm.mm
       AND ccb04 LIKE 'axcp100%'   
    IF l_count = 0  THEN
       UPDATE cap_file SET cap15 = 'N',cap16 = g_user,cap17=g_today
        WHERE cap01 = tm.yy AND cap02 = tm.mm
    END IF 
    IF SQLCA.SQLCODE THEN 
       CALL cl_err('UPDATE cap_file:',SQLCA.SQLCODE,1)
       ROLLBACK WORK 
       CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
#      MESSAGE "数据还原失败!"
       CALL cl_getmsg('axc-710',g_lang) RETURNING l_msg                                                                                                                                                 
       MESSAGE l_msg       
       RETURN 
    END IF
    COMMIT WORK 
    CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
    CALL p100_refresh_mydata()
#   MESSAGE "数据还原成功!"
    CALL cl_getmsg('axc-711',g_lang) RETURNING l_msg                                                                                                                                                 
    MESSAGE l_msg  
END FUNCTION 
#FUN-A70112

#FUN-C50131--------ADD---------STR
FUNCTION p100_carry_voucher()
DEFINE l_wc         string
DEFINE l_str        string
DEFINE l_n,i          LIKE type_file.num5
DEFINE l_nppglno    LIKE npp_file.nppglno
DEFINE l_npp03      LIKE npp_file.npp03
DEFINE l_npp01      LIKE npp_file.npp01
   IF s_shut(0) THEN
      RETURN
    END IF

   IF NOT cl_null(g_tot_h.cap15) THEN
      IF g_tot_h.cap15 <> 'Y' THEN
         CALL cl_err(g_tot_h.cap15,'axc-014',1)
         RETURN
      END IF
   END IF
   
   IF cl_null(tm.yy) or cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
      CALL cl_err ('',-400,1)
      RETURN
   END IF
   
   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
   SELECT nppglno INTO l_nppglno  FROM npp_file  where npp01=g_npp01 AND npptype='0'
   IF NOT cl_null(l_nppglno) THEN
      CALL cl_err('','aap-991',1) 
      RETURN
   END IF
   
   SELECT npp01 INTO l_npp01 FROM npp_file WHERE npp01=g_npp01 AND npptype='0'
   IF cl_null(l_npp01) THEN
      CALL cl_err('','anm-322',1)
      RETURN
   END IF

   LET l_wc = "axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
   LET l_str="axcp301 '",l_wc CLIPPED,"' '",g_ccz.ccz11,"' '",g_ccz.ccz12,"' '' '",g_ccz.ccz121,"' '' 'N'"
   CALL cl_cmdrun_wait(l_str)

   LET l_nppglno=''
   LET l_npp03=''  
   SELECT nppglno,npp03 INTO l_nppglno,l_npp03
   FROM npp_file  WHERE nppsys='CA' AND npp01=g_npp01 AND npp011=1 AND npp00=1 AND npptype='0'
   DISPLAY l_nppglno TO nppglno
   DISPLAY l_npp03 TO npp03
END FUNCTION

FUNCTION p100_undo_carry_voucher()
DEFINE li_str        string
DEFINE l_nppglno    LIKE npp_file.nppglno
DEFINE l_nppglno1    LIKE npp_file.nppglno
DEFINE l_npp03      LIKE npp_file.npp03
   IF s_shut(0) THEN
      RETURN
    END IF

    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end

   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
   SELECT nppglno INTO l_nppglno  FROM npp_file  where npp01=g_npp01 AND npptype='0'
   IF cl_null(l_nppglno) THEN
      CALL cl_err('0','aap-619',1)
      RETURN
   END IF

   SELECT nppglno INTO l_nppglno1  FROM npp_file  where npp01=g_npp01 AND npptype='1'
   IF cl_null(l_nppglno) THEN
      CALL cl_err('1','aap-619',1)
      RETURN
   END IF

   IF NOT cl_confirm('aap-988') THEN RETURN END IF
   LET li_str="axcp302 '",g_ccz.ccz11,"' '",g_ccz.ccz12,"' '",l_nppglno,"' 'Y' '",g_ccz.ccz121,"' '",l_nppglno1,"'"
   CALL cl_cmdrun_wait(li_str)
   
   SELECT nppglno,npp03 INTO l_nppglno,l_npp03
   FROM npp_file  WHERE nppsys='CA' AND npp01=g_npp01 AND npp011=1 AND npp00=1 AND npptype='0'
   DISPLAY l_nppglno TO nppglno
   DISPLAY l_npp03 TO npp03
END FUNCTION 

FUNCTION p100_gen_entry()
   DEFINE l_n LIKE type_file.num5
  
    IF s_shut(0) THEN
      RETURN
    END IF
    
    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end
    
    IF NOT cl_null(g_tot_h.cap15) THEN
       IF g_tot_h.cap15 <> 'Y' THEN
          CALL cl_err(g_tot_h.cap15,'axc-014',1)
          RETURN
       END IF
    END IF
      
    #判斷已拋轉傳票不可再產生
   LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = g_npp01  AND nppglno IS NOT NULL
      AND npp00 = 1        AND nppsys = 'CA'
      AND npp011= 1
   IF l_n > 0 THEN
      CALL cl_err('sel npp','aap-122',1)
      RETURN
   END IF

    LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm    #FUN-C80092
    CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
    BEGIN WORK
    LET g_success='Y'
    IF cl_confirm('axr-309') THEN
       LET g_npp01="axcp100-",tm.yy USING '&&&&',tm.mm USING '&&'
       CALL s_showmsg_init()#FUN-C60016
       CALL p100_g_gl(g_npp01,'0')
       IF g_aza.aza63='Y' THEN
          CALL p100_g_gl(g_npp01,'1')
       END IF
        IF g_success='Y'  THEN
           COMMIT WORK
           CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
        ELSE
          ROLLBACK WORK
          CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
          CALL s_showmsg()    #FUN-C60016
        END IF
   END IF
END FUNCTION

FUNCTION p100_g_gl(p_npp01,p_npptype)
   DEFINE p_npp01       LIKE npp_file.npp01
   DEFINE p_npptype     LIKE npp_file.npptype   
   DEFINE g_npptype     LIKE npp_file.npptype
   DEFINE l_n           LIKE type_file.num5 	

    #FUN-C60065---ADD--STR
    IF cl_null(tm.yy) OR cl_null(tm.mm) or tm.yy IS NULL or tm.mm IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-C60065---ADD--end

   WHENEVER ERROR CONTINUE
   IF p_npp01 IS NULL THEN RETURN END IF
   LET g_npptype = p_npptype 

   #判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_npp01  AND nppglno IS NOT NULL   
      AND npp00 = 1        AND nppsys = 'CA'
      AND npp011= 1
      AND npptype = g_npptype     
   IF l_n > 0 THEN
      CALL cl_err('sel npp','aap-122',1)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = p_npp01 AND npq00= 1
                                            AND npqsys = 'CA'   AND npq011=1
                                            AND npqtype = g_npptype     
   IF l_n > 0 THEN
      IF g_npptype='0' THEN
         IF NOT s_ask_entry(p_npp01) THEN RETURN END IF 
      END IF
   END IF
   DELETE FROM npp_file WHERE npp01 = p_npp01  AND npp00 =1 
                          AND nppsys = 'CA'  AND npp011= 1
                          AND npptype = g_npptype     

   DELETE FROM npq_file WHERE npq01 = p_npp01 AND npq00 = 1
                          AND npqsys = 'CA'   AND npq011=1
                          AND npqtype = g_npptype    
   CALL p100_gl_1(p_npp01,p_npptype)
END FUNCTION

FUNCTION p100_gl_1(p_npp01,p_npptype)
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE p_npq    RECORD LIKE npq_file.*
   DEFINE l_ima39         LIKE ima_file.ima39
   DEFINE l_cap03         LIKE cap_file.cap03
   DEFINE l_cap04         LIKE cap_file.cap04
   DEFINE l_aps44         LIKE aps_file.aps44
   DEFINE l_sql           STRING
   DEFINE l_apa22         LIKE apa_file.apa22
   DEFINE p_npp01         LIKE npp_file.npp01
   DEFINE p_npptype       LIKE npp_file.npptype
   DEFINE i               LIKE type_file.num5
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_apz13         LIKE apz_file.apz13
   DEFINE l_correct       LIKE type_file.chr1  #CHI-D10059
   DEFINE l_bdate,l_edate LIKE type_file.dat  #CHI-D10059
   DEFINE l_flag          LIKE type_file.chr1    #FUN-D40118 add
   DEFINE l_aag05         LIKE aag_file.aag05   #No.MOD-D70024
#No.MOD-D80008 --begin
   DEFINE l_amt_d         LIKE npq_file.npq07
   DEFINE l_amt_c         LIKE npq_file.npq07
#No.MOD-D80008 --end
   
   SELECT apz13 INTO l_apz13 FROM apz_file
   DROP TABLE X
   SELECT * FROM npq_file where 1=2 INTO TEMP X
   BEGIN WORK
   LET g_success = 'Y'
   #分錄單頭
    LET l_npp.nppsys = 'CA'
    LET l_npp.npp00  = 1
    LET l_npp.npp01  = p_npp01
    LET l_npp.npp011 = 1
    #LET l_npp.npp02  = g_today  #CHI-D10059
    CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_bdate, l_edate  #CHI-D10059
    LET l_npp.npp02  =  l_edate   #CHI-D10059
    LET l_npp.npp03  = NULL
    
    LET l_npp.npp06  = g_ccz.ccz11
    IF p_npptype='0'THEN
       LET l_npp.npp07  = g_ccz.ccz12
    ELSE
       LET l_npp.npp07  = g_ccz.ccz121
    END IF
    LET l_npp.nppglno= null
    LET l_npp.npptype= p_npptype              
    LET l_npp.npplegal=g_legal
  
    INSERT INTO npp_file VALUES (l_npp.*)
    IF SQLCA.sqlcode THEN
        CALL s_errmsg('npp_file','insert',p_npp01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF

   IF g_success ='Y' THEN 
#No.MOD-D80008 --begin
#借方
      LET l_sql="SELECT cap03,SUM(cap10-cap11) FROM cap_file ",
                " WHERE cap01 = '",tm.yy,"'",
                "   AND cap02 = '",tm.mm,"'",
                "   AND cap10 - cap11 <> 0 ",        #No.MOD-D10077
                " GROUP BY cap03",
                " ORDER BY cap03 "                   #No.MOD-D10077
      PREPARE p100_prepare2 FROM l_sql   
      DECLARE p100_curs2  CURSOR FOR p100_prepare2
#贷方
      LET l_sql="SELECT cap03,cap04,SUM(cap10-cap11) FROM cap_file ",
                " WHERE cap01 = '",tm.yy,"'",
                "   AND cap02 = '",tm.mm,"'",
                "   AND cap10 - cap11 <> 0 ",        #No.MOD-D10077
                " GROUP BY cap03,cap04",
                " ORDER BY cap03,cap04 "                   #No.MOD-D10077
      PREPARE p100_prepare1 FROM l_sql   
      DECLARE p100_curs1  CURSOR FOR p100_prepare1
#No.MOD-D80008 --end

#No.MOD-D70024 --begin
#      IF p_npptype='0' THEN
#         LET l_sql="SELECT ima39 FROM ima_file ",
#                  " WHERE ima01 = ?"
#      ELSE
#         LET l_sql="SELECT ima391 FROM ima_file ",
#                   " WHERE ima01 = ?"
#      END IF

      IF g_ccz.ccz07 ='2' THEN
         IF p_npptype='0' THEN
            LET l_sql="SELECT imz39 FROM ima_file,imz_file ",
                      " WHERE ima01 = ?  AND ima06=imz01 "
         ELSE
            LET l_sql="SELECT imz391 FROM ima_file,imz_file ",
                      " WHERE ima01 = ?  AND ima06=imz01 "
         END IF
      ELSE
         IF p_npptype='0' THEN
            LET l_sql="SELECT ima39 FROM ima_file ",
                      " WHERE ima01 = ? "
         ELSE
            LET l_sql="SELECT ima391 FROM ima_file ",
                      " WHERE ima01 = ? "
         END IF
      END IF
#No.MOD-D70024 --end
  
      PREPARE p100_prep1 FROM l_sql
      DECLARE p100_cs1 CURSOR FOR p100_prep1
  
      LET i=1 
#No.MOD-D80008 --begin
#借方独立一个FOREACH，不用分单号明细
   FOREACH p100_curs2 INTO l_cap03,l_amt_d    #No.MOD-D80008 add l_amt_c
#No.MOD-D80008 --begin
#      FOREACH p100_cs1 USING l_cap03 INTO l_ima39  
         LET l_ima39 = NULL
         OPEN p100_cs1 USING l_cap03
         FETCH p100_cs1 INTO l_ima39 
         CLOSE p100_cs1  
#No.MOD-D80008 --end
      #借方
         LET l_npq.npqsys='CA'
         LET l_npq.npq00=1
         LET l_npq.npq01=g_npp01
         LET l_npq.npq011=1 
         SELECT max(npq02)+1 INTO l_npq.npq02 FROM npq_file
          WHERE npq01 = g_npp01 
         IF l_npq.npq02 IS NULL THEN
            LET l_npq.npq02 = 1
         END IF
         LET l_npq.npq03=l_ima39
         LET l_npq.npq04=''
#No.MOD-D70024 --bebin
#     LET l_npq.npq05=''
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_npp.npp07 AND aag01 = l_npq.npq03
         IF l_aag05 = 'Y' THEN 
            LET l_npq.npq05=g_ccz.ccz23
         ELSE 
            LET l_npq.npq05=''
         END IF 
#No.MOD-D70024 --end 
         LET l_npq.npq06='1'    #借 
#No.MOD-D80008 --begin
#         LET l_npq.npq07f=g_tot[i].t05
#         LET l_npq.npq07 =g_tot[i].t05
         LET l_npq.npq07f= l_amt_d
         LET l_npq.npq07 = l_amt_d
#No.MOD-D80008 --end
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,g_azi04)   		
         LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  		
         LET l_npq.npq08 = NULL	
         LET l_npq.npq11 = ' '	
         LET l_npq.npq12 = ' '	
         LET l_npq.npq13 = ' '	
         LET l_npq.npq14 = ' '	
         LET l_npq.npq15 = NULL	
         LET l_npq.npq21 = NULL	
         LET l_npq.npq22 = NULL	
         LET l_npq.npq24 = g_aza.aza17	
         LET l_npq.npq25 = 1	
         LET l_npq.npq30 = l_npp.npp06	
         LET l_npq.npq31 = ' '	
         LET l_npq.npq32 = ' '	
         LET l_npq.npq33 = ' '	
         LET l_npq.npq34 = ' '	
         LET l_npq.npq35 = ' '	
         LET l_npq.npq36 = ' '	
         LET l_npq.npq37 = ' '	
         LET l_npq.npqtype = l_npp.npptype	
         LET l_npq.npqlegal =l_npp.npplegal	
         IF NOT cl_null(l_npq.npq07f) THEN  #FUN-C60016
           INSERT INTO X VALUES(l_npq.*)
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('temp','insert1',p_npp01,SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF                      
         END IF                             #FUN-C60016
         LET i=i+1
#      END FOREACH        No.MOD-D80008 mark
   END FOREACH 
#No.MOD-D80008 --end
      
   FOREACH p100_curs1 INTO l_cap03,l_cap04,l_amt_c 
#No.MOD-D80008 --begin
# FOREACH p100_cs1 USING l_cap03 INTO l_ima39   
#No.MOD-D80008 --begin
#借方独立一个FOREACH，不用分单号明细
#      #借方
#      LET l_npq.npqsys='CA'
#      LET l_npq.npq00=1
#      LET l_npq.npq01=g_npp01
#      LET l_npq.npq011=1 
#     SELECT max(npq02)+1 INTO l_npq.npq02 FROM npq_file
#      WHERE npq01 = g_npp01 
#     IF l_npq.npq02 IS NULL THEN
#        LET l_npq.npq02 = 1
#     END IF
#     LET l_npq.npq03=l_ima39
#     LET l_npq.npq04=''
##No.MOD-D70024 --bebin
##     LET l_npq.npq05=''
#     SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_npp.npp07 AND aag01 = l_npq.npq03
#     IF l_aag05 = 'Y' THEN 
#        LET l_npq.npq05=g_ccz.ccz23
#     ELSE 
#        LET l_npq.npq05=''
#     END IF 
##No.MOD-D70024 --end 
#     LET l_npq.npq06='1'    #借 
#     LET l_npq.npq07f=g_tot[i].t05
#     LET l_npq.npq07 =g_tot[i].t05
#     LET l_npq.npq07f = cl_digcut(l_npq.npq07f,g_azi04)   		
#     LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  		
#     LET l_npq.npq08 = NULL	
#     LET l_npq.npq11 = ' '	
#     LET l_npq.npq12 = ' '	
#     LET l_npq.npq13 = ' '	
#     LET l_npq.npq14 = ' '	
#     LET l_npq.npq15 = NULL	
#     LET l_npq.npq21 = NULL	
#     LET l_npq.npq22 = NULL	
#     LET l_npq.npq24 = g_aza.aza17	
#     LET l_npq.npq25 = 1	
#     LET l_npq.npq30 = l_npp.npp06	
#     LET l_npq.npq31 = ' '	
#     LET l_npq.npq32 = ' '	
#     LET l_npq.npq33 = ' '	
#     LET l_npq.npq34 = ' '	
#     LET l_npq.npq35 = ' '	
#     LET l_npq.npq36 = ' '	
#     LET l_npq.npq37 = ' '	
#     LET l_npq.npqtype = l_npp.npptype	
#     LET l_npq.npqlegal =l_npp.npplegal	
#   IF NOT cl_null(l_npq.npq07f) THEN  #FUN-C60016
#     INSERT INTO X VALUES(l_npq.*)
#     IF SQLCA.sqlcode THEN
#         CALL s_errmsg('temp','insert1',p_npp01,SQLCA.sqlcode,1)
#        LET g_success = 'N'
#     END IF                      
#  END IF                             #FUN-C60016
#No.MOD-D80008 --end
   #貸
     LET l_npq.npqsys='CA'
     LET l_npq.npq00=1
     LET l_npq.npq01=p_npp01
     LET l_npq.npq011=1
     SELECT max(npq02)+1 INTO l_npq.npq02 FROM npq_file
      WHERE npq01 = g_npp01
     IF l_npq.npq02 IS NULL THEN
        LET l_npq.npq02 = 1
     END IF
    IF l_apz13='N' THEN
       IF p_npptype='0' THEN
           SELECT aps44 INTO l_aps44 FROM aps_file WHERE aps01=' '
        ELSE
           SELECT aps441 INTO l_aps44 FROM aps_file WHERE aps01=' '
        END IF
    ELSE
        SELECT apa22 INTO l_apa22 FROM apa_file WHERE apa01=l_cap04
        IF p_npptype='0' THEN
           SELECT aps44 INTO l_aps44 FROM aps_file WHERE aps01=l_apa22
        ELSE
           SELECT aps441 INTO l_aps44 FROM aps_file WHERE aps01=l_apa22
        END IF
     END IF
     LET l_npq.npq03=l_aps44
     LET l_npq.npq04=''     
#No.MOD-D70024 --bebin
#     LET l_npq.npq05=''
     SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_npp.npp07 AND aag01 = l_npq.npq03
     IF l_aag05 = 'Y' THEN 
        LET l_npq.npq05=g_ccz.ccz23
     ELSE 
        LET l_npq.npq05=''
     END IF 
#No.MOD-D70024 --end
     LET l_npq.npq06='2'    #貸
#No.MOD-D80008 --begin
#    LET l_npq.npq07f=g_tot[i].t05
#    LET l_npq.npq07 =g_tot[i].t05
     LET l_npq.npq07f= l_amt_c
     LET l_npq.npq07 = l_amt_c
#No.MOD-D80008 --end
     LET l_npq.npq07f = cl_digcut(l_npq.npq07f,g_azi04)
     LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)
     LET l_npq.npq08 = NULL
     LET l_npq.npq11 = ' '
     LET l_npq.npq12 = ' '
     LET l_npq.npq13 = ' '
     LET l_npq.npq14 = ' '
     LET l_npq.npq15 = NULL
     LET l_npq.npq21 = NULL
     LET l_npq.npq22 = NULL
     LET l_npq.npq24 = g_aza.aza17
     LET l_npq.npq25 = 1
     LET l_npq.npq30 = l_npp.npp06
     LET l_npq.npq31 = ' '
     LET l_npq.npq32 = ' '
     LET l_npq.npq33 = ' '
     LET l_npq.npq34 = ' '
     LET l_npq.npq35 = ' '
     LET l_npq.npq36 = ' '
     LET l_npq.npq37 = ' '
     LET l_npq.npqtype = l_npp.npptype
     LET l_npq.npqlegal =l_npp.npplegal
    IF NOT cl_null(l_npq.npq07f) THEN  #FUN-C60016
       INSERT INTO X  VALUES(l_npq.*)
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('temp','insert2',p_npp01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF 
    END IF               #FUN-C60016
     LET i=i+1
#   END FOREACH     No.MOD-D80008 mark
 END FOREACH 
 END IF    


  IF g_success = 'Y' THEN 
     DECLARE p100_temp_curs CURSOR FOR 
     SELECT npqsys,npq00,npq01,npq011,'',npq03,npq04,npq05,npq06,
      SUM(npq07f) npq07f,SUM(npq07) npq07,npq08,npq11,npq12,npq13,npq14,npq15,npq21, 
      npq22,'',npq24,npq25,'','','','',npq30,npq31,npq32,npq33,npq34,npq35,
      npq36,npq37,'',npqtype,npqlegal 
      FROM X   
      GROUP BY npqsys,npq00,npq01,npq011,npq03,npq04,npq05,npq06,npq08,npq11,npq12,npq13,npq14,npq15,
      npq21,npq22,npq24,npq25,npq30,npq31,npq32,npq33,npq34,npq35,
      npq36,npq37,npqtype,npqlegal
      ORDER BY npq06
 
      LET l_i=1 
      FOREACH p100_temp_curs INTO p_npq.*
         LET p_npq.npq02=l_i
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_aza.aza81
            AND aag01 = p_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(p_npq.npq03,g_aza.aza81) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET p_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
#wujie 130709 --begin
#按科目设置的余额类型产生分录
         CALL s_aag42_direction(g_aza.aza81,p_npq.npq03,p_npq.npq06,      
                                p_npq.npq07,p_npq.npq07f)              
              RETURNING p_npq.npq06,p_npq.npq07,p_npq.npq07f
#wujie 130709 --end 
         INSERT INTO npq_file VALUES(p_npq.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('npq_file','insert',p_npp01,SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
            LET l_i=l_i+1
         END IF
      END FOREACH
   END IF
END FUNCTION

##FUN-C50131--------ADD---------END

