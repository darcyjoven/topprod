# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmp630a
# Descriptions...: FAS 產品組合作業
# Date & Author..: 91/04/10 By LYS
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA欄位放大到 dec(16,8)
# Modify.........: No.FUN-590040 05/09/09 By ching  fix開窗錯誤
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-740284 07/04/25 By kim rpi07改為直接抓ima08的值,當ima08='D'則,組合='Y',否則組合='N'
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860021 08/06/10 By Sarah PROMPT段漏了ON IDLE控制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2錯誤
# Modify.........: No.FUN-960007 09/11/25 By chenmoyan 將l_rowid改為chr18型
# Modify.........: No.MOD-B40091 11/04/14 By destiny 去除rowid             
# Modify.........: No.MOD-B60244 11/06/29 By Carrier insert字段与values不对应  
# Modify.........: No.MOD-C90208 12/09/25 By suncx l_rpi04，p_key賦值錯誤
# Modify.........: No.MOD-C90215 12/09/26 By suncx 1、測試發現，錄入ECN單審核後，abmp630無法正確運行，抓bmb_file資料時未考慮有效日期
#                                                  2、按照顧問所提問題，將bmb04賦值為g_today,bmb24賦值為空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
     DEFINE
        g_got           LIKE type_file.num5,       #No.FUN-680096 SMALLINT
        g_date          LIKE type_file.dat,        #No.FUN-680096 DATE
        g_cmd           LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        g_rpi03         LIKE rpi_file.rpi03,       # 序號
        g_item          LIKE rpi_file.rpi01,       # 最終規格料件編號
        g_seq           LIKE rpi_file.rpi11,       # 順序
        g_parts         LIKE rpi_file.rpi05,       # 元件編號
        g_pp            LIKE type_file.num5,       #No.FUN-680096 SMALLINT
        l_ac            LIKE type_file.num5,       # 目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
        l_sl            LIKE type_file.num5,       # 目前處理的SCREEN LINE   #No.FUN-680096 SMALLINT
        g_bma06         LIKE bma_file.bma06        #MOD-B40091
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680096 INTEGER
DEFINE   g_msg          STRING                     #No.MOD-580322
 
#FUNCTION p630a(p_row,p_col,p_gkc04,p_cmd,p_item,p_use,p_date) #TQC-840066  #MOD-B40091
FUNCTION p630a(p_row,p_col,p_gkc04,p_cmd,p_item,p_use,p_date,p_bma06) #MOD-B40091
    DEFINE
        g_gka01_t       LIKE type_file.chr20,      # 單號  #No.FUN-680096 VARCHAR(10)
        p_date          LIKE type_file.dat,        #No.FUN-680096 DATE
        p_gkc03         LIKE type_file.num5,       # 序號  #No.FUN-680096 SMALLINT
        p_gkc04         LIKE type_file.chr20,      # 品號  #No.FUN-680096 VARCHAR(20)
        p_cmd           LIKE type_file.chr1,       # 處理狀態     #No.FUN-680096 VARCHAR(1)
        p_item          LIKE rpi_file.rpi01,       # 最終規格料件編號
        p_use           LIKE type_file.chr1,       # 是否使用已存在之最終規格料件編號  #No.FUN-680096 VARCHAR(1)
        p_row,p_col     LIKE type_file.num5,       # window 位置        #No.FUN-680096 SMALLINT
        l_chr           LIKE type_file.chr1,        #No.FUN-680096 VARCHAR(1)
        p_bma06         LIKE bma_file.bma06         #MOD-B40091
 
   WHENEVER ERROR CONTINUE
  
    LET g_cmd=p_cmd
    LET g_item=p_item
    LET g_date=p_date
    LET g_bma06=p_bma06 #MOD-B40091
    IF p_cmd='a' AND p_use='Y' THEN  #已存在, 則選擇舊資料
        CALL p630a_use()
        RETURN g_got
    END IF
 
    OPEN WINDOW l_window WITH FORM "abm/42f/abmp630a" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("abmp630a")
  
    #更改時, 若無該選項的任何資料, 則應從 MFG的 BOM讀資料
    LET g_cnt=0
    IF p_cmd='u' THEN
        SELECT COUNT(*) INTO g_cnt
            FROM rpi_file
            WHERE rpi01=g_item
        IF SQLCA.sqlcode OR g_cnt IS NULL THEN
            LET g_cnt=0
        END IF
    END IF
 
    #決定是否要從已過的bom中去讀資料 0/否(使用MFG/BOM) 1/要(使用rpi_file)
    IF p_cmd='a' OR g_cnt=0 THEN
        LET l_chr='0'
    ELSE
        LET l_chr='1'
    END IF
 
    IF l_chr='0' THEN
        CALL cl_err(p_item,'ams-507',1)
    END IF
    #選擇資料
    LET g_got=0
    CALL p630a_bom(0,p_gkc04,1.0,l_chr,'','N')
 
    #資料選擇完畢, 將資料更新組合檔
    IF g_got > 0 THEN
        MESSAGE 'Select (',g_got USING '###&',') Item(s)'
        CALL ui.Interface.refresh()
        CALL p630a_updt(p_cmd)
    END IF
 
    CLOSE WINDOW l_window
    RETURN g_got

END FUNCTION
 
FUNCTION p630a_bom(p_level,p_key,p_qty,p_sel,p_hir,p_req)
    DEFINE
        p_level     LIKE type_file.num5,        #No.FUN-680096 SMALLINT
        p_sel,l_sel LIKE type_file.chr1,        #No.FUN-680096 VARCHAR(1)
        p_req       LIKE type_file.chr1,        #No.FUN-680096 VARCHAR(1)
        p_hir       LIKE rpi_file.rpi12,        #No.MOD-490217
        p_key       LIKE rpi_file.rpi04,
        l_rpi04     LIKE rpi_file.rpi04,
        l_ima02     LIKE ima_file.ima02,        #No.B444 010508 by plum
        p_qty       LIKE qcs_file.qcs06,        #No.FUN-680096 DEC(12,3)
        l_qty       LIKE qcs_file.qcs06,        #No.FUN-680096 DEC(12,3)
	l_bc        LIKE type_file.num5,        #No.FUN-680096 SMALLINT
        i,l_n,l_inx,l_j  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
        l_go        LIKE type_file.chr1,        #No.FUN-680096 CHAT(1)
        l_assign    LIKE type_file.chr1,        #No.FUN-680096 VARCHAR(1)
        l_bmb20     LIKE bmb_file.bmb20,
        l_ac_t      LIKE type_file.num5,        # 未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
        l_exit_sw   LIKE type_file.chr1,        # Esc結束INPUT ARRAY 否    #No.FUN-680096 VARCHAR(1) 
        l_rpi12 ARRAY[300] of LIKE rpi_file.rpi12,
        l_rpi13 ARRAY[300] of LIKE rpi_file.rpi13,
        l_rpi20 ARRAY[300] OF LIKE rpi_file.rpi20,
        l_rpi15 ARRAY[300] OF LIKE rpi_file.rpi15,
        l_rpi DYNAMIC ARRAY OF RECORD                 # 單身 program array
            rpi06 LIKE rpi_file.rpi06, # 選擇
            rpi07 LIKE rpi_file.rpi07, # 組合
            rpi05 LIKE rpi_file.rpi05, # 元件
            ima02b LIKE ima_file.ima02, #   #FUN-590040
            ima021 LIKE ima_file.ima021, #   #FUN-590040
            rpi08 LIKE rpi_file.rpi08, # 必要
            rpi09 LIKE rpi_file.rpi09, # 單位用量
            rpi10 LIKE rpi_file.rpi10  # 單位
        END RECORD,
        l_delete     LIKE rpi_file.rpi12,    #No.FUN-680096 VARCHAR(53)
        l_updt       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        l_chr        LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
    DISPLAY p_key TO rpi04             #主件
 
# BugNo.B444 010508 by plum
    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=p_key
    DISPLAY l_ima02 TO FORMONLY.ima02  
# BugNo.B444..end
 
    DISPLAY p_level TO FORMONLY.level  #LEVEL
  
    DECLARE p630a_bom2 CURSOR FOR
         SELECT "",ima08,bmb03,'','',bmb14,(bmb06/bmb07),ima25,1,'N',bmb20,''   #091020
        FROM bmb_file LEFT OUTER JOIN ima_file ON ima01 = bmb03  #091020        
        WHERE bmb01 = p_key AND      #091020  
              (bmb04 IS NULL OR bmb04 <= g_date) AND #生效日
              (bmb05 IS NULL OR bmb05 >  g_date)     #失效日
        ORDER BY bmb03
 
 
## No:2921 modify 1998/12/15 ---------
    #IF p_level=0 THEN #最高階   #MOD-C90208 mark
    #   LET l_rpi04=g_item       #MOD-C90208 mark
    #ELSE                        #MOD-C90208 mark
       LET l_rpi04=p_key
    #END IF                      #MOD-C90208 mark
 
    DECLARE p630a_bom3 CURSOR FOR
        SELECT rpi06,rpi07,rpi05,'','',rpi08,rpi09,rpi10,rpi15,rpi13, #FUN-590040
             rpi11,rpi12,rpi20
        FROM rpi_file
        WHERE rpi01=g_item
              AND rpi04=l_rpi04             #生效日
        ORDER BY rpi11
 
    LET l_ac = 1
    IF p_sel='0' THEN
        LET l_assign='N'
        FOREACH p630a_bom2 INTO l_rpi[l_ac].*,l_rpi15[l_ac],
			l_rpi13[l_ac],l_bmb20,
            l_rpi12[l_ac],l_rpi20[l_ac]
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            #FUN-590040
            SELECT ima02,ima021 INTO l_rpi[l_ac].ima02b,l_rpi[l_ac].ima021 
              FROM ima_file
            WHERE ima01=l_rpi[l_ac].rpi05
            #--
            IF p_level=0 OR l_assign='N' THEN
                IF p_level=0 THEN
                    LET p_hir=l_rpi[l_ac].rpi05
                ELSE
                    LET p_hir=p_hir CLIPPED, p_level USING '&&'
                END IF
                LET l_assign='Y'
            END IF
            IF cl_null(l_rpi[l_ac].rpi06) THEN LET l_rpi[l_ac].rpi06='N' END IF
           #IF l_rpi[l_ac].rpi07='N' THEN LET l_rpi[l_ac].rpi07=' ' END IF #MOD-740284
            #MOD-740284...........begin
            IF l_rpi[l_ac].rpi07='D' THEN 
               LET l_rpi[l_ac].rpi07='Y' 
            ELSE
               LET l_rpi[l_ac].rpi07=' ' 
            END IF
            #MOD-740284...........end
            IF l_rpi[l_ac].rpi08='0' THEN LET l_rpi[l_ac].rpi08='Y'
            ELSE LET l_rpi[l_ac].rpi08=' ' END IF
            LET l_rpi12[l_ac]=p_hir
            #MOD-C90208 mark begin-------------------
            #IF p_level=0 THEN #最高階
            #    LET p_key=g_item
            #END IF
            #MOD-C90208 mark end---------------------
            LET l_qty=p_qty*l_rpi[l_ac].rpi09
             INSERT INTO rpi_file (rpi01,rpi03,rpi04,rpi05,rpi06,rpi07,    #No:BUG-470041 #No.MOD-480013
                                  rpi08,rpi09,rpi10,rpi11,rpi12,rpi13,rpi14,
                                  rpi15,rpi20)
                 VALUES(g_item,g_rpi03,p_key,l_rpi[l_ac].rpi05,
                        l_rpi[l_ac].rpi06,l_rpi[l_ac].rpi07,l_rpi[l_ac].rpi08,
                        l_rpi[l_ac].rpi09,l_rpi[l_ac].rpi10,l_bmb20,
                        p_hir,'N',p_req,l_qty,l_rpi20[l_ac])
            LET l_ac = l_ac + 1
            # TQC-630105----------start add by Joe
            IF l_ac > g_max_rec THEN
               CALL cl_err( '', 9035, 0 )
               EXIT FOREACH
            END IF
            # TQC-630105----------end add by Joe
        END FOREACH
    ELSE
        FOREACH p630a_bom3 INTO l_rpi[l_ac].*,l_rpi15[l_ac],
			l_rpi13[l_ac],l_bmb20,
            l_rpi12[l_ac],l_rpi20[l_ac]
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            #FUN-590040
            SELECT ima02,ima021 INTO l_rpi[l_ac].ima02b,l_rpi[l_ac].ima021 
              FROM ima_file
            WHERE ima01=l_rpi[l_ac].rpi05
            #--
            IF cl_null(l_rpi[l_ac].rpi06) THEN LET l_rpi[l_ac].rpi06='N' END IF
            LET l_ac = l_ac + 1
            # TQC-630105----------start add by Joe
            IF l_ac > g_max_rec THEN
               CALL cl_err( '', 9035, 0 )
               EXIT FOREACH
            END IF
            # TQC-630105----------end add by Joe
        END FOREACH
    END IF
	LET l_bc=l_ac-1
    CALL SET_COUNT(l_bc)
    LET g_pp=l_bc
    WHILE TRUE
       #CALL cl_set_act_visible("accept,cancel", FALSE)
 
        DISPLAY ARRAY l_rpi TO s_rpi.* ATTRIBUTE(UNBUFFERED,COUNT=l_bc) #FUN-590040 
 
            ON ACTION CONTROLG
                CALL cl_cmdask()
 
#            ********** IMPORTANT *************************************
#            選擇鍵的處理方式
#             .零組件的處理
#               .選擇: 若該選擇為空白, 則將該選擇變成 Y
#               .刪除: 若該選擇為 Y, 則將該選擇變成空白
#             .組合項的處理
#               .選擇: 若該選擇為空白, 則將該選擇變成 Y
#                      遞回呼叫本身處理下階的選項
#               .刪除: 若該選擇為 Y, 則將該選擇變成空白
#                      將該選項以下的所有已選擇項刪除
#                      刪除方法, 利用rpi12 來判別
             
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
		LET l_sel=p_sel
                IF l_rpi[l_ac].rpi06 IS NULL OR l_rpi[l_ac].rpi06='N' THEN
                    LET l_rpi[l_ac].rpi06='Y'
                    LET l_go='Y'
                    LET g_got=g_got+1
                    LET l_updt='Y'
 	            LET l_sel='0'
                ELSE
                    IF l_rpi[l_ac].rpi07='Y' THEN
                        IF g_cmd='a' THEN #組合, 刪除原先已有的資料
                            LET l_chr=''
                            WHILE TRUE
                                PROMPT '是否將此組合及其相關選項刪除(Y/N):'
                                    FOR l_chr
                                    ON ACTION controlg       #TQC-860021
                                       CALL cl_cmdask()      #TQC-860021
 
                                    ON IDLE g_idle_seconds   #TQC-860021
                                       CALL cl_on_idle()     #TQC-860021
 
                                    ON ACTION about          #TQC-860021
                                       CALL cl_about()       #TQC-860021
 
                                    ON ACTION help           #TQC-860021
                                       CALL cl_show_help()   #TQC-860021
                                END PROMPT                   #TQC-860021
				IF INT_FLAG THEN LET INT_FLAG=0 END IF
                                LET l_chr=UPSHIFT(l_chr)
                                IF l_chr MATCHES '[YN]' THEN
                                    EXIT WHILE
                                END IF
                            END WHILE
                            IF l_chr = 'Y' THEN
                                LET l_delete=l_rpi12[l_ac] CLIPPED,'??*'
                                DELETE FROM rpi_file              #可以一次刪除
                                    WHERE rpi01=g_item AND   #本階以下資料
                                          rpi12 MATCHES l_delete
                                LET l_rpi[l_ac].rpi06='N'
                            END IF
                            LET l_go='N'
                            LET l_updt=l_chr
                        ELSE
                            LET l_updt='N'
                            CALL cl_err('','ams-510',0)
                        END IF
                    ELSE #非Feature
                        IF g_cmd='a' OR l_rpi13[l_ac]='N' THEN #第一次選
                            LET l_updt='Y'
                            LET l_rpi[l_ac].rpi06='N'
                            LET g_got=g_got-1
                        ELSE  #第二次選
                            LET l_updt='N'
                            CALL cl_err('','ams-511',0)
                        END IF
                    END IF
                END IF
                IF l_updt='Y' THEN
                    UPDATE rpi_file SET rpi06=l_rpi[l_ac].rpi06
                       WHERE rpi01=g_item AND
## No:2921 modify 1998/12/15 ---------
#                            rpi04=p_key AND
                             rpi04=l_rpi04 AND
                             rpi05=l_rpi[l_ac].rpi05
                    DISPLAY l_rpi[l_ac].rpi06 TO s_rpi[l_sl].rpi06
                        
                    IF l_rpi[l_ac].rpi07='Y' AND l_rpi[l_ac].rpi06='Y' AND
                       l_go='Y' THEN
                        LET g_got=g_got-1
                        CALL p630a_bom(p_level+1,l_rpi[l_ac].rpi05,
							p_qty*l_rpi[l_ac].rpi09,l_sel,
                            l_rpi12[l_ac],l_rpi[l_ac].rpi08)
				        CALL SET_COUNT(l_bc)
    					LET g_pp=l_bc
                        DISPLAY l_rpi04 TO rpi04 
                        DISPLAY p_level TO FORMONLY.level 
                        EXIT DISPLAY
                    END IF
                END IF
                DISPLAY g_got TO FORMONLY.ict 
 
            ON ACTION select_again  #重選
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_rpi[l_ac].rpi07='Y' AND l_rpi[l_ac].rpi06='Y' THEN
                    CALL p630a_bom(p_level+1,l_rpi[l_ac].rpi05,
						p_qty*l_rpi[l_ac].rpi09,'1',
                        l_rpi12[l_ac],l_rpi[l_ac].rpi08)
				    CALL SET_COUNT(l_bc)
    				LET g_pp=l_bc
                    DISPLAY l_rpi04 TO rpi04 
                    DISPLAY p_level TO FORMONLY.level 
                    EXIT DISPLAY
                END IF
 
#            ********** IMPORTANT *************************************
#            自動選擇必要項做法:
#            在組合項時, 按^s鍵, 若該組合尚未選擇 (選擇為null)
#            則詢問 [是否自動選擇該組合及其以下所有必要選項?(Y/N)]
#            若回答 Y, 則以遞回方式, 將該選項以下的必要選項放到組合暫存
#            檔中, 並將其選擇變成 Y, 最後將該組合項的選擇變成 Y.
 
            ON ACTION select_need
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_rpi[l_ac].rpi07='Y' AND  #組合項, 未選
                   (l_rpi[l_ac].rpi06 IS NULL OR l_rpi[l_ac].rpi06='N') THEN
                    LET l_chr=''
                    WHILE TRUE
                        PROMPT '是否自動選擇該組合及其以下所有必要選項?(Y/N)'
                            FOR l_chr
                            ON ACTION controlg       #TQC-860021
                               CALL cl_cmdask()      #TQC-860021
 
                            ON IDLE g_idle_seconds   #TQC-860021
                               CALL cl_on_idle()     #TQC-860021
 
                            ON ACTION about          #TQC-860021
                               CALL cl_about()       #TQC-860021
 
                            ON ACTION help           #TQC-860021
                               CALL cl_show_help()   #TQC-860021
                        END PROMPT                   #TQC-860021
			IF INT_FLAG THEN LET INT_FLAG=0 END IF
                        IF l_chr MATCHES '[YyNn]' THEN
                            EXIT WHILE
                        END IF
                    END WHILE
                    IF l_chr MATCHES '[Yy]' THEN
#No.MOD-580322--begin                                                                                                              
#                       MESSAGE ' 選擇中 '         
                        CALL cl_err('','abm-812','0')        
#No.MOD-580322--end    
                        CALL ui.Interface.refresh()
                        LET g_cnt=0
            			CALL p630a_auto(p_level+1,l_rpi[l_ac].rpi05,
							p_qty*l_rpi[l_ac].rpi09,p_hir,l_rpi[l_ac].rpi08)
                        LET l_rpi[l_ac].rpi06='Y'
                        UPDATE rpi_file SET rpi06=l_rpi[l_ac].rpi06,
                               rpi12=l_rpi12[l_ac]
                           WHERE rpi01=g_item AND
## No:2921 modify 1998/12/15 ---------
#                                rpi04=p_key AND
                                 rpi04=l_rpi04 AND
                                 rpi05=l_rpi[l_ac].rpi05
                        DISPLAY l_rpi[l_ac].rpi06 TO s_rpi[l_sl].rpi06
                            
#No.MOD-580322--begin   
                        LET g_msg = cl_getmsg('abm-813',g_lang)       
                        LET g_msg = g_msg CLIPPED,g_cnt USING '###&' CLIPPED        
                        CALL cl_err(g_msg,'abm-814','0')                           
#                       MESSAGE '總計選了(',g_cnt USING '###&',')項'              
#No.MOD-580322--end 
                        CALL ui.Interface.refresh()
                    END IF
                END IF
 
            ON ACTION select_by_lineno  #進行挑選
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
 
                OPEN WINDOW l_win3 WITH FORM "abm/42f/abmp630b" 
                      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
                CALL cl_ui_locale("abmp630b")

                CALL p630a_get()
                IF INT_FLAG THEN
                    LET INT_FLAG=0
                ELSE
                  IF g_seq IS NULL THEN
                      FOR i=1 TO g_pp  #檢查是否有滿足條件者
                          IF l_rpi[i].rpi05=g_parts THEN
                              LET g_seq=i
                              EXIT FOR
                          END IF
                      END FOR
                  END IF
                END IF
                CLOSE WINDOW l_win3
                IF g_seq IS NOT NULL THEN #有選到
                    IF l_rpi[g_seq].rpi06 IS NULL
                        OR l_rpi[g_seq].rpi06='N' THEN
                        IF (l_rpi[g_seq].rpi07 IS NULL OR
                         l_rpi[g_seq].rpi07 = ' ')THEN
                            LET l_rpi[g_seq].rpi06='Y'
                            LET l_go='Y'
                            LET g_got=g_got+1
                            UPDATE rpi_file SET rpi06=l_rpi[g_seq].rpi06
                               WHERE rpi01=g_item AND
                                     rpi04=l_rpi04 AND
                                     rpi05=l_rpi[g_seq].rpi05
                            #是否應將該值顯示在畫面上
                            LET l_inx=g_seq-l_ac+l_sl #取得第一筆的index
                            IF l_inx <= 10 THEN
                                DISPLAY l_rpi[g_seq].rpi06 TO s_rpi[l_inx].rpi06
                                 
                            END IF
                        END IF
                    ELSE
                        CALL cl_err('','ams-511',0)
                    END IF
                END IF
                DISPLAY g_got TO FORMONLY.ict
 
            ON ACTION accept
                LET l_chr='N'
                FOR i=1 TO g_pp  #檢查必要的選項是否已經全部選擇
                    IF l_rpi[i].rpi08='Y' AND
                       (l_rpi[i].rpi06 IS NULL OR l_rpi[i].rpi06='N') THEN
                        LET l_chr='Y'
                        EXIT FOR
                    END IF
                END FOR
                IF l_chr='Y' THEN
                    CALL cl_err('','ams-508',0)
                ELSE
                    LET l_exit_sw = 'y'
                    EXIT DISPLAY
                END IF
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6B0033
  
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
        IF INT_FLAG THEN LET g_success='N' RETURN END IF
        IF l_exit_sw = "y" THEN EXIT WHILE  END IF
    END WHILE
END FUNCTION
 
FUNCTION p630a_auto(p_lev,p_key,p_qty,p_hir,p_req)
DEFINE
    p_lev           LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    p_req           LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    p_key           LIKE rpi_file.rpi05,
    p_qty,l_qty     LIKE qcs_file.qcs06,     #No.FUN-680096 DEC(12,3)
    p_hir           LIKE rpi_file.rpi12,
    l_ac,i          LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_rpi DYNAMIC ARRAY OF RECORD            # 單身 program array
        rpi06        LIKE rpi_file.rpi06,    # 選擇
        rpi07        LIKE rpi_file.rpi07,    # 組合
        rpi05        LIKE rpi_file.rpi05,    # 元件
        rpi08        LIKE rpi_file.rpi08,    # 必要
        rpi09        LIKE rpi_file.rpi09,    # 組成量
        rpi10        LIKE rpi_file.rpi10,    # 單位
        rpi11        LIKE rpi_file.rpi11     # 順序
    END RECORD 
 
# 標準批量已被取消
#   SELECT jaa05 INTO l_jaa05
#       FROM jaa_file
#       WHERE jaa01=p_key
#   IF SQLCA.sqlcode OR l_jaa05=0 OR l_jaa05 IS NULL THEN
#      LET l_jaa05=1
#   END IF
 
    DECLARE p630a_bom4 CURSOR FOR
        SELECT "",bmb17,bmb03,bmb14,(bmb06/bmb07),ima25,bmb20
#       FROM bmb_file,OUTER ima_file  #091020
        FROM bmb_file LEFT OUTER JOIN ima_file ON ima01 = bmb03   #091020        
#       WHERE bmb01=p_key AND ima_file.ima01 = bmb_file.bmb03 AND #091020
        WHERE bmb01 = p_key AND  #091020
              (bmb04 IS NULL OR bmb04 <= g_date) AND #生效日
              (bmb05 IS NULL OR bmb05 >  g_date)     #失效日
        ORDER BY bmb03
    LET p_hir=p_hir CLIPPED, p_lev USING '&&'
    LET l_ac=1
    FOREACH p630a_bom4 INTO l_rpi[l_ac].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        IF l_rpi[l_ac].rpi08='0' THEN #REQUIRED
            LET l_rpi[l_ac].rpi06='Y'
            LET l_rpi[l_ac].rpi08='Y'
        ELSE
            LET l_rpi[l_ac].rpi06='N'
            LET l_rpi[l_ac].rpi08=''
        END IF
        IF l_rpi[l_ac].rpi07='N' THEN  #組合項
            LET l_rpi[l_ac].rpi07=''
        END IF
        IF l_rpi[l_ac].rpi07 IS NULL AND l_rpi[l_ac].rpi06='Y' THEN
            LET g_cnt=g_cnt+1
            LET g_got=g_got+1
        END IF
        LET l_ac=l_ac+1
        # TQC-630105----------start add by Joe
        IF l_ac > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    DISPLAY g_got TO FORMONLY.ict
    FOR i = 1 TO l_ac-1
        LET l_qty=p_qty*l_rpi[i].rpi09
        #No.MOD-B60244  --Begin
        #INSERT INTO rpi_file (rpi01,rpi02,rpi03,rpi04,rpi05,rpi06,rpi07,  #No.MOD-470041
        INSERT INTO rpi_file (rpi01,rpi03,rpi04,rpi05,rpi06,rpi07,  #No.MOD-470041
        #No.MOD-B60244  --End  
                                  rpi08,rpi09,rpi10,rpi11,rpi12,rpi13,rpi14,
        #No.MOD-B60244  --Begin
        #                         rpi15,rpi20)
                                  rpi15)
        #No.MOD-B60244  --End  
        #No.MOD-B60244  --Begin
        #    VALUES(g_item,g_rpi0,p_key,l_rpi[i].rpi05,l_rpi[i].rpi06,
             VALUES(g_item,g_rpi03,p_key,l_rpi[i].rpi05,l_rpi[i].rpi06,
        #No.MOD-B60244  --End  
                    l_rpi[i].rpi07,l_rpi[i].rpi08,l_rpi[i].rpi09,
        #No.MOD-B60244  --Begin
        #           l_rpi[i].rpi10,l_rpi[i].rpi11,p_hir,'N',l_qty,p_req)
                    l_rpi[i].rpi10,l_rpi[i].rpi11,p_hir,'N',p_req,l_qty)
        #No.MOD-B60244  --End  
        IF l_rpi[i].rpi07='Y' AND l_rpi[i].rpi08='Y' THEN
            CALL p630a_auto(p_lev+1,l_rpi[i].rpi05,l_qty,
						p_hir,l_rpi[i].rpi08)
        END IF
    END FOR
END FUNCTION
 
#更新組合檔
FUNCTION p630a_updt(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_bmb     RECORD LIKE bmb_file.*,
#   l_rowid   LIKE type_file.num10,     #091020     #No.FUN-960007
    l_rpi20   LIKE rpi_file.rpi20,      #No.FUN-960007
    l_qpa     LIKE rpi_file.rpi15,      #FUN-560230
    l_n       LIKE type_file.num5,       #順序    #No.FUN-680096 SMALLINT
    l_rpi04   LIKE rpi_file.rpi04,
    l_rpi05   LIKE rpi_file.rpi05,
    l_rpi03   LIKE rpi_file.rpi03
    
    #MOD-B40091--begin
    #DECLARE p630a_bom6 CURSOR FOR
    #    SELECT rpi20,rpi15 FROM rpi_file
    #     WHERE rpi01 = g_item AND rpi06='Y' AND     #已選擇
    #          (rpi07 IS NULL OR rpi07=' ') AND     #零組件
    #           rpi13='N'         #未更新
    DECLARE p630a_bom6 CURSOR FOR
        SELECT rpi04,rpi03,rpi05,rpi15 FROM rpi_file
         WHERE rpi01 = g_item AND rpi06='Y' AND     #已選擇
              (rpi07 IS NULL OR rpi07=' ') AND     #零組件
               rpi13='N'         #未更新
    #MOD-B40091--end      
    #MOD-B40091--begin--mark                    
    #IF p_cmd='a' THEN
    #    LET l_n=1
    #ELSE  #新增選項
    #    SELECT MAX(bmb02)+1 INTO l_n
    #       FROM bmb_file
    #       WHERE bmb01=g_item
    #    IF SQLCA.sqlcode OR l_n IS NULL OR l_n<=0 THEN
    #        LET l_n=1
    #    END IF
    #END IF
    
    SELECT max(bmb02)
       INTO l_n
       FROM bmb_file
       WHERE bmb01 = g_item
         AND bmb29 = g_bma06  
    IF l_n IS NULL
       THEN LET l_n = 0
    END IF
    LET l_n = l_n + g_sma.sma19    
    #MOD-B40091--end
    #FOREACH p630a_bom6 INTO l_rpi20, l_qpa                 #MOD-B40091
    FOREACH p630a_bom6 INTO l_rpi04,l_rpi03,l_rpi05,l_qpa   #MOD-B40091
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        SELECT * INTO l_bmb.* FROM bmb_file 
         WHERE bmb01=l_rpi04  AND bmb03=l_rpi05 AND bmb29=g_bma06 #MOD-B40091
        #MOD-C90215 add begin--------------------------------------
           AND (bmb04 IS NULL OR bmb04 <= g_date)     #生效日
           AND (bmb05 IS NULL OR bmb05 >  g_date)     #失效日
        #MOD-C90215 add end----------------------------------------
        IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","bmb_file",l_bmb.bmb01,l_bmb.bmb02,SQLCA.sqlcode,"","FORselect",1)  #No.TQC-660046
        END IF
        LET l_bmb.bmb01=g_item
        LET l_bmb.bmb02=l_n
      	LET l_bmb.bmb06=l_qpa*l_bmb.bmb07
        # No.+114 Tommy
        IF cl_null(l_bmb.bmb28) THEN 
           LET l_bmb.bmb28 = 0
        END IF
        # End Tommy
        #MOD-790002.................begin
        IF cl_null(l_bmb.bmb02)  THEN
           LET l_bmb.bmb02=' '
        END IF
        #MOD-790002.................end
        #MOD-C90215 add begin--------------------------
        LET l_bmb.bmb04 = g_today
        LET l_bmb.bmb24 = ''
        #MOD-C90215 add end----------------------------
 
        LET l_bmb.bmb33 = 0  #No.FUN-830116
        INSERT INTO bmb_file VALUES(l_bmb.*)
        LET l_n=l_n+g_sma.sma19
        # TQC-630105----------start add by Joe
        IF l_n > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #處理更新碼
    UPDATE rpi_file SET rpi13='Y'
    WHERE rpi01=g_item AND
          rpi03=g_rpi03 AND
          rpi06='Y' AND     #已選擇
          (rpi07 IS NULL OR rpi07=' ') AND     #零組件
          rpi13='N'         #未更新
END FUNCTION
 
FUNCTION p630a_use()
#反調更新碼
    UPDATE rpi_file SET rpi13='N'
    WHERE rpi01=g_item AND
          rpi06='Y' AND     #已選擇
          (rpi07 IS NULL OR rpi07=' ') #零組件
    CALL p630a_updt('a')
END FUNCTION
 
FUNCTION p630a_get()
    CALL cl_set_head_visible("grid01","YES")     #No.FUN-6B0033
 
    INPUT g_seq,g_parts FROM rpi11,rpi05
        AFTER FIELD rpi11
           IF g_seq IS NOT NULL THEN
               IF g_seq < 1 OR g_seq > g_pp THEN
                   CALL cl_err(g_pp,'ams-512',0)
                   NEXT FIELD rpi11
               ELSE
                   EXIT INPUT
               END IF
           END IF
        AFTER INPUT
           IF g_seq IS NULL AND g_parts IS NULL AND NOT INT_FLAG THEN
               NEXT FIELD rpi11
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
 
    
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET g_success='N' END IF
END FUNCTION
