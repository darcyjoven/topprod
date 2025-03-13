# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: afap110.4gl
# Descriptions...: 資產資料產生作業
# Date & Author..: 96/06/12 by nick
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: #No:6971 03/07/14 By Wiky 若l_bn <=0 且進入下面l_j !=1時會當出來
# Modify.........: No:8068 03/09/04 By Wiky IF SQLCA.SQLCDE改用cl_null()判斷,因為抓不出值sqlca.sqlcode還是=0
# Modify.........: No:7679 03/10/01 By Kitty 增加faj207
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470589 04/08/23 By Nicola 若單價異, 合併時會加總單價, 應取加權平均
#                                                   按放棄時，離開程式
#                                                   執行完後，詢問是否繼續，留在原畫面
# Modify.........: No.MOD-580155 05/08/19 By Smapmin 當未用年限為空值或0時,預設為使用年限
# Modify.........: No.FUN-5B0104 05/12/01 By Sarah _ins1(),_ins2(),_ins3()等段在INSERT faj_file前,若財編(faj02)空白,則Show錯誤訊息,不拋轉
# Modify.........: No.MOD-650066 06/05/11 By Dido LIKE type_file.num10  宣告改為 DECIMAL       #No.FUN-680070 INTEGER
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-680007 06/08/02 By Smapmin 分割時處理稅簽資料
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/15 By hellen  錯誤訊息匯總顯示修改
# Modify.........: No.MOD-740039 07/04/11 By Smapmin 底稿再提金額為NULL時,要預設為0
# Modify.........: No.MOD-750083 07/05/21 By Smapmin 修改新增到faj_file各欄位的預設值,由原本預設為1改為預設為0
# Modify.........: No.TQC-7B0049 07/11/09 By xufeng  沒有考慮系統的參數設置 
# Modify.........: No.MOD-7C0182 07/12/25 By Smapmin 調整 faj66(稅簽預留殘值),faj68(稅簽未折減額) 比照 faj31/faj33累加
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-8C0185 08/12/22 By Sarah p110_ins_move()段,若faj71為NULL時,應給予預設值為N
# Modify.........: No.MOD-960147 09/06/11 By Sarah p110_ins1()段,抓到g_faj.faj02後,需判斷是否已存在faj_file,若已存在應重取資產編號
# Modify.........: No.MOD-970176 09/07/20 By mike faj31,faj66取位前應再除以資產數量   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0269 09/12/23 By sabrina 修改MOD-960147，g_faj.faj02為非null才可重取資產編號
# Modify.........: No:MOD-A10071 10/01/15 By Sarah 修正MOD-970176,計算faj31與faj66不需再除一次fak17
# Modify.........: No.MOD-A30244 10/04/01 By sabrina (1)p110_ins1()計算出faj14後做faj14取位
# Modify.........: No.TQC-A40027 10/04/06 By houlia 單身字段全部NOENTRY時,自動帶到下一行可edit的行
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.TQC-A40034 10/04/07 By houlia 自動編號之最大序號應捉已使用資產序號編號的欄位+1
# Modify.........: No.CHI-A30037 10/04/22 By sabrina 當aza31='Y'時財產編號走自動編號功能
# Modify.........: No.TQC-A40121 10/04/23 By houlia before intput處缺少判斷
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加faj93,fak93族群之欄位
# Modify.........: No.MOD-A90159 10/09/24 By Dido 分割時序號也應同步增加 
# Modify.........: No.MOD-AA0011 10/10/05 By Dido faj100 給預設值 
# Modify.........: No.MOD-AB0044 10/11/04 By Dido 當自動編號後應回寫 fak02/fak022 以利後續刪除faj_file時更新 fak91 
# Modify.........: No.MOD-AB0125 10/11/12 By Dido 分割重編財編時,應重複檢核是否存在 faj_file  
# Modify.........: No.TQC-AB0263 10/11/30 By lixia 按下"分割"鍵程式當掉
# Modify.........: No:MOD-AC0424 10/12/31 By Sarah 按下"群組號碼"後程式當掉
# Modify.........: No:MOD-B10015 11/01/05 By Dido 分割時財編溢位須提示警訊 
# Modify.........: No.TQC-B20042 11/02/14 By zhangll 數量為1時，不能分割 
# Modify.........: No.MOD-B20045 11/02/15 By Dido 自動編號時,若原 faj06 有值則不可被取代 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: NO:MOD-B40118 11/04/18 By Dido 序號應需再加 1
# Modify.........: NO:MOD-B40211 11/04/22 By wujie faj13，faj16未截位，原币成本最后笔未按本币的逻辑取
# Modify.........: NO:MOD-B40257 11/04/28 By wujie 若财产编号重复，则自动编号，回写改为fak09，fak901
# Modify.........: NO:FUN-B50035 11/05/09 By wujie 合并时预设数量为1，单价等累计
# Modify.........: No:FUN-B40065 11/05/17 By belle 全選全不選功能
# Modify.........: No:MOD-B60222 11/06/25 By Sarah 在拋轉資料前先lock要拋的fak_file
# Modify.........: No:TQC-B70023 11/07/04 By Dido 若財編為空白則不做累加 
# Modify.........: NO:CHI-B70009 11/07/05 By Dido 自動編碼開窗詢問只限第一筆才詢問 
# Modify.........: NO:MOD-B70179 11/07/19 By Dido 查詢資料後,應刪除最後一筆空白 
# Modify.........: No:MOD-B80229 11/08/22 By Carrier faj312为空时,default 0
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:MOD-BA0218 11/11/12 By johung aza31='N'/faa05='N'/faa06='N'，應控卡fak90/fak901不能為NULL
# Modify.........: No:MOD-C20120 12/02/17 By wujie 调整群组号码的使用方式，合并时使用群组号码+附号，通过faj_file检查唯一性，清空faj92，faj921
#                                                                          分割时不使用群组号码，增加faj922，对应fak01，使得抛转后的fa能够找到对应的来源底稿
# Modify.........: No:MOD-C30855 12/03/36 By Polly 增加折畢再提預留殘值(faj35)的值切割
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:MOD-C50172 12/05/28 By Polly 增加faa_file LUCK CURSOR應用 
# Modify.........: No:MOD-C80001 12/08/06 By Polly 考量舊客問題，見採共用方式處理，還原faj105的應用
# Modify.........: No:MOD-C80057 12/10/25 By Polly 合併資產採用自動編財產編號時，增加action自動產生群組編碼
# Modify.........: No:MOD-CA0163 12/10/26 By Polly 資產產生作業，faj92、fja921、fak90、fja901需一致，afai100刪除時，才可正確將fak90改為'N'
# Modify.........: No:MOD-CA0196 12/10/26 By Polly 如有勾選自動編號，但已有財產編號者，不需要重取號
# Modify.........: No:MOD-D80047 13/08/08 By suncx IF判斷錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql  STRING                                 #No.FUN-580092 HCN
DEFINE t_fak       RECORD LIKE fak_file.*
DEFINE g_faj       RECORD LIKE faj_file.*
DEFINE g_fak       DYNAMIC ARRAY OF RECORD
                    a      LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    fak00  LIKE fak_file.fak00,
                    fak02  LIKE fak_file.fak02,
                    fak022 LIKE fak_file.fak022,
                    fak06  LIKE fak_file.fak06,
                    fak17  LIKE fak_file.fak17,
                    splt   LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    comb   LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    fak90  LIKE fak_file.fak90,
                    fak901 LIKE fak_file.fak901
                   END RECORD
DEFINE g_fak_fak01 DYNAMIC ARRAY OF LIKE fak_file.fak01  #No.FUN-680070 INT # saki 20070821 rowid chr18 -> num10 
DEFINE l_faa031    LIKE type_file.chr20                   #No.FUN-680070 VARCHAR(10)
DEFINE g_fak_t     RECORD 
                    a      LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    fak00  LIKE fak_file.fak00,
                    fak02  LIKE fak_file.fak02,
                    fak022 LIKE fak_file.fak022,
                    fak06  LIKE fak_file.fak06,
                    fak17  LIKE fak_file.fak17,
                    splt   LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    comb   LIKE type_file.chr1,           #No.FUN-680070 VARCHAR(1)
                    fak90  LIKE fak_file.fak90,
                    fak901 LIKE fak_file.fak901
                   END RECORD 
DEFINE l_i                  LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE p_row,p_col          LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_cnt                LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_rec_b              LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE l_ac                 LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_edit               LIKE type_file.chr1       #No.TQC-A40027
DEFINE g_faj_t              RECORD LIKE faj_file.*    #TQC-A4003
DEFINE g_forupd_sql         STRING                    #MOD-B60222 add  #SELECT ... FOR UPDATE SQL
DEFINE g_msg1,g_msg2,g_msg3 STRING                    #MOD-B60222 add
DEFINE g_chki               LIKE type_file.num5       #CHI-B70009
DEFINE g_faj02              LIKE faj_file.faj02    #CHI-B70009
DEFINE g_azi04_1           LIKE azi_file.azi04       #CHI-C60010 add
DEFINE g_faj06              LIKE faj_file.faj06       #MOD-C80057 add
DEFINE g_fak90              LIKE fak_file.fak90       #MOD-CA0163 add
DEFINE g_fak901             LIKE fak_file.fak901      #MOD-CA0163 add
 
MAIN
#DEFINE l_time    LIKE type_file.chr8            #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
  #str MOD-B60222 add
   LET g_forupd_sql = "SELECT * FROM fak_file WHERE fak01 = ? AND fak02 = ? AND fak022 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p110_cl CURSOR  FROM g_forupd_sql
   CALL cl_get_feldname("fak00",g_lang) RETURNING g_msg1
   CALL cl_get_feldname("fak02",g_lang) RETURNING g_msg2
   CALL cl_get_feldname("fak022",g_lang) RETURNING g_msg3
  #end MOD-B60222 add

   INITIALIZE g_faj_t.* TO NULL               #TQC-A40034 

   OPEN WINDOW p110_w AT p_row,p_col WITH FORM "afa/42f/afap110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   CALL p110()
   CLOSE WINDOW p110_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p110()
   DEFINE l_flag  LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   CLEAR FORM
   CALL g_fak.clear()
   CALL cl_opmsg('w') 
  #---------------------------------MOD-C50172----------------------------------------------------(S)
   LET g_forupd_sql = "SELECT * FROM faa_file WHERE faa00 = '0' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE faa_cl CURSOR  FROM g_forupd_sql
  #---------------------------------MOD-C50172----------------------------------------------------(E)
   WHILE TRUE
      CONSTRUCT g_wc ON fak00,fak02,fak022,fak17,fak90,fak901 
           FROM s_fak[1].fak00,s_fak[1].fak02,s_fak[1].fak022,
                s_fak[1].fak17,s_fak[1].fak90,s_fak[1].fak901 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
#           CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE
   CALL p110_body_fill()
   LET l_ac = 1
   CALL p110_b()
    #-----No.MOD-470589-----
   IF INT_FLAG THEN 
      LET INT_FLAG=0
      RETURN
   END IF
   #-----END---------------
       
   IF NOT cl_sure(0,0) THEN RETURN END IF
   BEGIN WORK 
  #-------------------------MOD-C50172----------(S)
   OPEN faa_cl
   IF STATUS  THEN
      CALL cl_err('OPEN faa_curl',STATUS,1)
      RETURN 
   END IF   
  #-------------------------MOD-C50172----------(S) 
   LET g_success='Y'
   LET g_chki = 0         #CHI-B70009
   CALL s_showmsg_init()  #No.FUN-710028
   FOR l_i=1 TO g_fak.getLength()
#No.FUN-710028 --begin       
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
#No.FUN-710028 -end
 
      IF cl_null(g_fak[l_i].fak00) THEN 
         EXIT FOR
      END IF
      IF g_fak[l_i].a<>'Y' THEN
         CONTINUE FOR
      END IF
      IF g_chki = 0 THEN       #CHI-B70009 
         LET g_chki = l_i      #CHI-B70009
      END IF                   #CHI-B70009
      #MOD-BA0218 -- begin --
      IF g_aza.aza31 = 'N' AND g_faa.faa05 = 'N' AND g_faa.faa06 = 'N' THEN
         IF (cl_null(g_fak[l_i].fak02) OR g_fak[l_i].fak02 = ' ')
            AND (cl_null(g_fak[l_i].fak022) OR g_fak[l_i].fak022 = ' ') THEN
           #IF cl_null(g_fak[l_i].fak90) OR g_fak[l_i].fak901 IS NULL  AND g_fak[l_i].comb ='Y' THEN   #No.MOD-C20120 add comb #MOD-D80047mark
            IF (cl_null(g_fak[l_i].fak90) OR g_fak[l_i].fak901 IS NULL) AND g_fak[l_i].comb ='Y' THEN  #MOD-D80047 add 
               LET g_success = 'N'
               CALL s_errmsg('fak00',g_fak[l_i].fak00,'','afa-163',1)
               CONTINUE FOR
            END IF
         END IF
      END IF
      #MOD-BA0218 -- end --
      CALL p110_ins()
#     IF g_success='N' THEN    #No.FUN-710028
#        EXIT FOR              #No.FUN-710028
#     END IF                   #No.FUN-710028
   END FOR
#No.FUN-710028 --begin
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#No.FUN-710028 --end
   CALL s_showmsg()            #No.FUN-710028
 
   IF g_success = 'Y' THEN 
      COMMIT WORK 
      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
   ELSE 
      ROLLBACK WORK
      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
   END IF
   IF l_flag THEN
       CALL p110()       #No.MOD-470589
   ELSE
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
   CLOSE faa_cl                                            #MOD-C50172 add
END FUNCTION
   
FUNCTION p110_ins()
   DEFINE l_msg    STRING   #MOD-B60222 add

  #str MOD-B60222 add
  #在拋轉資料前先lock要拋的fak_file
   OPEN p110_cl USING g_fak_fak01[l_i],g_fak[l_i].fak02,g_fak[l_i].fak022
   IF STATUS THEN
      LET l_msg = g_msg1 CLIPPED,":",g_fak[l_i].fak00 CLIPPED,",",
                  g_msg2 CLIPPED,":",g_fak[l_i].fak02 CLIPPED,",",
                  g_msg3 CLIPPED,":",g_fak[l_i].fak022 CLIPPED,
                  " OPEN p110_cl:"
      CALL cl_err(l_msg, STATUS, 1)
      CLOSE p110_cl
      LET g_success='N'
      RETURN
   END IF
   FETCH p110_cl INTO t_fak.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fak_fak01[l_i],SQLCA.sqlcode,0)
      LET g_success='N'
      RETURN
   END IF
  #end MOD-B60222 add
 
   SELECT * INTO t_fak.* FROM fak_file
    WHERE fak01 = g_fak_fak01[l_i] AND fak02 = g_fak[l_i].fak02 AND fak022 = g_fak[l_i].fak022
   IF SQLCA.sqlcode THEN LET g_success='N' END IF
   CALL p110_ins_move()
#CHI-C60010--add--str--
   IF g_faa.faa31='Y' THEN
      SELECT azi04 INTO g_azi04_1 FROM azi_file,aaa_file
       WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
      LET g_faj.faj1412=cl_digcut(g_faj.faj1412,g_azi04_1)
      LET g_faj.faj144=cl_digcut(g_faj.faj144,g_azi04_1)
      LET g_faj.faj352=cl_digcut(g_faj.faj352,g_azi04_1)
      LET g_faj.faj592=cl_digcut(g_faj.faj592,g_azi04_1)
      LET g_faj.faj602=cl_digcut(g_faj.faj602,g_azi04_1)
   END IF
#CHI-C60010--add--end
   CASE 
      WHEN g_fak[l_i].splt='Y'    #part.1 分割
           CALL p110_ins1()
      #    DELETE FROM fak_file WHERE fak01 = g_fak_fak01[l_i] AND fak02 = g_fak[l_i].fak02 AND fak022 = g_fak[l_i].fak022
          #----------------MOD-CA0163------------------(S)
          #--MOD-CA0163--mark
          #UPDATE fak_file SET fak91='Y',
          #                   #No.MOD-C20120 --begin
          #                    #fak90=g_fak[l_i].fak90,
          #                    #fak901=g_fak[l_i].fak901
          #                     fak90='',
          #                     fak901=''
          #                   #No.MOD-C20120 --end
          #WHERE fak01 = g_fak_fak01[l_i] AND fak02 = g_fak[l_i].fak02 AND fak022 = g_fak[l_i].fak022
          #--MOD-CA0163--mark
           UPDATE fak_file SET fak91 = 'Y',
                               fak90 = g_fak90,
                               fak901 = g_fak901
            WHERE fak01 = g_fak_fak01[l_i]
              AND fak02 = g_fak[l_i].fak02
              AND fak022 = g_fak[l_i].fak022
          #----------------MOD-CA0163------------------(E)
      WHEN g_fak[l_i].comb='Y'    #part.2 合併
           CALL p110_ins2()
           UPDATE fak_file SET fak91='Y',
                               fak90=g_fak[l_i].fak90,
                               fak901=g_fak[l_i].fak901 
#                               fak02=g_fak[l_i].fak90,         #MOD-AB0044   #No.FUN-B50035
#                               fak022=g_fak[l_i].fak901        #MOD-AB0044   #No.FUN-B50035
                         WHERE fak01 = g_fak_fak01[l_i] AND fak02 = g_fak[l_i].fak02 AND fak022 = g_fak[l_i].fak022
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN LET g_success='N' END IF
          #----------------MOD-CA0163------------------(S)
           UPDATE faj_file
              SET faj92 = g_fak[l_i].fak90,
                  faj921 = g_fak[l_i].fak901
            WHERE faj01 = g_faj.faj01
              AND faj02 = g_faj.faj02
              AND faj021 = g_faj.faj021
          #----------------MOD-CA0163------------------(E)
      OTHERWISE                   #part.3 1 by 1
           CALL p110_ins3()
          #UPDATE fak_file SET fak91='Y',                      #MOD-CA0163 mark
#No.MOD-B40257 --begin
#No.MOD-C20120 --begin
#                               fak90=g_faj.faj02,
#                               fak901=g_faj.faj022 
#                              fak90='',                       #MOD-CA0163 mark
#                              fak901=''                       #MOD-CA0163 mark
#No.MOD-C20120 --end# 
#                               fak90=g_fak[l_i].fak90,
#                               fak901=g_fak[l_i].fak901, 
#                               fak02=g_faj.faj02,              #MOD-AB0044
#                               fak022=g_faj.faj022             #MOD-AB0044
#No.MOD-B40257 --end
           UPDATE fak_file SET fak91 = 'Y',                    #MOD-CA0163 add
                               fak90 = g_faj.faj02,            #MOD-CA0163 add
                               fak901 = g_faj.faj022           #MOD-CA0163 add
            WHERE fak01 = g_fak_fak01[l_i] 
              AND fak02 = g_fak[l_i].fak02 
              AND fak022 = g_fak[l_i].fak022
          #DELETE FROM fak_file WHERE fak01 = g_fak_fak01[l_i] AND fak02 = g_fak[l_i].fak02 AND fak022 = g_fak[l_i].fak022
           #----------------MOD-CA0163------------------(S)
            UPDATE faj_file
               SET faj92 = g_faj.faj02,
                   faj921 = g_faj.faj022
             WHERE faj01 = g_faj.faj01
               AND faj02 = g_faj.faj02
               AND faj021 = g_faj.faj021
           #----------------MOD-CA0163------------------(E)
   END CASE
END FUNCTION
   
FUNCTION p110_ins1()
DEFINE l_no               LIKE type_file.num10,   #MOD-650066       #No.FUN-680070 DECIMAL(10,0)
       l_j,l_accd         LIKE type_file.num5,    #No.FUN-680070 SMALLINT
       l_len,l_bn,l_en    LIKE type_file.num5,    #No.FUN-680070 SMALLINT
       l_cnt              LIKE type_file.num5,    #No.FUN-680070 SMALLINT
       l_fab23            LIKE fab_file.fab23,    #殘值率 NO.A032
       l_fab232           LIKE fab_file.fab232,   #殘值率    #No:FUN-AB0088
       l_faj01            LIKE faj_file.faj01,
       l_faj02,l_seno     LIKE faj_file.faj02
DEFINE l_str              STRING                  #MOD-B10015
DEFINE l_faj06            LIKE faj_file.faj06     #MOD-B20045
 
   IF t_fak.fak17 IS NOT NULL THEN
      LET g_faj.faj14=t_fak.fak14/t_fak.fak17    #本幣成本
      LET g_faj.faj35 = t_fak.fak35/t_fak.fak17                      #MOD-C30855 add
      CALL cl_digcut(g_faj.faj14,g_azi04) RETURNING g_faj.faj14      #MOD-A30244 add
      CALL cl_digcut(g_faj.faj35,g_azi04) RETURNING g_faj.faj35      #MOD-C30855 add
      LET g_faj.faj62=t_fak.fak62/t_fak.fak17    #MOD-680007
      LET g_faj.faj16=t_fak.fak16/t_fak.fak17    #原幣成本
#No.MOD-B40211 --begin
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = t_fak.fak15
      CALL cl_digcut(g_faj.faj16,t_azi04) RETURNING g_faj.faj16
#No.MOD-B40211 --end
      IF NOT cl_null(g_faj.faj32) THEN
         LET g_faj.faj32=t_fak.fak32/t_fak.fak17  #累計折舊
      END IF
      #-----MOD-680007---------
      IF NOT cl_null(g_faj.faj67) THEN
         LET g_faj.faj67=t_fak.fak67/t_fak.fak17  #累計折舊
      END IF
      #-----END MOD-680007-----
      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         LET g_faj.faj142=t_fak.fak142/t_fak.fak17    #本幣成本
         #CALL cl_digcut(g_faj.faj142,g_azi04) RETURNING g_faj.faj142 #CHI-C60010 mark
         IF NOT cl_null(g_faj.faj322) THEN
            LET g_faj.faj322=t_fak.fak322/t_fak.fak17  #累計折舊
         END IF
         LET g_faj.faj352 = t_fak.fak352/t_fak.fak17                    #MOD-C30855 add
         #CALL cl_digcut(g_faj.faj352,g_azi04) RETURNING g_faj.faj352   #MOD-C30855 add #CHI-C60010 mark
      END IF
      #-----No:FUN-AB0088 END-----

   END IF
   #--->預留殘值計算
   #No:A099
   IF g_aza.aza26 = '2' THEN                                                   
      SELECT fab23 INTO l_fab23  FROM fab_file WHERE fab01 = g_faj.faj04       
      IF SQLCA.sqlcode THEN                                                    
#        CALL cl_err(l_fab23,SQLCA.sqlcode,0)                                  #No.FUN-660136
#        CALL cl_err3("sel","fab_file",g_faj.faj04,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136 #No.FUN-710028
         CALL s_errmsg('fab01',g_faj.faj04,l_fab23,SQLCA.sqlcode,1)            #No.FUN-710028  
         LET g_success = 'N' RETURN                                            
      END IF                                                                   
      IF g_faj.faj28 MATCHES '[05]' THEN                                       
         LET g_faj.faj31 = 0                                                   
         LET g_faj.faj66 = 0   #MOD-680007
      ELSE                                                                     
#         LET g_faj.faj31 = (g_faj.faj14-g_faj.faj32)*l_fab23/100                #MOD-A40033 mark
#         LET g_faj.faj66 = (g_faj.faj62-g_faj.faj67)*l_fab23/100    #MOD-680007 #MOD-A40033 mark
          LET g_faj.faj31 = g_faj.faj14*l_fab23/100                #MOD-A40033 
          LET g_faj.faj66 = g_faj.faj62*l_fab23/100                #MOD-A40033 
      END IF        
      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         SELECT fab232 INTO l_fab232  FROM fab_file WHERE fab01 = g_faj.faj04
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('fab01',g_faj.faj04,l_fab232,SQLCA.sqlcode,1)
            LET g_success = 'N' RETURN
         END IF
         IF g_faj.faj282 MATCHES '[05]' THEN
            LET g_faj.faj312 = 0
         ELSE
             LET g_faj.faj312 = g_faj.faj142*l_fab232/100
         END IF
      END IF
      #-----No:FUN-AB0088 END-----                                                           
   ELSE       
      CASE g_faj.faj28
         WHEN '0'   LET g_faj.faj31 = 0
         WHEN '1'   LET g_faj.faj31 =
                       (g_faj.faj14-g_faj.faj32)/(g_faj.faj29 + 12)*12
         WHEN '2'   LET g_faj.faj31 = 0
         WHEN '3'   LET g_faj.faj31 = (g_faj.faj14-g_faj.faj32)/10
         WHEN '4'   LET g_faj.faj31 = 0
         WHEN '5'   LET g_faj.faj31 = 0
         OTHERWISE EXIT CASE
      END CASE
      #-----MOD-680007---------
      CASE g_faj.faj61
         WHEN '0'   LET g_faj.faj66 = 0
         WHEN '1'   LET g_faj.faj66 =
                       (g_faj.faj62-g_faj.faj67)/(g_faj.faj64 + 12)*12
         WHEN '2'   LET g_faj.faj66 = 0
         WHEN '3'   LET g_faj.faj66 = (g_faj.faj62-g_faj.faj67)/10
         WHEN '4'   LET g_faj.faj66 = 0
         WHEN '5'   LET g_faj.faj66 = 0
         OTHERWISE EXIT CASE
      END CASE
      #-----END MOD-680007-----
      #-----No:FUN-AB0088-----
      IF g_faa.faa31 = 'Y' THEN
         CASE g_faj.faj282
            WHEN '0'   LET g_faj.faj312 = 0
            WHEN '1'   LET g_faj.faj312 =
                          (g_faj.faj142-g_faj.faj322)/(g_faj.faj292 + 12)*12
            WHEN '2'   LET g_faj.faj312 = 0
            WHEN '3'   LET g_faj.faj312 = (g_faj.faj142-g_faj.faj322)/10
            WHEN '4'   LET g_faj.faj312 = 0
            WHEN '5'   LET g_faj.faj312 = 0
            OTHERWISE EXIT CASE
         END CASE
      END IF
      #-----No:FUN-AB0088 END-----
   END IF
   #end No:A099
  #LET g_faj.faj31 = g_faj.faj31/t_fak.fak17  #MOD-970176   #MOD-A10071 mark
  #LET g_faj.faj66 = g_faj.faj66/t_fak.fak17  #MOD-970176   #MOD-A10071 mark            
   CALL cl_digcut(g_faj.faj31,g_azi04) RETURNING g_faj.faj31
   CALL cl_digcut(g_faj.faj66,g_azi04) RETURNING g_faj.faj66   #MOD-680007
  #LET g_faj.faj33 = g_faj.faj14 - g_faj.faj32 - g_faj.faj31
   LET g_faj.faj33 = g_faj.faj14 - g_faj.faj32
   LET g_faj.faj68 = g_faj.faj62 - g_faj.faj67   #MOD-680007

   #-----No:FUN-AB0088-----
   IF g_faa.faa31 = 'Y' THEN
      #CALL cl_digcut(g_faj.faj312,g_azi04) RETURNING g_faj.faj312 #CHI-C60010 mark
      LET g_faj.faj332 = g_faj.faj142 - g_faj.faj322
   END IF
   #-----No:FUN-AB0088 END-----

   FOR l_j=1 TO t_fak.fak17
      #--->財產編號
     #CHI-A30037
     #IF g_aza.aza31 = 'Y' THEN              #CHI-B70009 mark
      IF g_aza.aza31 = 'Y' AND l_j = 1 THEN  #CHI-B70009
         IF cl_null(g_faj.faj02) THEN        #MOD-CA0196 add
            LET l_faj06 = NULL  #MOD-B20045 
           #CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06 #MOD-B20045 mark 
            CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,l_faj06     #MOD-B20045
           #-MOD-B20045-add-
            IF cl_null(g_faj.faj06) THEN  
               LET g_faj.faj06 = l_faj06
            END IF
           #-MOD-B20045-end-
            END IF                              #MOD-CA0196 add
         LET g_fak90 = g_faj.faj02    #MOD-CA0163 add
         LET g_fak901 = ' '           #MOD-CA0163 add
      ELSE
        #----------------MOD-CA0163-------------(S)
         IF l_j = 1 THEN
            LET g_fak90 = g_faj.faj02
            LET g_fak901 = ' '
         END IF
        #----------------MOD-CA0163-------------(E)
     #CHI-A30037
         LET l_faj02= g_faj.faj02
         LET l_len  = LENGTH(l_faj02)
         LET l_bn   = l_len - g_faa.faa21
         LET l_en   = l_bn  + 1
         LET l_accd = g_faa.faa21
         LET l_str = ''              #MOD-B10015 
         #No:6971 03/07/14 By Wiky 若l_bn <=0 且進入下面l_j !=1時會當出來
         IF cl_null(g_faj.faj02) THEN                 #MOD-CA0196 add
            IF l_j != 1 AND l_bn>0 THEN 
               CALL p110_ins1_faj02(l_faj02) RETURNING l_seno   #MOD-960147 add
              #-MOD-B10015-add- 
               LET l_str = l_seno
               IF l_str.getindexof("*", 1) > 0 THEN
                  CALL s_errmsg('','','','afa-510',1) 
                  LET g_success='N' 
                  EXIT FOR
               END IF
              #-MOD-B10015-add- 
               LET g_faj.faj02 = l_seno    
            ELSE
               LET g_faj.faj02 = l_faj02
            END IF
         END IF                              #MOD-CA0196 add
         IF NOT cl_null(g_faj.faj02) THEN  #MOD-9C0269 add
           #str MOD-960147 add
            LET l_cnt = 0
            WHILE TRUE                                     #MOD-AB0125
               SELECT COUNT(*) INTO l_cnt FROM faj_file
                WHERE faj02 = g_faj.faj02
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN   #已存在此財產編號
                  CALL p110_ins1_faj02(g_faj.faj02) RETURNING l_seno
                 #-MOD-B10015-add- 
                  LET l_str = l_seno
                  IF l_str.getindexof("*", 1) > 0 THEN
                     EXIT WHILE   
                  END IF
                 #-MOD-B10015-add- 
                  LET g_faj.faj02 = l_seno    
               ELSE                                        #MOD-AB0125
                  EXIT WHILE                               #MOD-AB0125
               END IF
            END WHILE                                      #MOD-AB0125
           #-MOD-B10015-add- 
            IF l_str.getindexof("*", 1) > 0 THEN
               CALL s_errmsg('','','','afa-510',1) 
               LET g_success='N' 
               EXIT FOR
            END IF
           #-MOD-B10015-add- 
           #end MOD-960147 add
         END IF                    #MOD-9C0269 add
         #-->取最大序號
      END IF    #CHI-A30037 add
      IF l_j = 1 THEN                                                     #MOD-A90159
         IF g_faa.faa03 = 'Y' AND cl_null(g_faj_t.faj01) THEN  #自動編號#TQC-A40034
            SELECT faa031 INTO l_faj01 FROM faa_file          #TQC-A40034
            IF cl_null(l_faj01) THEN LET l_faj01 = 0  END IF  #TQC-A40034
           #LET g_faj.faj01 = l_faj01 + 1 USING '&&&&&&&&&&'  #TQC-A40034 #MOD-A90159 mark
         ELSE                         #TQC-A40034
            SELECT MAX(faj01) INTO l_faj01 FROM faj_file  
            IF cl_null(l_faj01) THEN LET l_faj01 = 0  END IF  #No:8068
           #LET g_faj.faj01 = l_faj01 + 1 USING '&&&&&&&&&&'              #MOD-A90159 mark
         END IF                      #TQC-A40034
      END IF                                                              #MOD-A90159
     #LET g_faj.faj01 = l_faj01                                           #MOD-A90159 #MOD-B40118 mark
      LET l_faj01 = l_faj01 + 1 USING '&&&&&&&&&&'                        #MOD-A90159
      LET g_faj.faj01 = l_faj01                      #MOD-B40118 
      #-->數量
      LET g_faj.faj17 = 1                          
      IF g_faj.faj022 IS NULL THEN LET g_faj.faj022 = ' ' END IF
      message g_faj.faj01,' ',g_faj.faj02,' ',g_faj.faj022
      CALL ui.Interface.refresh()
      #start FUN-5B0104
      IF g_faa.faa05 = 'N' THEN    #TQC-7B0049 
         IF cl_null(g_faj.faj02) THEN
            #財產編號依參數設定自動取號錯誤!,請檢查是否有異常財編!
#           CALL cl_err('','afa-510',1)           #No.FUN-710028
            CALL s_errmsg('','','','afa-510',1)   #No.FUN-710028
            LET g_success='N'
            EXIT FOR
         END IF
      #end FUN-5B0104
         #-->檢查財編是否存在
         SELECT count(*) INTO l_cnt FROM faj_file
          WHERE faj02 = g_faj.faj02
            AND faj022= g_faj.faj022
         IF l_cnt > 0 THEN 
#           CALL cl_err(g_faj.faj02,'afa-105',1) LET g_success='N' #No.FUN-710028 
            LET g_showmsg = g_faj.faj02,"/",g_faj.faj022           #No,FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,g_faj.faj02,'afa-105',1) LET g_success='N' #No.FUN-710028
            EXIT FOR 
         END IF
      END IF 
      IF cl_null(g_faj.faj203) THEN LET g_faj.faj203 = 0 END IF
      IF cl_null(g_faj.faj204) THEN LET g_faj.faj204 = 0 END IF
      IF cl_null(g_faj.faj331) THEN LET g_faj.faj331 = 0 END IF #MOD-970176                                                         
      IF cl_null(g_faj.faj681) THEN LET g_faj.faj681 = 0 END IF #MOD-970176  
      LET g_faj.faj93 = t_fak.fak93   #No.FUN-9A0036   
      LET g_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
      LET g_faj.fajorig = g_grup      #No.FUN-980030 10/01/04

      #-----No:FUN-AB0088-----
      #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088     
         IF cl_null(g_faj.faj2032) THEN LET g_faj.faj2032 = 0 END IF
         IF cl_null(g_faj.faj2042) THEN LET g_faj.faj2042 = 0 END IF
         IF cl_null(g_faj.faj3312) THEN LET g_faj.faj3312 = 0 END IF
      #END IF                                       
      #-----No:FUN-AB0088 END-----
     #MOD-A30244---add---
      IF l_j = t_fak.fak17 THEN
         IF (g_faj.faj14*t_fak.fak17) != t_fak.fak14  THEN
            LEt g_faj.faj14 = g_faj.faj14 - (g_faj.faj14*t_fak.fak17 -t_fak.fak14)
         END IF
#No.MOD-B40211 --begin
         IF (g_faj.faj16*t_fak.fak17) != t_fak.fak16  THEN
            LEt g_faj.faj16 = g_faj.faj16 - (g_faj.faj16*t_fak.fak17 -t_fak.fak16)
         END IF
#No.MOD-B40211 --end
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN
            IF (g_faj.faj142*t_fak.fak17) != t_fak.fak142  THEN
               LET g_faj.faj142 = g_faj.faj142 - (g_faj.faj142*t_fak.fak17 -t_fak.fak142)
            END IF
         END IF
         #-----No:FUN-AB0088 END-----
      END IF    
     #MOD-A30244---add---
      #No.MOD-B80229  --Begin
      IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF
      #No.MOD-B80229  --End
#CHI-C60010--add--str--
      IF g_faa.faa31='Y' THEN
         LET g_faj.faj142=cl_digcut(g_faj.faj142,g_azi04_1)
         LET g_faj.faj312=cl_digcut(g_faj.faj312,g_azi04_1)
         LET g_faj.faj322=cl_digcut(g_faj.faj322,g_azi04_1)
         LET g_faj.faj332=cl_digcut(g_faj.faj332,g_azi04_1)
         LET g_faj.faj352=cl_digcut(g_faj.faj352,g_azi04_1)
      END IF
#CHI-C60010--add--end
     #----------------------MOD-CA0163-----------------(S)
      LET g_faj.faj92 = g_fak90
      LET g_faj.faj921 = g_fak901
     #----------------------MOD-CA0163-----------------(E)
      INSERT INTO faj_file VALUES(g_faj.*)
      IF SQLCA.sqlcode  THEN 
#        CALL cl_err('ins1_err',STATUS,1)      #No.FUN-660136
#        CALL cl_err3("ins","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","ins1_err",1)   #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = g_faj.faj01,"/",g_faj.faj02,"/",g_faj.faj022                         #No.FUN-710028
         CALL s_errmsg('faj01,faj02,faj022',g_showmsg,'ins1_err',STATUS,1)  #No.FUN-710028
         LET g_success='N' 
         EXIT FOR 
      END IF
      #---add by kitty 99-04-30
    # IF t_fak.fak92='Y' THEN
    #    CALL p110_ins_fcx()
    # END IF
   END FOR
   IF g_success = 'Y' THEN 
      UPDATE faa_file SET faa031 = g_faj.faj01 WHERE faa00 = '0'
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('upd faa031',STATUS,1)     #No.FUN-660136
         CALL cl_err3("upd","faa_file","","",STATUS,"","upd faa031",1)   #No.FUN-660136 #No.FUN-710028
         CALL s_errmsg('faa00','0','upd faa031',STATUS,1)                #No.FUN-710028 
         LET g_success='N'
      END IF
   END IF
END FUNCTION
   
#str MOD-960147 add
FUNCTION p110_ins1_faj02(l_faj02)
   DEFINE l_faj02,l_seno     LIKE faj_file.faj02,
          l_j,l_accd         LIKE type_file.num5,
          l_len,l_bn,l_en    LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5   #No.MOD-B40257
             
  #-TQC-B70023-add-
   IF cl_null(l_faj02) THEN 
      RETURN ' '
   END IF
  #-TQC-B70023-end-
   LET l_len  = LENGTH(l_faj02)
   LET l_bn   = l_len - g_faa.faa21
   LET l_en   = l_bn  + 1
   LET l_accd = g_faa.faa21   #底稿拋轉後的財產編號後幾碼為流水號
   CASE 
      WHEN l_accd = '1'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&'
      WHEN l_accd = '2'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&'
      WHEN l_accd = '3'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&'
      WHEN l_accd = '4'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&'
      WHEN l_accd = '5'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&'
      WHEN l_accd = '6'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&&'
      WHEN l_accd = '7'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&&&'
      WHEN l_accd = '8'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&&&&'
      WHEN l_accd = '9'  LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&&&&&'
      WHEN l_accd = '10' LET l_seno = l_faj02[1,l_bn],
                             l_faj02[l_en,l_len] + 1 USING '&&&&&&&&&&'
      OTHERWISE EXIT CASE 
   END CASE
#No.MOD-B40257 --begin
     SELECT COUNT(*) INTO l_cnt FROM faj_file
      WHERE faj02 = l_seno     
     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
     IF l_cnt > 0 THEN   #已存在此財產編號
        CALL p110_ins1_faj02(l_seno) RETURNING l_seno 
        RETURN l_seno 
     ELSE 
     	RETURN l_seno        
     END IF
#   RETURN l_seno
#No.MOD-B40257 --end
 
END FUNCTION
#end MOD-960147 add
 
FUNCTION p110_ins2()
DEFINE l_mxno LIKE type_file.chr20     #No.FUN-680070 VARCHAR(10)
DEFINE l_no   LIKE type_file.num10     #MOD-650066    #No.FUN-680070 DECIMAL(10,0)
DEFINE l_cnt  LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE l_faj06  LIKE faj_file.faj06    #MOD-B20045
#No.MOD-B40211 --begin
DEFINE l_faj01  LIKE faj_file.faj01
DEFINE l_faj13  LIKE faj_file.faj13
#No.MOD-B40211 --end
 
   IF g_fak[l_i].fak901 IS NULL THEN LET g_fak[l_i].fak901 = ' ' END IF
   SELECT * FROM faj_file WHERE faj02=g_fak[l_i].fak90 
                            AND faj022=g_fak[l_i].fak901
   IF SQLCA.sqlcode THEN
      LET g_faj.faj02=g_fak[l_i].fak90
      LET g_faj.faj022=g_fak[l_i].fak901
      IF g_faa.faa03 = 'Y' AND cl_null(g_faj_t.faj01) THEN  #自動編號#TQC-A40034
         SELECT faa031 INTO l_mxno FROM faa_file          #TQC-A40034
         IF cl_null(l_mxno) THEN LET l_mxno = 0 END IF    #TQC-A40034
         LET l_no = l_mxno                                #TQC-A40034
         LET g_faj.faj01=l_no+1 USING '&&&&&&&&&&'        #TQC-A40034
      ELSE                                                #TQC-A40034
         SELECT MAX(faj01) INTO l_mxno FROM faj_file
         IF cl_null(l_mxno) THEN LET l_mxno = 0 END IF
         LET l_no = l_mxno 
         LET g_faj.faj01=l_no+1 USING '&&&&&&&&&&'
      END IF                                              #TQC-A40034
      IF g_faj.faj022 IS NULL THEN LET g_faj.faj022 = ' ' END IF
      message g_faj.faj01,' ',g_faj.faj02,' ',g_faj.faj022
      CALL ui.Interface.refresh()
    #---------- --------------------MOD-C80057----------------------mark
    ##CHI-A30037---add---start---
    # IF g_aza.aza31 = 'Y' THEN
    #    LET l_faj06 = NULL  #MOD-B20045 
    #   #CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06 #MOD-B20045 mark 
    #    CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,l_faj06     #MOD-B20045
    #   #-MOD-B20045-add-
    #    IF cl_null(g_faj.faj06) THEN  
    #       LET g_faj.faj06 = l_faj06
    #    END IF
    #   #-MOD-B20045-end-
    #    LET g_fak[l_i].fak90  = g_faj.faj02   #MOD-AB0044 
    #    LET g_fak[l_i].fak901 = g_faj.faj022  #MOD-AB0044
    # END iF
    ##CHI-A30037---add---end---
    #--MOD-C80057--(S)
      IF g_aza.aza31 = 'Y' THEN
         IF cl_null(g_faj.faj06) THEN
            LET g_faj.faj06 = g_faj06
         END IF
      END IF
    #--MOD-C80057--(E)
    #------------------------------MOD-C80057----------------------mark
     #start FUN-5B0104
      IF g_faa.faa05 = 'N' THEN    #TQC-7B0049 
         IF cl_null(g_faj.faj02) THEN
            #財產編號依參數設定自動取號錯誤!,請檢查是否有異常財編!
#           CALL cl_err('','afa-510',1)           #No.FUN-710028                                                                       
            CALL s_errmsg('','','','afa-510',1)   #No.FUN-710028
            LET g_success='N'
            RETURN
         END IF
     #end FUN-5B0104
         #-->檢查財編是否存在
         SELECT count(*) INTO l_cnt FROM faj_file
          WHERE faj02 = g_faj.faj02
            AND faj022= g_faj.faj022
         IF l_cnt > 0 THEN 
#           CALL cl_err(g_faj.faj02,'afa-105',1) LET g_success='N' #No.FUN-710028                                                      
            LET g_showmsg = g_faj.faj02,"/",g_faj.faj022           #No,FUN-710028                                                      
            CALL s_errmsg('faj02,faj022',g_showmsg,g_faj.faj02,'afa-105',1) LET g_success='N' #No.FUN-710028
            RETURN   
         END IF
      END IF
      IF cl_null(g_faj.faj203) THEN LET g_faj.faj203 = 0 END IF
      IF cl_null(g_faj.faj204) THEN LET g_faj.faj204 = 0 END IF
      IF cl_null(g_faj.faj331) THEN LET g_faj.faj331 = 0 END IF #MOD-970176                                                         
      IF cl_null(g_faj.faj681) THEN LET g_faj.faj681 = 0 END IF #MOD-970176  
      LET g_faj.faj93 = t_fak.fak93   #No.FUN-9A0036           
      LET g_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
      LET g_faj.fajorig = g_grup      #No.FUN-980030 10/01/04

      #-----No:FUN-AB0088-----
      #IF g_faa.faa31 = 'Y' THEN           
         IF cl_null(g_faj.faj2032) THEN LET g_faj.faj2032 = 0 END IF
         IF cl_null(g_faj.faj2042) THEN LET g_faj.faj2042 = 0 END IF
         IF cl_null(g_faj.faj3312) THEN LET g_faj.faj3312 = 0 END IF
      #END IF                             
      #-----No:FUN-AB0088 END-----
      LET g_faj.faj17 =1    #No.FUN-B50035
      #No.MOD-B80229  --Begin
      IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF
      #No.MOD-B80229  --End
#No.MOD-C20120 --begin
      LET g_faj.faj92=''
      LET g_faj.faj921=''
      LET g_faj.faj922=''   
#No.MOD-C20120 --end 
#CHI-C60010--add--str--
      IF g_faa.faa31='Y' THEN
         LET g_faj.faj142=cl_digcut(g_faj.faj142,g_azi04_1)
         LET g_faj.faj312=cl_digcut(g_faj.faj312,g_azi04_1)
         LET g_faj.faj322=cl_digcut(g_faj.faj322,g_azi04_1)
         LET g_faj.faj332=cl_digcut(g_faj.faj332,g_azi04_1)
         LET g_faj.faj352=cl_digcut(g_faj.faj352,g_azi04_1)
      END IF
#CHI-C60010--add--end
      INSERT INTO faj_file VALUES(g_faj.*)
      IF SQLCA.sqlcode THEN 
#        CALL cl_err('ins2_err',STATUS,1)     #No.FUN-660136
#        CALL cl_err3("ins","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","ins2_err",1)  #No.FUN-660136 #No.FUN-710028                                                    
         LET g_showmsg = g_faj.faj01,"/",g_faj.faj02,"/",g_faj.faj022                         #No.FUN-710028                                                    
         CALL s_errmsg('faj01,faj02,faj022',g_showmsg,'ins2_err',STATUS,1)  #No.FUN-710028
         LET g_success='N'
      END IF
      UPDATE faa_file SET faa031 = g_faj.faj01 WHERE faa00 = '0'
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('upd faa031',STATUS,1)     #No.FUN-660136
#        CALL cl_err3("upd","faa_file","","",STATUS,"","upd faa031",1)   #No.FUN-660136 #No.FUN-710028
         CALL s_errmsg('faa00','0','upd faa031',STATUS,1)                #No.FUN710028
         LET g_success='N'
      END IF
#No.MOD-C20120 --begin
      IF cl_null(g_fak[l_i].fak90) THEN LET g_fak[l_i].fak90 = g_faj.faj02 END IF 
      IF cl_null(g_fak[l_i].fak901) THEN LET g_fak[l_i].fak901 = g_faj.faj022 END IF  
#No.MOD-C20120 --end
   ELSE
#      UPDATE faj_file SET faj13=((faj14+t_fak.fak14)/(faj17+t_fak.fak17)),    #本幣單價    #No.MOD-470589
      UPDATE faj_file SET faj13=(faj14+t_fak.fak14),    #本幣單價    #No.MOD-470589         #No.MOD-B50035
                          faj14=faj14+t_fak.fak14,    #本幣成本 
                          faj16=faj16+t_fak.fak16,    #原幣成本 
#                          faj17=faj17+t_fak.fak17,    #數量    #No.FUN-B50035
                          faj31=faj31+t_fak.fak31,    #預留殘值
                          faj33=faj33+t_fak.fak33,    #未折減額
                          faj62=faj62+t_fak.fak62,    #稅簽成本 
                          faj66=faj66+t_fak.fak66,    #稅簽預留殘值   #MOD-7C0182
                          faj68=faj68+t_fak.fak68,    #稅簽未折減額   #MOD-7C0182
                          faj142=faj142+t_fak.fak142,    #本幣成本(財簽二)   #No:FUN-AB0088
                          faj312=faj312+t_fak.fak312,    #預留殘值(財簽二)   #No:FUN-AB0088
                          faj332=faj332+t_fak.fak332     #未折減額(財簽二)   #No:FUN-AB0088
                    WHERE faj02=g_fak[l_i].fak90 
                      AND faj022=g_fak[l_i].fak901
                      AND faj43 = '0' 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#        CALL cl_err('upd2_err',STATUS,1)     #No.FUN-660136
#        CALL cl_err3("upd","faj_file",g_fak[l_i].fak90,g_fak[l_i].fak901,STATUS,"","upd2_err",1)   #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = g_fak[l_i].fak90,"/",g_fak[l_i].fak901,"/",'0'    #No.FUN-710028
         CALL s_errmsg('faj02,faj022,faj43',g_showmsg,'upd2_err',STATUS,1) #No.FUN-710028
         LET g_success='N'
      END IF
#No.MOD-B40211 --begin
      DECLARE p110_sel_faj CURSOR FOR 
        SELECT faj01,faj13 FROM faj_file 
         WHERE faj02=g_fak[l_i].fak90 
           AND faj022=g_fak[l_i].fak901
           AND faj43 = '0' 
      FOREACH p110_sel_faj INTO l_faj01,l_faj13
        CALL cl_digcut(l_faj13,g_azi04) RETURNING l_faj13
        UPDATE faj_file SET faj13= l_faj13
                    WHERE faj02=g_fak[l_i].fak90 
                      AND faj022=g_fak[l_i].fak901
                      AND faj43 = '0' 
                      AND faj01 = l_faj01
      END FOREACH 
#No.MOD-B40211 --end
     #---add by kitty 99-04-30
     #IF t_fak.fak92='Y' THEN
     #   SELECT * INTO g_faj.* FROM faj_file WHERE faj02=g_fak[l_i].fak90 
     #                                         AND faj022=g_fak[l_i].fak901
     #   CALL p110_ins_fcx()
     #END IF
   END IF
END FUNCTION
   
FUNCTION p110_ins3()
DEFINE l_mxno LIKE type_file.chr20    #No.FUN-680070 VARCHAR(10)
DEFINE l_no LIKE type_file.num10      #MOD-650066    #No.FUN-680070 DECIMAL(10,0)
DEFINE l_faj06  LIKE faj_file.faj06   #MOD-B20045
DEFINE l_cnt    LIKE type_file.num5   #No.MOD-B40257
DEFINE l_len,l_bn,l_en    LIKE type_file.num5    #CHI-B70009
DEFINE l_seno             LIKE faj_file.faj02    #CHI-B70009

   IF g_faa.faa03 = 'Y' AND cl_null(g_faj_t.faj01) THEN  #自動編號#TQC-A40034
      SELECT faa031 INTO l_mxno FROM faa_file          #TQC-A40034
      IF cl_null(l_mxno) THEN LET l_mxno = 0 END IF    #TQC-A40034
      LET l_no = l_mxno                                #TQC-A40034
      LET g_faj.faj01=l_no+1 USING '&&&&&&&&&&'        #TQC-A40034
   ELSE                                                #TQC-A40034 
      SELECT MAX(faj01) INTO l_mxno FROM faj_file
      IF cl_null(l_mxno) THEN LET l_mxno = 0 END IF
      LET l_no = l_mxno 
      LET g_faj.faj01=l_no+1 USING '&&&&&&&&&&'
   END IF                                              #TQC-A40034
   IF g_faj.faj022 IS NULL THEN LET g_faj.faj022 = ' ' END IF
   message g_faj.faj01,' ',g_faj.faj02,' ',g_faj.faj022
   CALL ui.Interface.refresh()
  #CHI-A30037---add---start---
  #IF g_aza.aza31 = 'Y' THEN                   #CHI-B70009 mark
   IF g_aza.aza31 = 'Y' AND g_chki = l_i THEN  #CHI-B70009
      IF cl_null(g_faj.faj02) THEN             #MOD-CA0196 add
         LET l_faj06 = NULL  #MOD-B20045 
        #CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj.faj06 #MOD-B20045 mark 
         CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,l_faj06     #MOD-B20045
        #-MOD-B20045-add-
         IF cl_null(g_faj.faj06) THEN  
            LET g_faj.faj06 = l_faj06
         END IF
        #-MOD-B20045-end-
         END IF                                   #MOD-CA0196 add
      LET g_faj02= g_faj.faj02   #CHI-B70009
#No.MOD-B40257 --begin
   ELSE 
     #-CHI-B70009-add-
     #IF g_aza.aza31 = 'Y' THEN                               #MOD-CA0196 mark 
      IF g_aza.aza31 = 'Y' AND cl_null(g_faj.faj02) THEN      #MOD-CA0196 add
         LET l_len  = LENGTH(g_faj02)
         LET l_bn   = l_len - g_faa.faa21
         IF cl_null(g_faj.faj02) THEN                 #MOD-CA0196 add
           #若l_bn <=0 且進入下面l_i !=1時會當出來
           IF l_i != 1 AND l_bn>0 THEN 
              CALL p110_ins1_faj02(g_faj02) RETURNING l_seno 
              LET g_faj.faj02 = l_seno    
           ELSE
              LET g_faj.faj02 = g_faj02
           END IF
         END IF                                        #MOD-CA0196 add
         IF NOT cl_null(g_faj.faj02) THEN 
            LET l_cnt = 0
            WHILE TRUE          
               SELECT COUNT(*) INTO l_cnt FROM faj_file
                WHERE faj02 = g_faj.faj02
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN   #已存在此財產編號
                  CALL p110_ins1_faj02(g_faj.faj02) RETURNING l_seno
                  LET g_faj.faj02 = l_seno    
               ELSE                
                  EXIT WHILE     
               END IF
            END WHILE                                     
         END IF                      
      ELSE
     #-CHI-B70009-end-
         SELECT COUNT(*) INTO l_cnt FROM faj_file
          WHERE faj02 = g_faj.faj02
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt > 0 THEN   #已存在此財產編號
            CALL p110_ins1_faj02(g_faj.faj02) RETURNING g_faj.faj02
         END IF 
      END IF      #CHI-B70009 
#No.MOD-B40257 --end
   END iF
  #CHI-A30037---add---end---
   #start FUN-5B0104
   IF g_faa.faa05 = 'N' THEN    #TQC-7B0049 
      IF cl_null(g_faj.faj02) THEN
         #財產編號依參數設定自動取號錯誤!,請檢查是否有異常財編!
#        CALL cl_err('','afa-510',1)         #No.FUN-710028
         CALL s_errmsg('','','','afa-510',1) #No.FUN-710028
         LET g_success='N'
         RETURN
      END IF
   #end FUN-5B0104
##No.2919 modify 1998/12/14
      SELECT COUNT(*) INTO g_cnt FROM faj_file
       WHERE faj02 = g_faj.faj02
         AND faj022 = g_faj.faj022
      IF g_cnt > 0 THEN
#        CALL cl_err('ins3-sel','afa-105',1)            #No.FUN-710028
         LET g_showmsg = g_faj.faj02,"/",g_faj.faj022   #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'ins3-sel','afa-105',1) #No.FUN-710028
         LET g_success = 'N'
      END IF
   END IF
   IF cl_null(g_faj.faj203) THEN LET g_faj.faj203 = 0 END IF
   IF cl_null(g_faj.faj204) THEN LET g_faj.faj204 = 0 END IF
   IF cl_null(g_faj.faj331) THEN LET g_faj.faj331 = 0 END IF #MOD-970176                                                         
   IF cl_null(g_faj.faj681) THEN LET g_faj.faj681 = 0 END IF #MOD-970176  
##----------------------------
   LET g_faj.faj93 = t_fak.fak93   #No.FUN-9A0036 
   LET g_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
   LET g_faj.fajorig = g_grup      #No.FUN-980030 10/01/04
   #-----No:FUN-AB0088-----
   #IF g_faa.faa31 = 'Y' THEN          
      IF cl_null(g_faj.faj2032) THEN LET g_faj.faj2032 = 0 END IF
      IF cl_null(g_faj.faj2042) THEN LET g_faj.faj2042 = 0 END IF
      IF cl_null(g_faj.faj3312) THEN LET g_faj.faj3312 = 0 END IF
   #END IF                            
   #-----No:FUN-AB0088 END-----
   #No.MOD-B80229  --Begin
   IF cl_null(g_faj.faj312) THEN LET g_faj.faj312 = 0 END IF
   #No.MOD-B80229  --End
#CHI-C60010--add--str--
   IF g_faa.faa31='Y' THEN
      LET g_faj.faj142=cl_digcut(g_faj.faj142,g_azi04_1)
      LET g_faj.faj312=cl_digcut(g_faj.faj312,g_azi04_1)
      LET g_faj.faj322=cl_digcut(g_faj.faj322,g_azi04_1)
      LET g_faj.faj332=cl_digcut(g_faj.faj332,g_azi04_1)
      LET g_faj.faj352=cl_digcut(g_faj.faj352,g_azi04_1)
   END IF
#CHI-C60010--add--end
   INSERT INTO faj_file VALUES(g_faj.*)
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('ins3_err',STATUS,1)     #No.FUN-660136
#     CALL cl_err3("ins","faj_file",g_faj.faj01,g_faj.faj02,STATUS,"","ins3_err",1)   #No.FUN-660136
      LET g_showmsg = g_faj.faj01,"/",g_faj.faj02,"/",g_faj.faj022      #No.FUN-710028
      CALL s_errmsg('faj01,faj02,faj022',g_showmsg,'ins3_err',STATUS,1) #No.FUN-710028
      LET g_success='N' 
   END IF
   #---add by kitty 99-04-30
  #IF t_fak.fak92='Y' THEN
  #   CALL p110_ins_fcx()
  #END IF
   UPDATE faa_file SET faa031 = g_faj.faj01 WHERE faa00 = '0'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd faa031',STATUS,1)     #No.FUN-660136
#     CALL cl_err3("upd","faa_file","","",STATUS,"","upd faa031",1)   #No.FUN-660136 #No.FUN-710028
      CALL s_errmsg('faa00','0','upd faa031',STATUS,1) #No.FUN-710028
      LET g_success='N'
   END IF
END FUNCTION
   
FUNCTION p110_body_fill()
   DEFINE l_wc    LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET l_wc="SELECT 'N',fak00,fak02,fak022,fak06,fak17,'N','N',fak90,fak901,",   
            " fak01 FROM fak_file WHERE ",g_wc CLIPPED,
            " AND fak91<>'Y' AND (fak02 IS NOT NULL OR fak02 <>'') "
   PREPARE p110_pre1 FROM l_wc
   DECLARE p110_cs1 CURSOR WITH HOLD FOR p110_pre1
 
   CALL g_fak.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1     #MOD-B70179 mod l_i -> g_cnt
   FOREACH p110_cs1 INTO g_fak[g_cnt].*,g_fak_fak01[g_cnt] #MOD-B70179 mod l_i -> g_cnt
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('_body_fill err',STATUS,0)
         LET g_success='N'
         EXIT FOREACH
      END IF
     #MOD-BA0218 -- mark begin --
     #IF cl_null(g_fak[g_cnt].fak90) THEN LET g_fak[g_cnt].fak90= ' ' END IF   #MOD-B70179 mod l_i -> g_cnt
     #IF cl_null(g_fak[g_cnt].fak901) THEN LET g_fak[g_cnt].fak901= ' ' END IF #MOD-B70179 mod l_i -> g_cnt
     #MOD-BA0218 -- mark end --
      #MOD-BA0218 -- begin --
      IF cl_null(g_fak[g_cnt].fak90) THEN
         IF NOT cl_null(g_fak[g_cnt].fak02) AND g_fak[g_cnt].fak02 != ' ' THEN
            LET g_fak[g_cnt].fak90 = g_fak[g_cnt].fak02
         ELSE
            LET g_fak[g_cnt].fak90= ' '
         END IF
      END IF
      IF cl_null(g_fak[g_cnt].fak901) THEN
         IF NOT cl_null(g_fak[g_cnt].fak022) AND g_fak[g_cnt].fak022 != ' ' THEN
            LET g_fak[g_cnt].fak901 = g_fak[g_cnt].fak022
         ELSE
            LET g_fak[g_cnt].fak901= ' '
         END IF
      END IF
      #MOD-BA0218 -- end --
      LET g_cnt = g_cnt +1                          #MOD-B70179 mod l_i -> g_cnt
      IF l_i > g_max_rec THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fak.deleteElement(g_cnt)  #MOD-B70179
   DISPLAY g_rec_b TO FORMONLY.cn2  #MOD-B70179 mod cn3 -> cn2
   LET l_i = 0  
END FUNCTION
   
FUNCTION p110_b()
   DEFINE p_cmd      LIKE type_file.chr1    #處理狀態       #No.FUN-680070 VARCHAR(1)
   DEFINE l_cnt      LIKE type_file.num5    #No.MOD-C20120
   DEFINE l_j        LIKE type_file.num10   #MOD-C80057 add

   LET g_faj_t.* = g_faj.*                                  #TQC-A40034
   LET g_action_choice = ""
   
   IF s_shut(0) THEN RETURN END IF
 
   INPUT ARRAY g_fak WITHOUT DEFAULTS FROM s_fak.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
            
      BEFORE INPUT 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         CALL p110_set_entry()
         CALL p110_set_no_entry()
         LET g_before_input_done = TRUE      
        #-MOD-B70179-add-
         IF g_edit = 'N' THEN
           LET l_ac= l_ac + 1         
           CALL fgl_set_arr_curr(l_ac)
         END IF
        #-MOD-B70179-end-
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         DISPLAY l_ac TO FORMONLY.cn3   
         CALL cl_show_fld_cont()         #FUN-550037(smin)
        #LET g_fak_t.* = g_fak[l_ac].*   #BACKUP
        # NEXT FIELD a
#------TQC-A40121------add
        #-MOD-B70179-mark-
        #IF g_edit = 'N' THEN
        #  LET l_ac= l_ac + 1      
        #  CALL fgl_set_arr_curr(l_ac)
        #END IF
        #-MOD-B70179-end-
#------TQC-A40121------end        

#TQC-AB0263--add--str--
      ON CHANGE a,splt,comb
         CALL p110_set_entry()
         CALL p110_set_no_entry()
#TQC-AB0263--add--end--

      BEFORE FIELD a
         CALL p110_set_entry()
         CALL p110_set_no_entry() #TQC-AB0263

      AFTER FIELD a
         CALL p110_set_entry() #TQC-AB0263
         CALL p110_set_no_entry()
 
      BEFORE FIELD splt
         CALL p110_set_entry()
         IF g_fak[l_ac].fak17='1' THEN     #NO:5213
            LET g_fak[l_ac].splt='N' 
            DISPLAY g_fak[l_ac].splt TO splt
         END IF
 
      AFTER FIELD splt
         CALL p110_set_no_entry()
 
      BEFORE FIELD comb
         CALL p110_set_entry()
 
      AFTER FIELD comb
         CALL p110_set_no_entry()
        #str MOD-AC0424 add
         IF g_fak[l_ac].comb='N' THEN
#No.MOD-C20120 --begin
            LET g_fak[l_ac].fak90 = ''
            LET g_fak[l_ac].fak901 = ''
#No.MOD-C20120 --end
            NEXT FIELD fak00
         END IF
        #end MOD-AC0424 add

      AFTER FIELD fak90
#No.MOD-C20120 --begin
#         IF cl_null(g_fak[l_ac].fak90) THEN LET g_fak[l_ac].fak90=' ' END IF
         IF g_fak[l_ac].a ='Y' AND g_fak[l_ac].comb ='Y' AND g_fak[l_ac].fak901 IS NOT NULL  THEN 
            SELECT COUNT(*) INTO l_cnt  
              FROM faj_file 
             WHERE faj02=g_fak[l_ac].fak90 
               AND faj022=g_fak[l_ac].fak901
         IF l_cnt > 0 THEN
            CALL cl_err('',-239,0)
            LET g_fak[l_ac].fak90 ='' 
            NEXT FIELD fak90
         END IF
         END IF 
#No.MOD-C20120 --end  
 
      AFTER FIELD fak901
         IF cl_null(g_fak[l_ac].fak901) THEN LET g_fak[l_ac].fak901=' ' END IF
#No.MOD-C20120 --begin
         IF g_fak[l_ac].a ='Y' AND g_fak[l_ac].comb ='Y' AND NOT cl_null(g_fak[l_ac].fak90) THEN 
            SELECT COUNT(*) INTO l_cnt  
              FROM faj_file 
             WHERE faj02=g_fak[l_ac].fak90 
               AND faj022=g_fak[l_ac].fak901
         IF l_cnt > 0 THEN
            CALL cl_err('',-239,0)
            LET g_fak[l_ac].fak901 ='' 
            NEXT FIELD fak90
         END IF
         END IF 
#No.MOD-C20120 --end 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

     #--------------------MOD-C80057------------(S)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(fak90)
               IF g_aza.aza31 = 'Y' AND cl_null(g_fak[l_ac].fak90) THEN
                  LET g_faj06 = NULL
                  CALL s_auno(g_faj.faj02,'4','') RETURNING g_faj.faj02,g_faj06
                  FOR l_j = l_ac TO g_fak.getLength()
                      IF g_fak[l_j].comb = 'Y' AND cl_null(g_fak[l_j].fak90) THEN
                         LET g_fak[l_j].fak90  = g_faj.faj02
                         LET g_fak[l_j].fak901 = ' '
                         DISPLAY BY NAME g_fak[l_j].fak90
                         DISPLAY BY NAME g_fak[l_j].fak901
                      ELSE
                         EXIT FOR
                      END IF
                  END FOR
               END IF
         END CASE
     #--------------------MOD-C80057------------(E)
    
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
        
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
      #No:FUN-B40065 --start--
      ON ACTION select_all
         CALL p110_sel_all_1("Y")
　	　	　	　	　	　	　	　	　	　	　	　	　	　	　
      ON ACTION select_non
         CALL p110_sel_all_1("N")
      #No:FUN-B40065 ---end---
 
   END INPUT
END FUNCTION

FUNCTION p110_sel_all_1(p_value)                                                                                                    
   DEFINE p_value   LIKE type_file.chr1                                                                                             
   DEFINE l_i       LIKE type_file.num10                                                                                            
                                                                                                                                    
   FOR l_i = 1 TO g_fak.getLength()
       LET g_fak[l_i].a = p_value                                                                                              
   END FOR                                                                                                                          
                                                                                                                                    
END FUNCTION
 
FUNCTION p110_set_entry()
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("a,splt,comb,fak90,fak901",TRUE)
   END IF
   IF INFIELD(a) THEN
      CALL cl_set_comp_entry("a,splt,comb,fak90,fak901",TRUE)
   END IF
   IF INFIELD(splt) THEN
      CALL cl_set_comp_entry("comb,fak90,fak901",TRUE)
   END IF
   IF INFIELD(comb) THEN
      CALL cl_set_comp_entry("splt,fak90,fak901",TRUE)
   END IF
END FUNCTION
 
FUNCTION p110_set_no_entry()
  #IF NOT g_before_input_done THEN  #Mark TQC-B20042
      IF g_fak[l_ac].fak17 = 1 THEN
         CALL cl_set_comp_entry("splt",FALSE)
      END IF
  #END IF  #Mark TQC-B20042
   IF INFIELD(a) THEN
      LET g_edit = 'Y'                          #No.TQC-A40027
      IF g_fak[l_ac].a = 'N' THEN
         #CALL cl_set_comp_entry("a,splt,comb,fak90,fak901",FALSE)
         CALL cl_set_comp_entry("splt,comb,fak90,fak901",FALSE) #TQC-AB0263
         LET g_edit = 'N'                       #No.TQC-A40027
      END IF
   END IF
   IF INFIELD(splt) THEN
      IF g_fak[l_ac].splt = 'Y' THEN
         CALL cl_set_comp_entry("comb,fak90,fak901",FALSE)
      END IF
   END IF
   IF INFIELD(comb) THEN
      IF g_fak[l_ac].comb = 'N' THEN
         CALL cl_set_comp_entry("fak90,fak901",FALSE)
      ELSE
         CALL cl_set_comp_entry("splt",FALSE)
      END IF
   END IF
END FUNCTION
   
FUNCTION p110_ins_move()
 
   INITIALIZE g_faj.* TO NULL
   LET g_faj.faj01 =t_fak.fak01
   LET g_faj.faj02 =t_fak.fak02
   LET g_faj.faj021=t_fak.fak021
   LET g_faj.faj022=t_fak.fak022
   LET g_faj.faj03 =t_fak.fak03
   LET g_faj.faj04 =t_fak.fak04
   LET g_faj.faj05 =t_fak.fak05
   LET g_faj.faj06 =t_fak.fak06
   LET g_faj.faj061=t_fak.fak061
   LET g_faj.faj07 =t_fak.fak07
   LET g_faj.faj071=t_fak.fak071
   LET g_faj.faj08 =t_fak.fak08
   LET g_faj.faj09 =t_fak.fak09
   LET g_faj.faj10 =t_fak.fak10
   LET g_faj.faj11 =t_fak.fak11
   LET g_faj.faj12 =t_fak.fak12
   LET g_faj.faj13 =t_fak.fak13
   IF g_faj.faj13 IS NULL THEN LET g_faj.faj13=0 END IF   #MOD-750083
   LET g_faj.faj14=t_fak.fak14
   IF g_faj.faj14 IS NULL THEN LET g_faj.faj14=0 END IF   #MOD-750083
   LET g_faj.faj141=t_fak.fak141
   IF g_faj.faj141 IS NULL THEN LET g_faj.faj141=0 END IF   #MOD-750083
   LET g_faj.faj15=t_fak.fak15
   LET g_faj.faj16=t_fak.fak16
   IF g_faj.faj16 IS NULL THEN LET g_faj.faj16=0 END IF   #MOD-750083
   LET g_faj.faj17=t_fak.fak17
   IF g_faj.faj17 IS NULL THEN LET g_faj.faj17=0 END IF   #MOD-750083
   LET g_faj.faj171=t_fak.fak171
   IF g_faj.faj171 IS NULL THEN LET g_faj.faj171=0 END IF   #MOD-750083
   LET g_faj.faj18=t_fak.fak18
   LET g_faj.faj19=t_fak.fak19
   LET g_faj.faj20=t_fak.fak20
   LET g_faj.faj21=t_fak.fak21
   LET g_faj.faj22=t_fak.fak22
   LET g_faj.faj23=t_fak.fak23
   LET g_faj.faj24=t_fak.fak24
   LET g_faj.faj25=t_fak.fak25
   LET g_faj.faj26=t_fak.fak26
   LET g_faj.faj27=t_fak.fak27
   LET g_faj.faj28=t_fak.fak28
   LET g_faj.faj29=t_fak.fak29
   IF g_faj.faj29 IS NULL THEN LET g_faj.faj29=0 END IF   #MOD-750083
   LET g_faj.faj30=t_fak.fak30
 # IF g_faj.faj30 IS NULL THEN LET g_faj.faj30=1 END IF   #MOD-580155
   IF g_faj.faj30 IS NULL OR g_faj.faj30 = 0 THEN         #MOD-580155
      LET g_faj.faj30 = t_fak.fak29                       #MOD-580155
   END IF                                                 #MOD-580155
   LET g_faj.faj31=t_fak.fak31
   IF g_faj.faj31 IS NULL THEN LET g_faj.faj31=0 END IF    #MOD-750083
   LET g_faj.faj32=t_fak.fak32
   IF g_faj.faj32 IS NULL THEN LET g_faj.faj32=0 END IF    #MOD-750083
   LET g_faj.faj33=t_fak.fak33
   IF g_faj.faj33 IS NULL THEN LET g_faj.faj33=0 END IF    #MOD-750083
   LET g_faj.faj34=t_fak.fak34
   LET g_faj.faj35=t_fak.fak35
  #IF g_faj.faj35 IS NULL THEN LET g_faj.faj35=1 END IF    #MOD-740039
   IF g_faj.faj35 IS NULL THEN LET g_faj.faj35=0 END IF    #MOD-740039
   LET g_faj.faj36=t_fak.fak36
   IF g_faj.faj36 IS NULL THEN LET g_faj.faj36=0 END IF    #MOD-750083
   LET g_faj.faj37=t_fak.fak37
   LET g_faj.faj38=t_fak.fak38
   LET g_faj.faj39=t_fak.fak39
   LET g_faj.faj40=t_fak.fak40
   LET g_faj.faj41=t_fak.fak41
   LET g_faj.faj42=t_fak.fak42
   LET g_faj.faj421=t_fak.fak421
   IF g_faj.faj421 IS NULL THEN LET g_faj.faj421=0 END IF   #MOD-750083
   LET g_faj.faj422=t_fak.fak422
   IF g_faj.faj422 IS NULL THEN LET g_faj.faj422=0 END IF   #MOD-750083
   LET g_faj.faj423=t_fak.fak423
   IF g_faj.faj423 IS NULL THEN LET g_faj.faj423=0 END IF   #MOD-750083
   LET g_faj.faj43=t_fak.fak43
   LET g_faj.faj44=t_fak.fak44
   LET g_faj.faj45=t_fak.fak45
   LET g_faj.faj451=t_fak.fak451
   #IF g_faj.faj451 IS NULL THEN LET g_faj.faj451=1 END IF   #MOD-750083
   LET g_faj.faj46=t_fak.fak46
   LET g_faj.faj461=t_fak.fak461
   #IF g_faj.faj461 IS NULL THEN LET g_faj.faj461=1 END IF   #MOD-750083
   LET g_faj.faj462=t_fak.fak462
   LET g_faj.faj47=t_fak.fak47
   LET g_faj.faj471=t_fak.fak471
   LET g_faj.faj48=t_fak.fak48
   LET g_faj.faj49=t_fak.fak49
#  LET g_faj.faj50=t_fak.fak50   #No.FUN-840006 去掉t_fak.fak50,g_faj.faj50
   LET g_faj.faj51=t_fak.fak51
   LET g_faj.faj511=t_fak.fak511
   LET g_faj.faj52=t_fak.fak52
   LET g_faj.faj53=t_fak.fak53
   LET g_faj.faj54=t_fak.fak54
   LET g_faj.faj55=t_fak.fak55
   #No.FUN-680028 --begin
 # IF g_aza.aza63 = 'Y' THEN
   IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
      LET g_faj.faj531=t_fak.fak531
      LET g_faj.faj541=t_fak.fak541
      LET g_faj.faj551=t_fak.fak551
   END IF
   #No.FUN-680028 --end
   LET g_faj.faj56=t_fak.fak56
   LET g_faj.faj57=t_fak.fak57
  #IF g_faj.faj57 IS NULL THEN LET g_faj.faj57=1 END IF   #MOD-750083
   LET g_faj.faj571=t_fak.fak571
  #IF g_faj.faj571 IS NULL THEN LET g_faj.faj571=1 END IF #MOD-750083
   LET g_faj.faj58=t_fak.fak58
   IF g_faj.faj58 IS NULL THEN LET g_faj.faj58=0 END IF   #MOD-750083
   LET g_faj.faj59=t_fak.fak59
   IF g_faj.faj59 IS NULL THEN LET g_faj.faj59=0 END IF   #MOD-750083
   LET g_faj.faj60=t_fak.fak60
   IF g_faj.faj60 IS NULL THEN LET g_faj.faj60=0 END IF   #MOD-750083
   LET g_faj.faj61=t_fak.fak61
   LET g_faj.faj62=t_fak.fak62
   IF g_faj.faj62 IS NULL THEN LET g_faj.faj62=0 END IF   #MOD-750083
   LET g_faj.faj63=t_fak.fak63
   IF g_faj.faj63 IS NULL THEN LET g_faj.faj63=0 END IF   #MOD-750083
   LET g_faj.faj64=t_fak.fak64
   IF g_faj.faj64 IS NULL THEN LET g_faj.faj64=0 END IF   #MOD-750083
   LET g_faj.faj65=t_fak.fak65
   IF g_faj.faj65 IS NULL THEN LET g_faj.faj65=0 END IF   #MOD-750083
   LET g_faj.faj66=t_fak.fak66
   IF g_faj.faj66 IS NULL THEN LET g_faj.faj66=0 END IF   #MOD-750083
   LET g_faj.faj67=t_fak.fak67
   IF g_faj.faj67 IS NULL THEN LET g_faj.faj67=0 END IF   #MOD-750083
   LET g_faj.faj68=t_fak.fak68
   IF g_faj.faj68 IS NULL THEN LET g_faj.faj68=0 END IF   #MOD-750083
   LET g_faj.faj69=t_fak.fak69
   IF g_faj.faj69 IS NULL THEN LET g_faj.faj69=0 END IF   #MOD-750083
   LET g_faj.faj70=t_fak.fak70
   IF g_faj.faj70 IS NULL THEN LET g_faj.faj70=0 END IF   #MOD-750083
   LET g_faj.faj71=t_fak.fak71
   IF g_faj.faj71 IS NULL THEN LET g_faj.faj71='N' END IF #MOD-8C0185 add
   LET g_faj.faj72=t_fak.fak72
   IF g_faj.faj72 IS NULL THEN LET g_faj.faj72=0 END IF   #MOD-750083
   LET g_faj.faj73=t_fak.fak73
   IF g_faj.faj73 IS NULL THEN LET g_faj.faj73=0 END IF   #MOD-750083
   LET g_faj.faj74=t_fak.fak74
   LET g_faj.faj80=0
   LET g_faj.faj81=0
   LET g_faj.faj86=0
   LET g_faj.faj87=0
#No.MOD-C20120 --begin
   LET g_faj.faj92=t_fak.fak02
   LET g_faj.faj921=t_fak.fak022
   LET g_faj.faj922=t_fak.fak01    #No.MOD-C20120   
#No.MOD-C20120 --end
   LET g_faj.faj92=t_fak.fak02
   LET g_faj.faj921=t_fak.fak022
   LET g_faj.faj207=t_fak.fak207      #No:7679
   LET g_faj.faj205=0                 #No:8874
   LET g_faj.faj206=0                 #No:8874
   LET g_faj.fajconf='N'
   LET g_faj.fajuser=t_fak.fakuser
   LET g_faj.fajgrup=t_fak.fakgrup
   LET g_faj.fajmodu=t_fak.fakmodu
   LET g_faj.fajdate=t_fak.fakdate
   #No:A099
   LET g_faj.faj100=t_fak.fak26       #MOD-AA0011
   LET g_faj.faj101=0                                                            
   LET g_faj.faj102=0                                                            
   LET g_faj.faj103=0                                                            
   LET g_faj.faj104=0                                                            
   LET g_faj.faj105='N' #No.FUN-B80081 mark #MOD-C80001 remark
   LET g_faj.faj106=0                                                            
   LET g_faj.faj107=0                                                            
   LET g_faj.faj108=0                                                            
   LET g_faj.faj109=0                                                            
   LET g_faj.faj110=0                                                            
   LET g_faj.faj111=0                                                            
   #end No:A099

   #-----No:FUN-AB0088-----
   LET g_faj.faj142=t_fak.fak142
   IF g_faj.faj142 IS NULL THEN LET g_faj.faj142=0 END IF
   LET g_faj.faj143=t_fak.fak143
   LET g_faj.faj144=t_fak.fak144
   LET g_faj.faj1412=t_fak.fak1412
   IF g_faj.faj1412 IS NULL THEN LET g_faj.faj1412=0 END IF
   LET g_faj.faj232=t_fak.fak232
   LET g_faj.faj242=t_fak.fak242
   LET g_faj.faj262=t_fak.fak262
   LET g_faj.faj272=t_fak.fak272
   LET g_faj.faj282=t_fak.fak282
   LET g_faj.faj292=t_fak.fak292
   IF g_faj.faj292 IS NULL THEN LET g_faj.faj292=0 END IF
   LET g_faj.faj302=t_fak.fak302
   IF g_faj.faj302 IS NULL OR g_faj.faj302 = 0 THEN
      LET g_faj.faj302 = t_fak.fak292
   END IF
   LET g_faj.faj312=t_fak.fak312
   IF g_faj.faj312 IS NULL THEN LET g_faj.faj312=0 END IF
   LET g_faj.faj322=t_fak.fak322
   IF g_faj.faj322 IS NULL THEN LET g_faj.faj322=0 END IF
   LET g_faj.faj332=t_fak.fak332
   IF g_faj.faj332 IS NULL THEN LET g_faj.faj332=0 END IF
   LET g_faj.faj342=t_fak.fak342
   LET g_faj.faj352=t_fak.fak352
   IF g_faj.faj352 IS NULL THEN LET g_faj.faj352=0 END IF
   LET g_faj.faj362=t_fak.fak362
   IF g_faj.faj362 IS NULL THEN LET g_faj.faj362=0 END IF
   LET g_faj.faj432=t_fak.fak43
   LET g_faj.faj572=t_fak.fak572
   LET g_faj.faj5712=t_fak.fak5712
   LET g_faj.faj582=t_fak.fak58
   IF g_faj.faj582 IS NULL THEN LET g_faj.faj582=0 END IF
   LET g_faj.faj592=t_fak.fak59
   IF g_faj.faj592 IS NULL THEN LET g_faj.faj592=0 END IF
   LET g_faj.faj602=t_fak.fak60
   IF g_faj.faj602 IS NULL THEN LET g_faj.faj602=0 END IF
   LET g_faj.faj1012=0
   LET g_faj.faj1022=0
   LET g_faj.faj1062=0
   LET g_faj.faj1072=0
   LET g_faj.faj1082=0
   #-----No:FUN-AB0088 END-----

END FUNCTION
 
#----add by kitty 99-04-30
#FUNCTION p110_ins_fcx()
#   DEFINE l_yy,l_mm   LIKE type_file.num5         #No.FUN-680070 SMALLINT
#   DEFINE l_fbz15     LIKE fbz_file.fbz15
#
#   LET l_yy=YEAR(g_faj.faj25)
#   LET l_mm=MONTH(g_faj.faj25)
#   SELECT fbz15 INTO l_fbz15 FROM fbz_file WHERE fbz00='0'
#   IF STATUS THEN LET l_fbz15='' END IF
#
#   INSERT INTO fcx_file (fcx01,fcx011,fcx02,fcx03,fcx04,fcx05,fcx06,  #No.MOD-470041
#                         fcx07,fcx08,fcx09,fcx10,fcx11,fcx12,fcx13,
#                         fcxacti,fcxuser,fcxgrup,fcxmodu,fcxdate) 
#   VALUES(g_faj.faj02,g_faj.faj022,l_yy,l_mm,0,g_faj.faj14,0,0,0,
#          g_faj.faj53,l_fbz15,'','','','Y',g_user,g_grup,g_user,g_today)
#   IF STATUS THEN  
#      UPDATE fcx_file SET fcx05=g_faj.faj14
#          WHERE fcx01=g_faj.faj02
#            AND fcx011=g_faj.faj022
#            AND fcx02=l_yy
#            AND fcx03=l_mm
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
##        CALL cl_err('upd fcx05',STATUS,1)     #No.FUN-660136
#         CALL cl_err3("upd","fcx_file",g_faj.faj02,g_faj.faj022,STATUS,"","upd fcx05",1)   #No.FUN-660136
#         LET g_success='N'
#      END IF
#   END IF
#END FUNCTION
