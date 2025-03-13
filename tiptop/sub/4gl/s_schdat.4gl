# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_schdat.4gl
# Descriptions...: Schedule W/O AND Tracking Date
# Date & Author..: 90/12/13 By Lee
# Usage..........: CALL s_schdat(p_opt    ,p_strtdat,p_duedat,p_bomdat,p_wono,
#                      p_primary,p_wotype ,p_part  ,p_woq   ,p_usedate)
#                  RETURNING l_irr,l_strtdat,l_duedat,l_type,l_track
# Input Parameter: p_opt      Options
#                    0  normal use
#                    1  do not generate tracking file
#                  p_strtdat  Start Date of W/O
#                  p_duedat   Due Date of W/O
#                  p_bomdat   BOM Effective Date
#                  p_wono     W/O Number
#                  p_primary  Routing Primary Code
#                  p_wotype   W/O type
#                  p_part     part number
#                  p_woq      W/O Qty
#                  p_usedate  若日期小於今日處理方式
# Return code....: l_irr      Results
#                  l_strtdat  Start Date
#                  l_duedat   Due Date
#                  l_type     Schele Method
#                  l_track    tracking file generated?(Y/N)
# Modify.........: 92/09/15 By PIN  在tracking file 加一欄位(盤點否)
# Modify.........: 01/05/31 BY ANN CHEN No.B524 第一站投入量改在工單確認才掛上
# Modify.........: No.MOD-530757 05/03/31 By ching remove WORK
# Modify.........: NO.FUN-670091 06/08/02 By rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-740301 07/04/26 By kim ecm50和ecm51顛倒
# Modify.........: No.FUN-760066 07/06/25 By kim 配合MSV版的調整
# Modify.........: No.MOD-770008 07/07/09 By pengu 若製程天數為0時，則完工日期/開工日期會異常
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810017 08/02/01 By jan 增加行業別字段的賦值
# Modify.........: No.FUN-830114 08/03/28 By jan 修改行業別字段的賦值
# Modify.........: No.FUN-830088 08/03/31 By hongmei 修改行業別字段的賦值
# Modify.........: No.MOD-840481 08/04/22 By By kim GP5.1顧問測試修改
# Modify.........: No.FUN-840155 08/04/22 By jan 把sgc14賦值給sgd14
# Modify.........: No.FUN-840178 08/04/24 By jan 修改sgd05的賦值
# Modify.........: No.FUN-870092 08/08/14 By Mandy 平行加工
# Modify.........: No.MOD-890158 08/09/17 By cliare 修改料件給值
# Modify.........: No.FUN-8A0090 08/10/20 BY duke 按下製程時,複製產品製程 aeci100 之途程製程與指定工具
# Modify.........: No.TQC-8C0016 08/12/11 By Mandy INSERT INTO vmn_file不成功
# Modify.........: No.MOD-920073 09/02/05 By claire ecm50和ecm51顛倒
# Modify.........: No.MOD-940141 09/04/10 BY DUKE 修正BUG
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.CHI-970027 09/07/13 By mike 將LET l_sgd.sgd13 = l_sgc.sgc13與LET l_sgd.sgd14 = l_sgc.sgc14搬到IF s_industry('slk') THEN判斷
#                                                 式之外
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-A50107 10/05/28 By Sarah 寫入ecm_file時會因為ecm012為Null而失敗
# Modify.........: No:FUN-A50066 10/06/24 By kim 平行工艺功能
# Modify.........: No:FUN-A60095 10/07/07 By kim 平行工艺功能
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No:MOD-AC0336 10/12/28 By jan 製程料號從抓
# Modify.........: No:TQC-AC0374 10/12/30 By jan 新增函數:抓取製程段名稱
# Modify.........: No:FUN-B10056 11/02/14 By liweie 修改s_put(),新增函數：1檢查制程段是否存在 2抓取制程段號說明
# Modify.........: No:FUN-B20087 11/04/20 By jan s_schdat_output()函數改寫
# Modify.........: No:TQC-B50114 11/05/20 By jan 系統參數設置走平行工藝，不走制程BOM，開立工單會被卡住
# Modify.........: No:FUN-B50046 11/05/20 By abby APS GP5.25追版str----------------
# Modify.........: No:FUN-990008 09/09/03 By Mandy 有串APS時,產生工單製程追蹤(aeci700)的同時,也要產生vmn_file,vnm_file
# Modify.........: No:FUN-9A0048 09/11/09 By Mandy 有跟APS整合時,工單產生ecm_file時,單一標準工時vmn20=ecb19,單一標準機時vmn21=ecb21
# Modify.........: No.FUN-A40034 10/04/14 By Mandy asfp301 產生子工單時,產生APS 途程製程vmn_file和途程製程指定工具(vnm_file) 錯誤
# Modify.........: No:FUN-B50046 11/05/20 By abby APS GP5.25追版end----------------
# Modify.........: No:CHI-B70002 11/07/05 By Vampire 進入時，就先檢核料件製程資料是否存在且要為確認狀態
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.CHI-B80096 11/09/02 By fengrui 對組成用量(ecm62)/底數(63)的預設值處理
# Modify.........: No:MOD-BA0202 11/10/28 By suncx 工單生成工藝時標准產出值ecm65寫值有問題
# Modify.........: No:TQC-BB0047 11/11/04 By suncx 還原MOD-BA0202
# Modify.........: NO.FUN-BB0083 12/01/31 By fengrui 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/01 By bart 新增函數:抓取作業編號pmn78
# Modify.........: No:MOD-C70232 12/07/20 By zhangll 修正ecm011和ecm015两个字段抓不到值的问题
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷

DATABASE ds        #FUN-6C0017

GLOBALS "../../config/top.global"   #FUN-7C0053

DEFINE
    g_sfb RECORD LIKE sfb_file.*, #Work Order
    g_op ARRAY[1000] OF
        RECORD
              qtytbc LIKE ecm_file.ecm291, #Qty to be complete
              offset1 LIKE ecm_file.ecm13, #offset(=FLT+ULT)
              offset2 LIKE ecm_file.ecm13, #offset(=ULT)
              ecm01   LIKE ecm_file.ecm01, #FUN-760066
              ecm03   LIKE ecm_file.ecm03, #FUN-760066
              ecm012  LIKE ecm_file.ecm012 #FUN-A50066
        END RECORD,
    g_type      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_track     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_lots      LIKE ima_file.ima56, #production lot size
    g_wono      LIKE sfb_file.sfb01, #work order nubmer
    g_wotype    LIKE sfb_file.sfb02, #work order type
    g_part      LIKE sfb_file.sfb05, #work order part number
    g_primary   LIKE sfb_file.sfb06, #work order primary code
    g_usedate   LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_opt       LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    g_woq       LIKE sfb_file.sfb08 #Qty of W/O

DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680147 INTEGER
FUNCTION s_schdat(p_opt    ,p_strtdat,p_duedat ,p_bomdat,p_wono,
                  p_primary,p_wotype ,p_part   ,p_woq   ,p_usedate)
DEFINE
    p_opt      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    p_strtdat  LIKE type_file.dat,           #No.FUN-680147 DATE               #Start Date
    p_duedat   LIKE type_file.dat,           #No.FUN-680147 DATE               #Due Date
    p_bomdat   LIKE type_file.dat,           #No.FUN-680147 DATE               #BOM Effective Date
    p_wono     LIKE sfb_file.sfb01, #W/O
    p_part     LIKE sfb_file.sfb05, #work order part number
    p_wotype   LIKE sfb_file.sfb02, #work order type
    p_woq      LIKE sfb_file.sfb08, #Qty of W/O
    p_primary  LIKE ecb_file.ecb02, #Primary Code
    p_usedate  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    l_part     LIKE ima_file.ima01,
    l_exit     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_irr      LIKE type_file.num5,          #No.FUN-680147 SMALLINT #Result
    l_n        LIKE type_file.num5,          #CHI-B70002 add
    l_ecu012   LIKE ecu_file.ecu012          #FUN-A50066

    WHENEVER ERROR CALL cl_err_msg_log

    MESSAGE ' Scheduling ' ATTRIBUTE(REVERSE)
    #CHI-B70002 --- modify ---- start ---
    LET g_part=p_part
    LET g_primary=p_primary
    SELECT COUNT(*) INTO l_n FROM ecb_file,ecu_file
     WHERE ecb01=p_part
       AND ecb02=g_primary
       AND ecbacti='Y'
       AND ecu01=ecb01
       AND ecu02=ecb02
       AND ecu10='Y'
    IF l_n <= 0  THEN
       CALL cl_err('','asf1019',1)
       RETURN -1,p_strtdat,p_duedat,g_type,g_track
    END IF
    #CHI-B70002 --- modify ---  end  ---
    #Check if all anytings available
    LET g_errno=' '
    LET g_track='N'
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=p_wono

    IF g_sfb.sfb93='N' AND g_sma.sma28='2' THEN
  LET g_errno='mfg5106'
        RETURN -1,p_strtdat,p_duedat,g_type,g_track
    END IF

    #scehduling method not defined
    IF g_sma.sma28 IS NULL
        OR g_sma.sma28 NOT MATCHES '[12]' THEN  #out of range
  LET g_errno='mfg5100'
        RETURN -1,p_strtdat,p_duedat,g_type,g_track
        #system parameter #28 scheduling method not defined yet
    END IF

    #tracking method not defined
    IF g_sma.sma26 IS NULL
        OR g_sma.sma26 NOT MATCHES '[123]' THEN #out of range
  LET g_errno='mfg5101'
        RETURN -2,p_strtdat,p_duedat,g_type,g_track
        #system parameter #26 tracking method not defined
    END IF

    #若使用料件的時距排程, 並使用者輸入預計開工及完工日,
    #則不為任何的推算
{
    IF g_sma.sma28='1' AND p_strtdat IS NOT NULL AND p_duedat IS NOT NULL THEN
        MESSAGE " "
        RETURN 1,p_strtdat,p_duedat,'0','N'
        #????? when up condition how to generate tracking file  #94/03/17 pin
    END IF
}

    #no problems, let's go
    #select detail data of w/o
    LET g_wono=p_wono
    LET g_wotype=p_wotype
    LET g_part=p_part
    LET g_primary=p_primary
    LET g_woq=p_woq
    LET g_usedate=p_usedate
    LET g_opt=p_opt
    LET g_errno= ' '

    #MOD-530757
   #BEGIN WORK
   #LET g_success = 'Y'
   #--

    IF (g_sfb.sfb93='Y' AND g_sma.sma28='2')          #使用製程排程
            OR (g_sma.sma26 MATCHES '[23]') THEN  #產生製程追蹤
        LET g_cnt=0
        SELECT COUNT(*) INTO g_cnt FROM ecm_file
            WHERE ecm01=g_wono
           #  AND ecm02=g_wotype
        IF SQLCA.sqlcode OR g_cnt=0 OR g_cnt IS NULL THEN #record not exist
             LET l_part=p_part
             LET l_exit=FALSE
             WHILE TRUE
                 #add new record to tracing file
                 CALL s_put(p_bomdat,l_part,p_wono) RETURNING g_cnt  #add by huanglf170314
                 #no record find, routing select error
{
                 IF NOT g_cnt THEN
                   IF NOT l_exit THEN
                LET l_exit=TRUE
                #主製程料件
                SELECT ima571 INTO l_part FROM ima_file WHERE ima01=p_part
                IF SQLCA.SQLCODE OR l_part IS NULL OR l_part=' ' THEN
                   LET g_errno='mfg5102'
                   RETURN -4,p_strtdat,p_duedat,g_type,g_track
                END IF
             ELSE
                LET g_errno='mfg5102'
                      RETURN -4,p_strtdat,p_duedat,g_type,g_track
                   END IF
                 ELSE
             EXIT WHILE   #成功
           END IF
}
             EXIT WHILE   #成功#
       END WHILE
        ELSE  #追蹤資料已存在!! 嚴重錯誤, 不可再繼續
     LET g_errno='asf-016'
     #system shutdown
  #  UPDATE sma_file SET sma01='N' WHERE sma00='0'
     RETURN -99,p_strtdat,p_duedat,g_type,g_track
        END IF
    END IF

    #compute w/o qty
#   LET g_woq=g_sfb.sfb08-g_sfb.sfb09

    #FUN-A50066--begin--add--------------------
    IF g_sma.sma541='Y' AND g_sfb.sfb93='Y' THEN
       SELECT ecu012 INTO l_ecu012 FROM ecu_file
        WHERE ecu01=p_part AND ecu02=g_sfb.sfb06  #MOD-AC0336
          AND (ecu015 IS NULL OR ecu015=' ')
          AND ecuacti = 'Y'  #CHI-C90006
       CALL s_schdat_output(l_ecu012,g_sfb.sfb08,g_sfb.sfb01)  #FUN-B20087 add sfb01
    #FUN-A80102(S)
    ELSE
       CALL s_schdat_output(' ',g_sfb.sfb08,g_sfb.sfb01)   #FUN-B20087 add sfb01
    #FUN-A80102(E)
    END IF
    #FUN-A50066--end--add----------------------

    #若使用製程, 雖不產生製程追蹤資料, 則仍以製程來推算其開/完工日
    IF g_sfb.sfb93='Y' AND g_sma.sma26='1' THEN LET g_opt=1 END IF

    #window scheduling(若不產生追蹤)
    IF g_sma.sma28 = '1' OR g_sfb.sfb93='N' THEN
        CALL s_winsch(p_strtdat,p_duedat)
        RETURNING g_cnt,p_strtdat,p_duedat
    END IF

    #tracking scheduling & weighted window #製程排程
    IF (g_sma.sma28='2'  AND g_sfb.sfb93='Y') OR
       (g_sma.sma26!='1' AND g_sma.sma28='1') THEN
       CALL s_trksch(p_strtdat,p_duedat)
       RETURNING g_cnt,p_strtdat,p_duedat
    END IF

    #MOD-530757
   #IF g_success = 'Y' THEN
   #   COMMIT WORK
   #ELSE
   #   ROLLBACK WORK
   #END IF

    #check result for validation
    IF p_strtdat=g_lastdat THEN LET p_duedat=g_lastdat   END IF
    IF p_duedat=g_lastdat  THEN LET p_strtdat='01/01/01' END IF
    MESSAGE ""
    RETURN g_cnt,p_strtdat,p_duedat,g_type,g_track
END FUNCTION

#Window Scheduling
FUNCTION s_winsch(p_strtdat,p_duedat)
DEFINE
    p_strtdat LIKE type_file.dat,           #No.FUN-680147 DATE               #start date
    p_duedat  LIKE type_file.dat,           #No.FUN-680147 DATE               #due date
    l_date    LIKE type_file.dat,           #No.FUN-680147 DATE
    l_alot    LIKE ima_file.ima59  #part's lead time

    #both start and due date defined
    IF p_strtdat IS NOT NULL AND p_duedat IS NOT NULL THEN
  LET g_errno='mfg5103'
        RETURN -9,p_strtdat,p_duedat
    END IF
    #select part's lead time
    CALL s_lt() RETURNING l_alot
    #selection error
    IF l_alot IS NULL THEN
        LET g_errno='mfg5104'
        RETURN -10,p_strtdat,p_duedat
    END IF

    IF p_strtdat IS NULL THEN
        #backward
        LET l_alot=l_alot*-1
        LET l_date=p_duedat
        LET g_type='2'
    ELSE
        #forward
        LET l_date=p_strtdat
        LET g_type='1'
    END IF

    CALL s_getdate(l_date,l_alot) RETURNING l_date
    IF p_strtdat IS NULL THEN
       LET p_strtdat=l_date
    ELSE
       LET p_duedat=l_date
    END IF

    #adjust if start date before today
    IF p_strtdat < g_today THEN
        IF g_usedate='1' THEN LET p_strtdat=g_today END IF
    END IF
    RETURN 1,p_strtdat,p_duedat
END FUNCTION

#tracking Scheduling & weighted window
FUNCTION s_trksch(p_strtdat,p_duedat)
DEFINE
    p_strtdat LIKE type_file.dat,           #No.FUN-680147 DATE             #start date
    p_duedat LIKE type_file.dat,           #No.FUN-680147 DATE      #due date
   #bb-----
    w_bdate,w_edate LIKE type_file.dat,           #No.FUN-680147 DATE
    w_day   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    w_flag  LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_ecm RECORD LIKE ecm_file.*,
   #bb-----
    l_need1 LIKE ecm_file.ecm07, #total offset1
    l_need2 LIKE ecm_file.ecm07, #total offset1
    l_b1 LIKE ecm_file.ecm07,
    l_b2 LIKE ecm_file.ecm07,
    l_e1 LIKE ecm_file.ecm07,
    l_e2 LIKE ecm_file.ecm07,
    l_i LIKE type_file.num5,   #index        #No.FUN-680147 SMALLINT
    l_date LIKE type_file.dat,           #No.FUN-680147 DATE
    l_flt LIKE ima_file.ima59,   #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,   #routing's unit lead time(ULT)
    l_weighted LIKE type_file.num5,          #No.FUN-680147 SMALLINT        #weighted flag
    l_cnt LIKE type_file.num5,                #total number counted        #No.FUN-680147 SMALLINT
    l_alot LIKE ima_file.ima59,  #part's lead time
    l_alot2 LIKE ima_file.ima59  #part's lead time

    LET l_weighted=0
    IF p_strtdat IS NOT NULL #both start and due date defined
        AND p_duedat IS NOT NULL THEN
        LET l_weighted=1
    END IF

    #selection error
    CALL s_lt() RETURNING l_alot
    IF l_alot IS NULL THEN
  LET g_errno='mfg5014'
        RETURN -10,p_strtdat,p_duedat
    END IF
    LET l_alot2=l_alot

    CALL s_total() RETURNING l_cnt,l_need1,l_need2
    IF g_cnt=1    THEN LET g_errno='mfg5015' RETURN -4,'','' END IF
    IF g_cnt>1000 THEN LET g_errno='mfg5015' RETURN -5,'','' END IF

    IF NOT l_weighted THEN
        IF p_strtdat IS NULL THEN #backward
            LET l_need1=l_need1*-1
            LET l_date=p_duedat
            LET g_type='5'
        ELSE  #forward
            LET l_date=p_strtdat
            LET g_type='4'
        END IF
        CALL s_getdate(l_date,l_need1) RETURNING l_date
        IF p_strtdat IS NULL THEN
            LET p_strtdat=l_date
        ELSE
            LET p_duedat=l_date
        END IF
    ELSE
        LET g_type='3'
    END IF

    #adjust if start date before today
    IF p_strtdat < g_today THEN
        IF g_usedate='1' THEN
            LET p_strtdat=g_today
            LET l_weighted=1
            LET l_need1=l_need1-(g_today-p_strtdat)
            LET l_need2=l_need2-(g_today-p_strtdat)
        END IF
    END IF


    LET l_cnt=l_cnt-1
    IF g_opt=1 THEN
        DELETE FROM ecm_file WHERE ecm01=g_wono AND ecm11=g_primary
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL cl_err('del_ecm',STATUS,0) #FUN-670091
            CALL cl_err3("del","ecm_file",g_wono,g_primary,STATUS,"","",0) #FUN-670091
           LET g_success = 'N'
        END IF

        #FUN-8A0090 與APS連結時,需同時刪除APS相關資料---str--
        IF NOT cl_null(g_sma.sma901) and  (g_sma.sma901='Y') THEN
           DELETE FROM vmn_file
             #WHERE vmn02=g_sfb.sfb01 #FUN-A40034 mark
              WHERE vmn02=g_wono      #FUN-A40034 add
           DELETE FROM vnm_file
             #WHERE vnm02=g_sfb.sfb01 #FUN-A40034 mark
              WHERE vnm02=g_wono      #FUN-A40034 add
        END IF
        #FUN-8A0090 ------------------------------------end--

        LET g_track='N'
        RETURN l_cnt,p_strtdat,p_duedat
    END IF

    IF NOT l_weighted THEN
        LET l_alot=l_need1
        LET l_alot2=l_need2
    ELSE #how many days in the specified time frame
        CALL s_ofday(p_strtdat,p_duedat) RETURNING l_alot
        IF l_need1 = 0 THEN LET l_need1 = 0.01 END IF
        LET l_alot2=l_alot*(l_need2/l_need1)
    END IF
    LET l_b1=0
    LET l_b2=0
    IF l_need1=0 THEN LET l_need1=1 END IF
    IF l_need2=0 THEN LET l_need2=1 END IF
    FOR l_i=1 TO l_cnt
        LET l_e1=l_b1+(g_op[l_i].offset1*(l_alot/l_need1))
        LET l_e2=l_b2+(g_op[l_i].offset2*(l_alot2/l_need2))
        UPDATE ecm_file
           SET ecm07=l_e1,ecm08=l_e2,
               ecm09=l_b2,ecm10=l_b1
         WHERE ecm01=g_op[l_i].ecm01 AND ecm03=g_op[l_i].ecm03  #No.TQC-950134
           AND ecm012=g_op[l_i].ecm012  #FUN-A50066
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL cl_err('upd_ecm1',STATUS,0)  #FUN-670091
           CALL cl_err3("upd","ecm_file","","",STATUS,"","",0) #FUN-670091
           LET g_success = 'N'
        END IF
        LET l_b1=l_e1
        LET l_b2=l_e2
    END FOR
 #bb-----
   IF g_type='4' THEN
    DECLARE c_trk1 CURSOR FOR
      SELECT *
        FROM ecm_file
       WHERE ecm01=g_wono
        ORDER BY ecm03
      LET w_bdate=p_strtdat
    FOREACH c_trk1 INTO l_ecm.*
      LET w_day=(l_ecm.ecm14+l_ecm.ecm13)/86400 +0.99    # 一天86400秒
      CALL s_wknxt(w_bdate,w_day) RETURNING w_flag,w_edate
     #-----------------No.MOD-770008 modify
      IF w_day != 0 THEN
         CALL s_wknxt(w_edate,-1) RETURNING w_flag,p_duedat
      ELSE
         CALL s_wknxt(w_edate,0) RETURNING w_flag,p_duedat
      END IF
     #-----------------No.MOD-770008 end
      UPDATE ecm_file set ecm50=w_bdate,ecm51=p_duedat WHERE ecm01=l_ecm.ecm01
                                                          AND ecm03=l_ecm.ecm03
                                                          AND ecm012=l_ecm.ecm012  #FUN-A50066
      LET w_bdate=w_edate
    END FOREACH
  ELSE    #Is  ELSE or must be g_type = '5' backward (sfb32 起始scheduling method)
    DECLARE c_trk2 CURSOR FOR
      SELECT *
        FROM ecm_file
       WHERE ecm01=g_wono
        ORDER BY ecm03 DESC
      LET w_edate=p_duedat
    FOREACH c_trk2 INTO l_ecm.*
      LET w_day=((l_ecm.ecm14+l_ecm.ecm13)/86400 +0.99)*-1    # 一天86400秒
      CALL s_wknxt(w_edate,w_day) RETURNING w_flag,w_bdate
     #-----------------No.MOD-770008 modify
      IF w_day != 0 THEN
         CALL s_wknxt(w_bdate,1) RETURNING w_flag,p_strtdat
      ELSE
         CALL s_wknxt(w_bdate,0) RETURNING w_flag,p_strtdat
      END IF
     #-----------------No.MOD-770008 end
     #UPDATE ecm_file set ecm51=w_edate,ecm50=p_strtdat WHERE ecm01=l_ecm.ecm01 #MOD-740301
     #UPDATE ecm_file set ecm50=w_edate,ecm51=p_strtdat WHERE ecm01=l_ecm.ecm01 #MOD-740301  #MOD-920073 mark
      UPDATE ecm_file set ecm51=w_edate,ecm50=p_strtdat WHERE ecm01=l_ecm.ecm01 #MOD-920073
                                                          AND ecm03=l_ecm.ecm03
                                                          AND ecm012=l_ecm.ecm012  #FUN-A50066
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('upd_ecm2',STATUS,0)  #FUN-670091
          CALL cl_err3("upd","ecm_file",l_ecm.ecm01,l_ecm.ecm03,STATUS,"","",0) #FUN-670091
         LET g_success = 'N'
      END IF
      LET w_edate=w_bdate
    END FOREACH
  END IF
 #bb-----
    RETURN l_cnt,p_strtdat,p_duedat
END FUNCTION

#accumulated total need time
FUNCTION s_total()
DEFINE
    l_ecm RECORD LIKE ecm_file.*,    #tracking detail file
    l_need1 LIKE ecm_file.ecm07,     #total offset1
    l_need2 LIKE ecm_file.ecm07,     #total offset1
    l_wc LIKE ecb_file.ecb08,        #work center
    l_eca04 LIKE eca_file.eca04,     #work center type code
    l_eca06 LIKE eca_file.eca06,     #intensity flag
    l_eca08 LIKE eca_file.eca08,     #capacity hour per day
    l_eca09 LIKE eca_file.eca09,     #work center queue time
    l_flt LIKE ima_file.ima59,       #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,       #routing's unit lead time(ULT)
    l_run LIKE ecm_file.ecm39,       #runtime
    l_qty LIKE ecm_file.ecm291,
    l_lots LIKE type_file.num5,      #No.FUN-680147 SMALLINT #production lot size
    l_double LIKE ecm_file.ecm40

    DECLARE c_trk CURSOR FOR
      SELECT ecm_file.*
        FROM ecm_file
       WHERE ecm01=g_wono
#bb--------
    #    AND ecm11=g_primary
    # ORDER BY ecm03 DESC
#bb--------
    LET g_cnt=1
    LET l_wc='!@#$%^&*()'
    #accumulate total need time
    LET l_need1=0
    LET l_need2=0
    FOREACH c_trk INTO l_ecm.*  #No.TQC-950134
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        #FUN-760066.............begin
        LET g_op[g_cnt].ecm01=l_ecm.ecm01
        LET g_op[g_cnt].ecm03=l_ecm.ecm03
        LET g_op[g_cnt].ecm012 = l_ecm.ecm012  #FUN-A50066
        #FUN-760066.............end
        IF l_wc != l_ecm.ecm06 THEN #w/c changed, get queue time
            SELECT eca04,eca06,eca08,eca09
                INTO l_eca04,l_eca06,l_eca08,l_eca09
                FROM eca_file
                WHERE eca01=l_ecm.ecm06 AND ecaacti='Y'
            IF SQLCA.sqlcode THEN
                 LET l_eca04='0' LET l_eca06='1'
                 LET l_eca08=8   LET l_eca09=0
            ELSE
                IF l_eca04 IS NULL THEN LET l_eca04='0' END IF
                IF l_eca06 IS NULL THEN LET l_eca06='1' END IF
                IF l_eca08 IS NULL THEN LET l_eca08=8 END IF
                IF l_eca09 IS NULL THEN LET l_eca09=0 END IF
            END IF
            LET l_wc=l_ecm.ecm06
        ELSE
            LET l_eca09=0
        END IF
        #compute qty to be complete
        LET l_qty=l_ecm.ecm311+l_ecm.ecm312+l_ecm.ecm313+l_ecm.ecm314
        IF l_qty=0 THEN #nothing produced
            LET g_op[g_cnt].qtytbc=g_woq
        ELSE
            #QtyTbC=woq-trcaqty-trctqty-trscr-trrewqty-scraped&rework
            LET g_op[g_cnt].qtytbc=g_woq+
                l_ecm.ecm302-l_qty
        END IF
        #compute offset and need time
        IF l_eca06='1' THEN #labor burdened w/c
            LET l_double=l_ecm.ecm41
        ELSE #machine burdened w/c
            LET l_double=l_ecm.ecm40
        END IF

        IF l_eca04='0' THEN #regular w/c
            LET l_lots=(g_op[g_cnt].qtytbc/g_lots)+0.999
            LET l_flt=(l_ecm.ecm37*((100-l_ecm.ecm42)/100)*l_lots+
                      l_ecm.ecm18*l_lots+l_eca09)/(60*l_eca08)
        ELSE #other
            LET l_flt=0
        END IF

        IF l_ecm.ecm43='1' THEN #hr/unit
            LET l_ult=((l_run*g_op[g_cnt].qtytbc)/(l_eca08*60*l_double))
        ELSE #unit/hr
            LET l_ult=((g_op[g_cnt].qtytbc)/(l_eca08*60*l_run*l_double))
        END IF

        IF l_flt IS NULL THEN LET l_flt=0 END IF
        IF l_ult IS NULL THEN LET l_ult=0 END IF
        LET g_op[g_cnt].offset1=l_flt+l_ult
        LET g_op[g_cnt].offset2=l_ult
        LET l_need1=l_need1+l_flt+l_ult
        LET l_need2=l_need2+l_ult
        LET g_cnt=g_cnt+1
        IF g_cnt>1000 THEN EXIT FOREACH END IF
    END FOREACH
    RETURN g_cnt,l_need1,l_need2
END FUNCTION

#select part's lead time
FUNCTION s_lt()
DEFINE
    l_alot LIKE ima_file.ima59, #part's lead time
    l_flt LIKE ima_file.ima59,  #part's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60   #part's unit lead time(ULT)

    #select part's lead time
    SELECT ima56,ima59,ima60
        INTO g_lots,l_flt,l_ult
        FROM ima_file
        WHERE ima01=g_part AND imaacti='Y'
    IF SQLCA.sqlcode THEN  LET g_lots=1 RETURN '' END IF
    IF g_lots IS NULL OR g_lots=0 THEN LET g_lots=1 END IF
    #compute lead
    IF l_flt IS NULL THEN LET l_flt=0 END IF
    IF l_ult IS NULL THEN LET l_ult=0 END IF
    LET l_alot=l_flt+(l_ult*g_woq)
    RETURN l_alot
END FUNCTION
#bb---------
#Add new record of tracking file
FUNCTION s_put(p_bomdat,p_part,p_wono) #add by huanglf170314
DEFINE
    p_bomdat LIKE type_file.dat,           #No.FUN-680147 DATE
    p_part   LIKE ima_file.ima01,
    l_ima55  LIKE ima_file.ima55,
    l_ecb    RECORD LIKE ecb_file.*, #routing detail file
    l_ecm    RECORD LIKE ecm_file.*, #routing detail file
    l_sgc    RECORD LIKE sgc_file.*, #routing detail file
    l_sgd    RECORD LIKE sgd_file.*, #routing detail file
    l_vmn    RECORD LIKE vmn_file.*, #FUN-990008 ADD
    p_wono   LIKE sfb_file.sfb01,    #add by huanglf170314
    l_p_wono LIKE type_file.chr100   #add by huanglf170314
DEFINE l_sql   STRING   #add by huanglf170314
   #darcy:2022/11/01 add s---
   define l_ecb17_mk  INTEGER
   define l_ecb03_hold INTEGER
   #darcy:2022/11/01 add e---

    SELECT substr(p_wono,1,3) INTO l_p_wono FROM dual
#str----add by huanglf170314
   IF l_p_wono = 'MSC' THEN
    LET  l_sql = " SELECT ecb_file.* FROM ecb_file,ecu_file ", #MOD-840481
              "  WHERE ecb01 = '",p_part,"'", #part
              "  AND ecb02 = '",g_primary,"'" ,#routing
              "  AND ecbacti = 'Y' ",
              "  AND ecu01 = ecb01 ",#MOD-840481
              "  AND ecu02 = ecb02 ",#MOD-840481
              "  AND ecu10 = 'Y'  ", #MOD-840481
              "  AND ecb17 LIKE '%FQC%'",
              "  AND ecb012 = ecu012 ", #FUN-A50066
              " ORDER BY ecb03 "#製程序號
   ELSE
     LET  l_sql = " SELECT ecb_file.* FROM ecb_file,ecu_file ", #MOD-840481
              "  WHERE ecb01 = '",p_part,"'", #part
              "  AND ecb02 = '",g_primary,"'" ,#routing
              "  AND ecbacti = 'Y' ",
              "  AND ecu01 = ecb01 ",#MOD-840481
              "  AND ecu02 = ecb02 ",#MOD-840481
              "  AND ecu10 = 'Y'  ", #MOD-840481
              "  AND ecb012 = ecu012 ", #FUN-A50066
              " ORDER BY ecb03 "#製程序號
   
   END IF
   #str---end by huanglf170314
     PREPARE sfb_pre FROM l_sql
     DECLARE c_put CURSOR FOR sfb_pre

        
    LET g_cnt=0
    let l_ecb17_mk = 0 #darcy:2022/11/01 add
    FOREACH c_put INTO l_ecb.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        INITIALIZE l_ecm.* TO NULL
        #darcy:2022/11/01 s---
        #   连续盲孔报工规则设置
        #1.根据作业名称ecb17，模糊查询盲孔
        #2 （1）连续一次，第一站报工
        #  （2）连续两次，第一站报工
        #  （3）连续三次，无这种情况，当作连续两次处理
        #  （4）连续四次，第一站报工，第三站报工。
        if l_ecb.ecb17 matches '*镭射*盲孔*' then
         let l_ecb17_mk = l_ecb17_mk + 1
         case l_ecb17_mk
            when 1
               update ecb_file 
                  set ecbud06 = 'Y'
                where ecb01 = l_ecb.ecb01 and ecb02 = l_ecb.ecb02
                  and ecb03 = l_ecb.ecb03
               if status then
                  CALL cl_err3("upd","ecb_file","","",STATUS,"","",0)
               end if
            when 2
               update ecb_file 
                  set ecbud06 = 'N'
                where ecb01 = l_ecb.ecb01 and ecb02 = l_ecb.ecb02
                  and ecb03 = l_ecb.ecb03
               if status then
                  CALL cl_err3("upd","ecb_file","","",STATUS,"","",0)
               end if
            when 3
               update ecb_file 
                  set ecbud06 = 'Y'
                where ecb01 = l_ecb.ecb01 and ecb02 = l_ecb.ecb02
                  and ecb03 = l_ecb.ecb03
               if status then
                  CALL cl_err3("upd","ecb_file","","",STATUS,"","",0)
               end if
            when 4
               update ecb_file 
                  set ecbud06 = 'N'
                where ecb01 = l_ecb.ecb01 and ecb02 = l_ecb.ecb02
                  and ecb03 = l_ecb.ecb03
               if status then
                  CALL cl_err3("upd","ecb_file","","",STATUS,"","",0)
               end if
         end case
        else
         if l_ecb17_mk > 0 then
            let l_ecb17_mk = 0
         end if
        end if
        #darcy:2022/11/01 e---
        LET l_ecm.ecm01      =  g_wono
        LET l_ecm.ecm02      =  g_wotype
        SELECT sfb05 INTO g_part FROM sfb_file WHERE sfb01=g_wono
        LET l_ecm.ecm03_par  =  g_part
        LET l_ecm.ecm03      =  l_ecb.ecb03
        LET l_ecm.ecm04      =  l_ecb.ecb06
        LET l_ecm.ecm05      =  l_ecb.ecb07
        LET l_ecm.ecm06      =  l_ecb.ecb08
        LET l_ecm.ecm07      =  0
        LET l_ecm.ecm08      =  0
        LET l_ecm.ecm09      =  0
        LET l_ecm.ecm10      =  0
        LET l_ecm.ecm11      =  l_ecb.ecb02          #製程編號
        LET l_ecm.ecm13      =  l_ecb.ecb18          #固定工時(秒)
        LET l_ecm.ecm14      =  l_ecb.ecb19*g_woq    #標準工時(秒)
        LET l_ecm.ecm15      =  l_ecb.ecb20          #固定機時(秒)
        LET l_ecm.ecm16      =  l_ecb.ecb21*g_woq    #標準機時(秒)
        LET l_ecm.ecm49      =  l_ecb.ecb38*g_woq    #製程人力
        LET l_ecm.ecm45      =  l_ecb.ecb17          #作業名稱
        LET l_ecm.ecm52      =  l_ecb.ecb39          #SUB 否
        LET l_ecm.ecm53      =  l_ecb.ecb40          #PQC 否
        LET l_ecm.ecm54      =  l_ecb.ecb41          #Check in 否
        LET l_ecm.ecm55      =  l_ecb.ecb42          #Check in Hold 否
        LET l_ecm.ecm56      =  l_ecb.ecb43          #Check Out Hold 否
        #------>
        LET l_ecm.ecm291     =  0
        LET l_ecm.ecm292     =  0
        #=========================================================
        #No.B524 010531 BY ANN CHEN
        #第一站投入量[ecm301]改在工單確認時才掛上
        #IF g_cnt=0    #第一站default投入量=生產套數
        #   THEN
        #   LET l_ecm.ecm301     =  g_woq
        #ELSE
           LET l_ecm.ecm301     =  0
        #END IF
        #No.B524 END =============================================
        LET l_ecm.ecm302     =  0
        LET l_ecm.ecm303     =  0
        LET l_ecm.ecm311     =  0
        LET l_ecm.ecm312     =  0
        LET l_ecm.ecm313     =  0
        LET l_ecm.ecm314     =  0
        LET l_ecm.ecm315     =  0           #bonus
        LET l_ecm.ecm316     =  0           #bonus
        LET l_ecm.ecm321     =  0
        LET l_ecm.ecm322     =  0
        #------>
       #LET l_ecm.ecm57      = l_ecb.ecb44  #FUN-A50066
        LET l_ecm.ecm58      = l_ecb.ecb45
       #LET l_ecm.ecm59      = l_ecb.ecb46  #FUN-A50066
        LET l_ecm.ecmacti    =  'Y'
        LET l_ecm.ecmuser    =  g_user
        LET l_ecm.ecmgrup    =  g_grup
        LET l_ecm.ecmmodu    =  ''
        LET l_ecm.ecmdate    =  g_today
        LET l_ecm.ecmplant   =  g_plant   #FUN-980012 add
        LET l_ecm.ecmlegal   =  g_legal   #FUN-980012 add
        #No.FUN-810017--Begin
        IF s_industry('slk') THEN
          LET l_ecm.ecmslk01  = l_ecb.ecbslk01
          LET l_ecm.ecmslk02  = l_ecb.ecbslk02*g_woq #No.FUN-830114
          LET l_ecm.ecmslk03  = l_ecb.ecbslk04
          LET l_ecm.ecmslk04  = l_ecb.ecbslk05
        END IF
       #No.FUN-810017--End
        LET l_ecm.ecm61 = 'N' #FUN-870092-add
        #FUN-A50066--begin---add--------------
        LET l_ecm.ecm62 = l_ecb.ecb46
        LET l_ecm.ecm63 = l_ecb.ecb51
        LET l_ecm.ecm12 = l_ecb.ecb52
        LET l_ecm.ecm64 = l_ecb.ecb53
        LET l_ecm.ecm34 = l_ecb.ecb14
        LET l_ecm.ecm65 = 0
        LET l_ecm.ecm66 = l_ecb.ecb66  #FUN-A80102
        LET l_ecm.ecm67 = l_ecb.ecb25  #FUN-A80102


        
        IF g_sma.sma541 = 'Y' AND g_sfb.sfb93 = 'Y' THEN
           LET l_ecm.ecm012 = l_ecb.ecb012
           DECLARE ecu012_cus CURSOR FOR
            SELECT ecu012 FROM ecu_file
             WHERE ecu01 = p_part    #MOD-C70232 mod g_part->p_part
               AND ecu02 = l_ecm.ecm11
               AND ecu015 = l_ecm.ecm012
               AND ecuacti = 'Y'  #CHI-C90006
            FOREACH ecu012_cus INTO l_ecm.ecm011
              EXIT FOREACH
            END FOREACH
        #FUN-B10056---------Begin-ADD---------------
            SELECT ecu014,ecu015 INTO l_ecm.ecm014,l_ecm.ecm015 FROM ecu_file
             WHERE ecu01 = p_part    #MOD-C70232 mod g_part->p_part
               AND ecu02 = g_primary
               AND ecu012 = l_ecm.ecm012  
               AND ecuacti = 'Y'  #CHI-C90006          
        #FUN-B10056---------End--ADD-----------------            
        END IF
        #FUN-A50066--end--add---------------------
        IF cl_null(l_ecm.ecm012) THEN LET l_ecm.ecm012=' ' END IF   #MOD-A50107 add
        IF cl_null(l_ecm.ecm015) THEN LET l_ecm.ecm015=' ' END IF   #FUN-B10056 add
        IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022
        IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF #CHI-B80096--add--
        IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF #CHI-B80096--add--
        #str-----add by guanyao160706
        LET l_ecm.ta_ecm01 = l_ecb.ecbud02
        LET l_ecm.ta_ecm02 = l_ecb.ecbud03
        #end-----add by guanyao160706

        #str—add by huanglf 160713
        LET l_ecm.ta_ecm03 = l_ecb.ecbud05
        #end—add by huanglf 160713

        INSERT INTO ecm_file VALUES(l_ecm.*)
        IF STATUS THEN
           #CALL cl_err('ins_ecm',STATUS,1)  #FUN-670091
            CALL cl_err3("ins","ecm_file","","",STATUS,"","",0) #FUN-670091
           LET g_success = 'N'
           EXIT FOREACH
        END IF


        #FUN-8A0090 與APS連結時,需同時複製APS相關資料 ---str---
        IF NOT cl_null(g_sma.sma901) and  (g_sma.sma901='Y') THEN
           #TQC-8C0016---mod---str---
          #INSERT INTO vmn_file(vmn01,vmn02,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19)             #FUN-9A0048 mark
           INSERT INTO vmn_file(vmn01,vmn02,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19,vmn20,vmn21,vmnlegal,vmnplant,vmn012) #FUN-9A0048 add
           #SELECT g_sfb.sfb05,g_sfb.sfb01,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,19 #MOD-940141 MARK
           #SELECT g_part,g_sfb.sfb01,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19 #MOD-940141 ADD #FUN-9A0048 mark
           #SELECT g_part,g_sfb.sfb01,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19,l_ecb.ecb19,l_ecb.ecb21  #MOD-940141 ADD #FUN-9A0048 add #FUN-A40034 mark
            SELECT g_part,g_wono     ,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19,l_ecb.ecb19,l_ecb.ecb21,g_legal,g_plant,vmn012  #MOD-940141 ADD #FUN-9A0048 add #FUN-A40034 add
              FROM vmn_file
              #WHERE vmn01=g_sfb.sfb05   #MOD-940141 MARK
               WHERE vmn01=g_part   #MOD-940141 ADD
               #AND vmn02 = g_sfb.sfb06 #FUN-A40034 mark
                AND vmn02 = g_primary   #FUN-A40034 add
                AND vmn03=l_ecm.ecm03
                AND vmn04=l_ecm.ecm04
                AND vmn012=l_ecm.ecm012 #FUN-A40034 add
           #TQC-8C0016---mod---end---

           #FUN-990008---add-----str----
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","vmn_file(1)","","",STATUS,"","",1)
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE
                   INITIALIZE l_vmn.* TO NULL
                   LET l_vmn.vmn01  = g_part
                  #LET l_vmn.vmn02  = g_sfb.sfb01 #FUN-A40034 mark
                   LET l_vmn.vmn02  = g_wono      #FUN-A40034 add
                   LET l_vmn.vmn03  = l_ecm.ecm03
                   LET l_vmn.vmn04  = l_ecm.ecm04
                   LET l_vmn.vmn08  = NULL
                   LET l_vmn.vmn081 = NULL
                   LET l_vmn.vmn09  = 0
                   LET l_vmn.vmn12  = 0
                   LET l_vmn.vmn13  = 1
                   LET l_vmn.vmn15  = 0
                   LET l_vmn.vmn16  = 9999
                   LET l_vmn.vmn17  = 1
                   LET l_vmn.vmn19  = 0
                   LET l_vmn.vmn20  = l_ecb.ecb19 #FUN-9A0048 add
                   LET l_vmn.vmn21  = l_ecb.ecb21 #FUN-9A0048 add
                   LET l_vmn.vmnlegal = g_legal   #FUN-9A0048 add
                   LET l_vmn.vmnplant = g_plant   #FUN-9A0048 add
                   LET l_vmn.vmn012   = l_ecm.ecm012  #FUN-9A0048 add
                   
                   INSERT INTO vmn_file VALUES(l_vmn.*)
                   IF STATUS THEN
                       CALL cl_err3("ins","vmn_file(2)","","",STATUS,"","",1)
                       LET g_success = 'N'
                       EXIT FOREACH
                   END IF
               END IF
           END IF
           #FUN-990008---add-----end----

           INSERT INTO vnm_file(vnm00,vnm01,vnm02,vnm03,vnm04,vnm05,vnm06,vnmlegal,vnmplant,vnm012) #FUN-A40034 add vnmlegal,vnmplant,vnm012
           #SELECT g_sfb.sfb05,g_sfb.sfb01,vnm02,vnm03,vnm04,vnm05,vnm06  #MOD-940141 MARK
           #SELECT g_part,g_sfb.sfb01,vnm02,vnm03,vnm04,vnm05,vnm06       #MOD_940141 ADD #FUN-A40034 mark
            SELECT g_part,g_wono,vnm02,vnm03,vnm04,vnm05,vnm06,g_legal,g_plant,vnm012     #FUN-A40034 add
              FROM vnm_file
              #WHERE vnm00=g_sfb.sfb05  #MOD-940141 MARK
               WHERE vnm00=g_part  #MOD-940141 ADD
               #AND vnm01 = g_sfb.sfb06 #FUN-A40034 mark
                AND vnm01 = g_primary   #FUN-A40034 add
                AND vnm02 = l_ecm.ecm03   #加工序號 #FUN-990008 add
                AND vnm012 = l_ecm.ecm012 #製程段號 #FUN-990008 add
           #FUN-990008---add-----str----
           IF STATUS THEN
               CALL cl_err3("ins","vnm_file","","",STATUS,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
           END IF
           #FUN-990008---add-----end----
        END IF
        #FUN-8A0090 ------------------------------------end---


        #------>insert sgd_file
        #------>工單製程單元資料
        DECLARE sgc_cur CURSOR FOR
           SELECT * FROM sgc_file
            WHERE  sgc01 = l_ecb.ecb01
              AND  sgc02 = l_ecb.ecb02
              AND  sgc03 = l_ecb.ecb03
              AND  sgc04 = l_ecb.ecb08
        FOREACH sgc_cur INTO l_sgc.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           INITIALIZE l_sgd.* TO NULL
           LET l_sgd.sgd00 = g_wono
           IF s_industry('slk') THEN         #No.FUN-840178
              LET l_sgd.sgd01 = g_sfb.sfb05  #No.FUN-840178
           ELSE                              #No.FUN-840178
             #LET l_sgd.sgd01 = l_sgc.sgc01  #MOD-890158 mark
              LET l_sgd.sgd01 = g_part       #MOD-890158
           END IF                            #No.FUN-840178
           LET l_sgd.sgd02 = l_sgc.sgc02
           LET l_sgd.sgd03 = l_sgc.sgc03
           LET l_sgd.sgd04 = l_sgc.sgc04
           LET l_sgd.sgd05 = l_sgc.sgc05
           LET l_sgd.sgd06 = l_sgc.sgc06
           LET l_sgd.sgd07 = l_sgc.sgc07
           LET l_sgd.sgd08 = l_sgc.sgc08
           LET l_sgd.sgd09 = l_sgc.sgc09
           LET l_sgd.sgd10 = l_sgc.sgc10   #No.FUN-840155
           LET l_sgd.sgd11 = l_sgc.sgc11   #No.FUN-840155
           LET l_sgd.sgd13 = l_sgc.sgc13   #CHI-970027
           LET l_sgd.sgd14 = l_sgc.sgc14   #CHI-970027
#No.FUN-810017--Begin
      IF s_industry('slk') THEN
          #LET l_sgd.sgd13 = l_sgc.sgc13   #CHI-970027
#          LET l_sgd.sgdslk01 = l_sgc.sgcslk01   #No.FUN-830088
          #LET l_sgd.sgd14 = l_sgc.sgc14         #No.FUN-840155 #CHI-970027
           LET l_sgd.sgdslk02 = l_sgc.sgcslk02
           LET l_sgd.sgdslk03 = l_sgc.sgcslk03
           LET l_sgd.sgdslk04 = l_sgc.sgcslk04
           LET l_sgd.sgdslk05 = l_sgc.sgcslk05
      END IF
#No;FUN-810017--End

           #MOD-840481............begin
           IF cl_null(l_sgd.sgd13) THEN   #No.FUN-840155
              LET l_sgd.sgd13='N'
           END IF                         #No.FUN-840155
#          LET l_sgd.sgd14='N'            #No.FUN-840155
           #MOD-840481............end

           LET l_sgd.sgdplant   =  g_plant   #FUN-980012 add
           LET l_sgd.sgdlegal   =  g_legal   #FUN-980012 add
           #No.FUN-A70131--begin
           IF cl_null(l_sgd.sgd012) THEN 
              LET l_sgd.sgd012=' '
           END IF 
           IF cl_null(l_sgd.sgd03) THEN 
              LET l_sgd.sgd03=0
           END IF 
           #No.FUN-A70131--end                
           INSERT INTO sgd_file VALUES(l_sgd.*)
         # IF STATUS THEN
         #    CALL cl_err('ins_sgd',STATUS,1)
         #    LET g_success= 'N'
         # END IF
        END FOREACH
        LET g_cnt=g_cnt+1
    END FOREACH
    #---------------------------------------->

    IF g_cnt > 0 THEN
       LET g_track='Y'
    END IF

    RETURN g_cnt
END FUNCTION

#FUN-A50066--begin--add--------------------
FUNCTION s_schdat_output(p_ecu012,p_sfb08,p_sfb01)  #FUN-B20087
DEFINE p_ecu012     LIKE ecu_file.ecu012
DEFINE p_sfb08      LIKE sfb_file.sfb08
DEFINE l_ecm        RECORD LIKE ecm_file.*
DEFINE l_ecm65      LIKE ecm_file.ecm65
DEFINE l_ac,i       LIKE type_file.num5
DEFINE sr           DYNAMIC ARRAY OF RECORD
                    ecu012  LIKE ecu_file.ecu012,
                    qty     LIKE ecm_file.ecm65,
                    ecm62   LIKE ecm_file.ecm62,
                    ecm63   LIKE ecm_file.ecm63
                    END RECORD
DEFINE l_flag       LIKE type_file.num5  #MOD-AC0336
DEFINE l_ima571     LIKE ima_file.ima571 #MOD-AC0336
DEFINE p_sfb01      LIKE sfb_file.sfb01  #FUN-B20087
   
   #CHI-B80096--mark--Begin--
   #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_ima571  #MOD-AC0336  #FUN-B20087
   #CHI-B80096--mark---End---

   IF p_ecu012 IS NULL THEN LET p_ecu012=' ' END IF  #CHI-B80096--add--
   DECLARE ecm_cur CURSOR FOR
    SELECT * FROM ecm_file WHERE ecm01=p_sfb01  #FUN-B20087
       AND ecm012 = p_ecu012
     ORDER BY ecm03 DESC
  FOREACH ecm_cur INTO l_ecm.*
    #IF STATUS THEN CALL cl_err('ecm_cur:',STATUS,1) EXIT FOREACH END IF
    #IF l_ecm.ecm62 IS NULL THEN LET l_ecm.ecm62 = 1 END IF  #FUN-A80102       #CHI-B80096-mark-
    #IF l_ecm.ecm63 IS NULL THEN LET l_ecm.ecm63 = 1 END IF  #FUN-A80102       #CHI-B80096-mark-
    IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF #CHI-B80096--add--
    IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF #CHI-B80096--add--

    CALL cralc_eck_rate(p_sfb01,l_ecm.ecm03,l_ecm.ecm012,p_sfb08,l_ecm.ecm12,l_ecm.ecm34,  #FUN-B20087
                       l_ecm.ecm64,l_ecm.ecm62/l_ecm.ecm63,1)
    RETURNING l_ecm65
    LET l_ecm65 = s_digqty(l_ecm65,l_ecm.ecm58) #FUN-BB0083 add
    UPDATE ecm_file SET ecm65=l_ecm65 WHERE ecm01=p_sfb01 AND ecm03=l_ecm.ecm03 AND ecm012=l_ecm.ecm012 #FUN-B20087
    LET p_sfb08=l_ecm65/l_ecm.ecm62*l_ecm.ecm63
  END FOREACH
 #FUN-B20087--begin--mod-----
 #DECLARE ecu012_cur CURSOR FOR
 #  SELECT DISTINCT ecu012 FROM ecu_file WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06 AND ecu015=p_ecu012  #MOD-AC0336
  DECLARE ecu012_cur CURSOR FOR
    SELECT DISTINCT ecm012 FROM ecm_file WHERE ecm01=p_sfb01 AND ecm015=p_ecu012 
 #FUN-B20087--end--mod------
  IF g_sma.sma541 = 'Y' AND NOT cl_null(p_ecu012) THEN  #FUN-B20087 #TQC-B50114
     LET l_ac = 1
     FOREACH ecu012_cur INTO sr[l_ac].ecu012
        #IF STATUS THEN CALL cl_err('ecu012_cur:',STATUS,1) EXIT FOREACH END IF
        SELECT ecm65,ecm62,ecm63 INTO sr[l_ac].qty,sr[l_ac].ecm62,sr[l_ac].ecm63 FROM ecm_file
        #TQC-BB0047 MOD begin----------------------------------------------
        ##MOD-BA0202 MOD begin---------------------------------------------- 
        WHERE ecm01=p_sfb01 AND ecm012=p_ecu012    #FUN-B20078
          AND ecm03 = (SELECT MIN(ecm03) FROM ecm_file WHERE ecm01=p_sfb01 AND ecm012=p_ecu012)  #FUN-B20078
        #WHERE ecm01=p_sfb01 AND ecm012=sr[l_ac].ecu012
        #  AND ecm03 = (SELECT MIN(ecm03) FROM ecm_file WHERE ecm01=p_sfb01 AND ecm012=sr[l_ac].ecu012)
        ##MOD-BA0202 MOD end------------------------------------------------
        #TQC-BB0047 MOD end------------------------------------------------
        IF cl_null(sr[l_ac].ecm62) OR sr[l_ac].ecm62 = 0 THEN LET sr[l_ac].ecm62 = 1 END IF #CHI-B80096--add--
        IF cl_null(sr[l_ac].ecm63) OR sr[l_ac].ecm63 = 0 THEN LET sr[l_ac].ecm63 = 1 END IF #CHI-B80096--add--
        LET sr[l_ac].qty=sr[l_ac].qty/sr[l_ac].ecm62*sr[l_ac].ecm63
        LET l_ac=l_ac+1
     END FOREACH
     FOR i=1 TO l_ac - 1
        CALL s_schdat_output(sr[i].ecu012,sr[i].qty,p_sfb01)   #FUN-B20087
     END FOR
  END IF  #FUN-B20087

END FUNCTION

#check是否為最終製程
#p_sfb01:工單單號  p_shb012:製程編號  p_shb06:製程序
#TRUE:不為最終製程  FALSE:最終製程
FUNCTION s_schdat_chk_ecm03(p_sfb01,p_shb012,p_shb06)
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06  #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE p_shb012  LIKE shb_file.shb012
DEFINE p_shb06   LIKE shb_file.shb06
DEFINE l_ecm012  LIKE ecm_file.ecm012 #FUN-B10056
DEFINE l_ecm03   LIKE ecm_file.ecm03
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336 #FUN-B10056

  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=p_sfb01 #MOD-AC0336  #FUN-B10056
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336  #FUN-B10056
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
    #FUN-B10056--begin--modify------
    #SELECT ecu012 INTO l_ecu012 FROM ecu_file
    # WHERE ecu01 = l_sfb05
    #   AND ecu02 = l_sfb06
    #   AND (ecu015 IS NULL OR ecu015=' ')
     SELECT DISTINCT ecm012 INTO l_ecm012 FROM ecm_file
      WHERE ecm01=p_sfb01 AND (ecm015 IS NULL OR ecm015=' ')
    #FUN-B10056--end--modify-----------
     IF l_ecm012 IS NULL THEN LET l_ecm012 = ' ' END IF   #FUN-B10056
     IF l_ecm012 <> p_shb012  THEN RETURN 1 END IF #不為最終製程段  #FUN-B10056
  END IF
  IF p_shb012 IS NULL THEN LET p_shb012 = ' ' END IF
  SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
   WHERE ecm01 = p_sfb01
     AND ecm012= p_shb012
  IF cl_null(l_ecm03) THEN CALL cl_err('','asf-138',1) RETURN 1 END IF
  IF l_ecm03 = p_shb06 THEN RETURN 0 END IF  #最終製程
  RETURN 1
END FUNCTION
#FUN-A50066--end--add--------------------

#FUN-A50066
#取得最大製程段+製程序
FUNCTION s_schdat_max_ecm03(p_sfb01)
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06  #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE l_ecm012  LIKE ecm_file.ecm012 #FUN-B10056
DEFINE l_ecm03   LIKE ecm_file.ecm03
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336 #FUN-B10056

  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=p_sfb01 #MOD-AC0336 #FUN-B10056
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
    #FUN-B10056--begin--modify-----
    #SELECT ecu012 INTO l_ecu012 FROM ecu_file
    # WHERE ecu01 = l_sfb05
    #   AND ecu02 = l_sfb06
    #   AND (ecu015 IS NULL OR ecu015=' ')
     SELECT DISTINCT ecm012 INTO l_ecm012 FROM ecm_file
      WHERE ecm01=p_sfb01 AND (ecm015 IS NULL OR ecm015=' ')
    #FUN-B10056--end--nodify------
  END IF
  IF l_ecm012 IS NULL THEN LET l_ecm012 = ' ' END IF #FUN-B10056
  SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
   WHERE ecm01 = p_sfb01
     AND ecm012= l_ecm012  #FUN-B10056
  RETURN l_ecm012,l_ecm03  #FUN-B10056
END FUNCTION

#FUN-A60095
#取得最小製程段+製程序
FUNCTION s_schdat_min_ecm03(p_sfb01)
DEFINE l_sfb93   LIKE sfb_file.sfb93
DEFINE l_sfb06   LIKE sfb_file.sfb06
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE l_ecm012  LIKE ecm_file.ecm012 #FUN-B10056
DEFINE l_ecm03   LIKE ecm_file.ecm03
DEFINE l_sql     STRING
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336 #FUN-B10056

  SELECT sfb93,sfb06 INTO l_sfb93,l_sfb06   #MOD-AC0336
                           FROM sfb_file 
                          WHERE sfb01=p_sfb01
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
    #FUN-B10056--begin--mod-----------
    #LET l_sql = "SELECT A.ecu012 FROM ecu_file A",
    #            " WHERE A.ecu01 = '",l_sfb05,"'",
    #            "   AND A.ecu02 = '",l_sfb06,"'",
    #            "   AND 0 = (SELECT COUNT(*) FROM ecu_file B ",
    #            " WHERE B.ecu01 = A.ecu01",
    #            "   AND B.ecu02 = A.ecu02 AND B.ecu015=A.ecu012)"
     LET l_sql = "SELECT DISTINCT A.ecm012 FROM ecm_file A",
                 " WHERE A.ecm01 = '",p_sfb01,"'",
                 "   AND 0 = (SELECT COUNT(*) FROM ecm_file B ",
                 " WHERE B.ecm01 = A.ecm01",
                 "   AND B.ecm015=A.ecm012)"
    #FUN-B10056--end--mod-------------
     DECLARE s_schdat_min_ecm03_c CURSOR FROM l_sql
     FOREACH s_schdat_min_ecm03_c INTO l_ecm012  #FUN-B10056
        EXIT FOREACH
     END FOREACH
  END IF
  IF l_ecm012 IS NULL THEN LET l_ecm012 = ' ' END IF  #FUN-B10056
  SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
   WHERE ecm01 = p_sfb01
     AND ecm012= l_ecm012  #FUN-B10056
  RETURN l_ecm012,l_ecm03
END FUNCTION

#FUN-A60095--begin--by jan add---------
#check是否為最初製程
#p_sfb01:RUNCARD單號  p_sgm012:製程編號  p_sgm03:製程序
#TRUE:不為最初製程  FALSE:最初製程
FUNCTION s_schdat_chk_min_sgm03(p_shm01,p_sgm012,p_sgm03)
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_shm06  LIKE shm_file.shm06   #FUN-B10056
#DEFINE l_shm05  LIKE shm_file.shm05   #FUN-B10056
DEFINE p_shm01   LIKE shm_file.shm01
DEFINE p_sgm012  LIKE sgm_file.sgm012
DEFINE p_sgm03   LIKE sgm_file.sgm03
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sgm03   LIKE sgm_file.sgm03
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336  #FUN-B10056
DEFINE l_shm012  LIKE shm_file.shm012 #MOD-AC0336

 #SELECT sfb93,shm06,shm05 INTO l_sfb93,l_shm06,l_shm05  #MOD-AC0336
  SELECT sfb93 INTO l_sfb93 #MOD-AC0336 #FUN-B10056
    FROM sfb_file,shm_file
   WHERE shm01=p_shm01 AND shm012=sfb01
 #CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag,l_shm05  #MOD-AC0336 #FUN-B10056
  
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
     LET l_cnt = 0
    #FUN-B10056--begin--mod-----
    #SELECT COUNT(*) INTO l_cnt FROM ecu_file
    # WHERE ecu01 = l_shm05
    #   AND ecu02 = l_shm06
    #   AND ecu015= p_sgm012 
     SELECT COUNT(*) INTO l_cnt FROM sgm_file
      WHERE sgm01=p_shm01 AND sgm015=p_sgm012
    #FUN-B10056--end--mod------
     IF l_cnt > 0 THEN RETURN 1 END IF #不為最初製程
  END IF
  IF p_sgm012 IS NULL THEN LET p_sgm012 = ' ' END IF
  SELECT MIN(sgm03) INTO l_sgm03 FROM sgm_file
   WHERE sgm01 = p_shm01
     AND sgm012= p_sgm012
  IF cl_null(l_sgm03) THEN RETURN 1 END IF
  IF l_sgm03 = p_sgm03 THEN RETURN 0 ELSE RETURN 1 END IF  #最初製程
  RETURN 1
END FUNCTION

#check是否為最初製程
#p_sfb01:工單單號  p_ecm012:製程編號  p_ecm03:製程序
#TRUE:不為最初製程  FALSE:最初製程
FUNCTION s_schdat_chk_min_ecm03(p_sfb01,p_ecm012,p_ecm03)
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06  #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE p_ecm012  LIKE ecm_file.ecm012
DEFINE p_ecm03   LIKE ecm_file.ecm03
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_ecm03   LIKE ecm_file.ecm03
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336  #FUN-B10056

  SELECT sfb93 INTO l_sfb93   #MOD-AC0336  #FUN-B10056
    FROM sfb_file
   WHERE sfb01=p_sfb01
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
     LET l_cnt = 0
    #FUN-B10056--begin--mod------
    #SELECT COUNT(*) INTO l_cnt FROM ecu_file
    # WHERE ecu01 = l_sfb05
    #   AND ecu02 = l_sfb06
    #   AND ecu015= p_ecm012
     SELECT COUNT(*) INTO l_cnt FROM ecm_file
      WHERE ecm01=p_sfb01 AND ecm015=p_ecm012
     IF l_cnt > 0 THEN RETURN 1 END IF #不為最初製程
  END IF
  IF p_ecm012 IS NULL THEN LET p_ecm012 = ' ' END IF
  SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
   WHERE ecm01 = p_sfb01
     AND ecm012= p_ecm012
  IF cl_null(l_ecm03) THEN RETURN 1 END IF
  IF l_ecm03 = p_ecm03 THEN RETURN 0 ELSE RETURN 1 END IF  #最初製程
  RETURN 1
END FUNCTION
#FUN-A60095--end------------

#FUN-A60095
#取得前製程段+製程序
FUNCTION s_schdat_previous_ecm03(p_sfb01,p_ecm012,p_ecm03)
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE p_ecm012  LIKE ecm_file.ecm012
DEFINE p_ecm03   LIKE ecm_file.ecm03
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06 #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05 #FUN-B10056
DEFINE l_ecu012  LIKE ecu_file.ecu012
DEFINE l_ecm03   LIKE ecm_file.ecm03
DEFINE l_sql     STRING
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336  #FUN-B10056

  SELECT sfb93 INTO l_sfb93   #MOD-AC0336  #FUN-B10056
    FROM sfb_file 
   WHERE sfb01=p_sfb01
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336  #FUN-B10056
  LET l_ecm03=NULL
  SELECT ecm03 INTO l_ecm03 FROM ecm_file
   WHERE ecm01=p_sfb01
     AND ecm012=p_ecm012
     AND ecm03=(SELECT MAX(ecm03) FROM ecm_file
                 WHERE ecm01=p_sfb01 AND ecm012=p_ecm012 AND ecm03< p_ecm03)
  LET l_ecu012 = p_ecm012
  IF l_ecm03 IS NULL THEN #跨製程段
     IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
        LET l_ecu012 = NULL
       #FUN-B10056--begin--modify-----
       #LET l_sql = "SELECT ecu012 FROM ecu_file ",
       #            " WHERE ecu01 = '",l_sfb05,"'",
       #            "   AND ecu02 = '",l_sfb06,"'",
       #            "   AND ecu015 = '",p_ecm012,"'"
        LET l_sql = "SELECT DISTINCT ecm012 FROM ecm_file ",
                    " WHERE ecm01 = '",p_sfb01,"'",
                    "   AND ecm015 = '",p_ecm012,"'"
       #FUN-B10056--end--modify------
        DECLARE s_schdat_previous_ecm03 CURSOR FROM l_sql
        FOREACH s_schdat_previous_ecm03 INTO l_ecu012
           EXIT FOREACH
        END FOREACH
        IF l_ecu012 IS NULL THEN LET l_ecu012 = ' ' END IF
        SELECT MAX(ecm03) INTO l_ecm03 FROM ecm_file
         WHERE ecm01 = p_sfb01
           AND ecm012= l_ecu012
     END IF
  END IF
  RETURN l_ecu012,l_ecm03
END FUNCTION

#FUN-A50066
#取得最大製程段+製程序
FUNCTION s_schdat_max_sgm03(p_sgm01)
DEFINE l_sfb01   LIKE sfb_file.sfb01
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06  #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE p_sgm01   LIKE sgm_file.sgm01
DEFINE l_sgm012  LIKE sgm_file.sgm012 #FUN-B10056
DEFINE l_sgm03   LIKE sgm_file.sgm03
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336  #FUN-B10056
  
  SELECT shm012 INTO l_sfb01 FROM shm_file WHERE shm01=p_sgm01
  SELECT sfb93 INTO l_sfb93   #MOD-ACO336 
    FROM sfb_file WHERE sfb01=l_sfb01
 #CALL s_schdat_sel_ima571(l_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056
  IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
    #FUN-B10056--begin--mod-----
    #SELECT ecu012 INTO l_ecu012 FROM ecu_file
    # WHERE ecu01 = l_sfb05
    #   AND ecu02 = l_sfb06
    #   AND (ecu015 IS NULL OR ecu015=' ')
     SELECT DISTINCT sgm012 INTO l_sgm012 FROM sgm_file
      WHERE sgm01=p_sgm01 AND (sgm015 IS NULL OR sgm015=' ')
    #FUN--B10056--end--mod------
  END IF
  IF l_sgm012 IS NULL THEN LET l_sgm012 = ' ' END IF
  SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file
   WHERE sgm01 = p_sgm01
     AND sgm012= l_sgm012
  IF cl_null(l_sgm03) THEN LET l_sgm03 = 0 END IF
  RETURN l_sgm012,l_sgm03
END FUNCTION

#FUN-A60095
#取得下製程段+製程序
FUNCTION s_schdat_next_ecm03(p_sfb01,p_ecm012,p_ecm03)
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE p_ecm012  LIKE ecm_file.ecm012
DEFINE p_ecm03   LIKE ecm_file.ecm03
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06  #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05  #FUN-B10056
DEFINE l_ecu012  LIKE ecu_file.ecu012
DEFINE l_ecm03   LIKE ecm_file.ecm03
DEFINE l_sql     STRING
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336 #FUN-B10056

  SELECT sfb93 INTO l_sfb93   #MOD-AC0336
    FROM sfb_file 
   WHERE sfb01=p_sfb01
 #CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056
  LET l_ecm03=NULL
  SELECT ecm03 INTO l_ecm03 FROM ecm_file
   WHERE ecm01=p_sfb01
     AND ecm012=p_ecm012
     AND ecm03=(SELECT MIN(ecm03) FROM ecm_file
                 WHERE ecm01=p_sfb01 AND ecm012=p_ecm012 AND ecm03> p_ecm03)
  LET l_ecu012 = p_ecm012
  IF l_ecm03 IS NULL THEN #跨製程段
     IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
        LET l_ecu012 = NULL
       #FUN-B10056--begin--mod-----
       #LET l_sql = "SELECT ecu015 FROM ecu_file ",
       #            " WHERE ecu01 = '",l_sfb05,"'",
       #            "   AND ecu02 = '",l_sfb06,"'",
       #            "   AND ecu012 = '",p_ecm012,"'"
        LET l_sql = "SELECT DISTINCT ecm015 FROM ecm_file ",
                    " WHERE ecm01 = '",p_sfb01,"'",
                    "   AND ecm012 = '",p_ecm012,"'"
       #FUN-B10056--end--mod-------
        DECLARE s_schdat_next_ecm03 CURSOR FROM l_sql
        FOREACH s_schdat_next_ecm03 INTO l_ecu012
           EXIT FOREACH
        END FOREACH
        IF l_ecu012 IS NULL THEN LET l_ecu012 = ' ' END IF
        SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
         WHERE ecm01 = p_sfb01
           AND ecm012= l_ecu012
     END IF
  END IF
  RETURN l_ecu012,l_ecm03
END FUNCTION

#RUNCARD 取得下製程段+製程序
FUNCTION s_schdat_next_sgm03(p_sgm01,p_sgm012,p_sgm03)
DEFINE p_sgm01   LIKE sgm_file.sgm01
DEFINE p_sgm012  LIKE sgm_file.sgm012
DEFINE p_sgm03   LIKE sgm_file.sgm03
DEFINE l_sfb93   LIKE sfb_file.sfb93
#DEFINE l_sfb06  LIKE sfb_file.sfb06   #FUN-B10056
#DEFINE l_sfb05  LIKE sfb_file.sfb05   #FUN-B10056
DEFINE l_ecu012  LIKE ecu_file.ecu012
DEFINE l_sgm03   LIKE sgm_file.sgm03
DEFINE l_sql     STRING
DEFINE l_sfb01   LIKE sfb_file.sfb01
#DEFINE l_flag   LIKE type_file.num5  #MOD-AC0336 #FUN-B10056

  SELECT shm012 INTO l_sfb01 FROM shm_file WHERE shm01=p_sgm01
  SELECT sfb93 INTO l_sfb93  #MOD-AC0336  #FUN-B10056
    FROM sfb_file
   WHERE sfb01=l_sfb01
 #CALL s_schdat_sel_ima571(l_sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336 #FUN-B10056

  LET l_sgm03=NULL
  SELECT sgm03 INTO l_sgm03 FROM sgm_file
   WHERE sgm01=p_sgm01
     AND sgm012=p_sgm012
     AND sgm03=(SELECT MIN(sgm03) FROM sgm_file
                 WHERE sgm01=p_sgm01 AND sgm012=p_sgm012 AND sgm03> p_sgm03)
  LET l_ecu012 = p_sgm012
  IF l_sgm03 IS NULL THEN #跨製程段
     IF l_sfb93='Y' AND g_sma.sma541='Y' THEN
        LET l_ecu012 = NULL
       #FUN-B10056--begin--mod------
       #LET l_sql = "SELECT ecu015 FROM ecu_file ",
       #            " WHERE ecu01 = '",l_sfb05,"'",
       #            "   AND ecu02 = '",l_sfb06,"'",
       #            "   AND ecu012 = '",p_sgm012,"'"
        LET l_sql = "SELECT DISTINCT sgm015 FROM sgm_file ",
                    " WHERE sgm01 = '",p_sgm01,"'",
                    "   AND sgm012 = '",p_sgm012,"'"
       #FUN-B10056--end--mod-------
        DECLARE s_schdat_next_sgm03 CURSOR FROM l_sql
        FOREACH s_schdat_next_sgm03 INTO l_ecu012
           EXIT FOREACH
        END FOREACH
        IF l_ecu012 IS NULL THEN LET l_ecu012 = ' ' END IF
        SELECT MIN(sgm03) INTO l_sgm03 FROM sgm_file
         WHERE sgm01 = p_sgm01
           AND sgm012= l_ecu012
     END IF
  END IF
  RETURN l_ecu012,l_sgm03
END FUNCTION

#MOD-AC0336--begin--add----
FUNCTION s_schdat_sel_ima571(p_sfb01)
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE l_sfb05   LIKE sfb_file.sfb05
DEFINE l_sfb06   LIKE sfb_file.sfb06
DEFINE l_ima571  LIKE ima_file.ima571
DEFINE l_cnt     LIKE type_file.num5


  SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file WHERE sfb01=p_sfb01
  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=l_sfb05
  IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF
  LET l_cnt = 0
  SELECT COUNT(ecu01) INTO l_cnt FROM ecu_file
   WHERE ecu01=l_ima571 AND ecu02=l_sfb06
     AND ecuacti = 'Y'  #CHI-C90006
  IF l_cnt = 0 THEN
     SELECT COUNT(ecu01) INTO l_cnt FROM ecu_file
      WHERE ecu01=l_sfb05 AND ecu02=l_sfb06
        AND ecuacti = 'Y'  #CHI-C90006
     IF l_cnt = 0 THEN
        RETURN 0,''
     ELSE
        RETURN 1,l_sfb05
     END IF
  ELSE
     RETURN 1,l_ima571
  END IF
END FUNCTION
#MOD-AC0336--end-add-----

#TQC-AC0374--begin--add-----
#抓取製程段名稱
#p_sfb01: 工單單號   p_ecu012:製程段號
#FUN-B10056--begin--mark--改成ecm_file撈取
#FUNCTION s_schdat_ecu014(p_sfb01,p_ecu012)
#DEFINE p_sfb01     LIKE sfb_file.sfb01
#DEFINE p_ecu012    LIKE ecu_file.ecu012
#DEFINE l_sfb05     LIKE sfb_file.sfb05
#DEFINE l_sfb06     LIKE sfb_file.sfb06
#DEFINE l_ecu014    LIKE ecu_file.ecu014
#DEFINE l_flag      LIKE type_file.num5

#  SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=p_sfb01
#  CALL s_schdat_sel_ima571(p_sfb01) RETURNING l_flag,l_sfb05
#  SELECT ecu014 INTO l_ecu014 FROM ecu_file
#   WHERE ecu01=l_sfb05
#     AND ecu02=l_sfb06
#     AND ecu012=p_ecu012
#  RETURN l_ecu014
#END FUNCTION
#FUN-B10056--end--mark-----
#TQC-AC0374--end--add-----

#FUN-B10056 -----------------Begin-------------------
#檢查製程段是否存在
FUNCTION s_schdat_ecm012(p_ecm01,p_ecm012)
   DEFINE p_ecm01     LIKE ecm_file.ecm01
   DEFINE p_ecm012    LIKE ecm_file.ecm012
   DEFINE l_cnt       LIKE type_file.num10
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ecm_file
    WHERE ecm01 = p_ecm01 
      AND ecm012 = p_ecm012   
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      RETURN TRUE
   ELSE 
      RETURN FALSE 
   END IF
END FUNCTION

#抓取制程段号说明
FUNCTION s_schdat_ecm014(p_ecm01,p_ecm012)
   DEFINE p_ecm01     LIKE ecm_file.ecm01
   DEFINE p_ecm012    LIKE ecm_file.ecm012
   DEFINE l_ecm014    LIKE ecm_file.ecm014
   DECLARE ecm014_cs CURSOR FOR 
           SELECT DISTINCT ecm014 FROM ecm_file
            WHERE ecm01=p_ecm01 AND ecm012=p_ecm012
   FOREACH ecm014_cs INTO l_ecm014
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
      END IF
      EXIT FOREACH
   END FOREACH
   RETURN l_ecm014
END FUNCTION
#FUN-B10056 ---------------------End-------------------------
#FUN-C10002 --START--
FUNCTION s_schdat_pmn78(l_pmn41,l_pmn012,l_pmn43,l_pmn18,l_pmn32)
   DEFINE l_pmn41  LIKE pmn_file.pmn41   #工單號碼
   DEFINE l_pmn012 LIKE pmn_file.pmn012  #製程段號
   DEFINE l_pmn43  LIKE pmn_file.pmn43   #本製程序號
   DEFINE l_pmn18  LIKE pmn_file.pmn18   #RunCard單號(委外) 
   DEFINE l_pmn32  LIKE pmn_file.pmn32   #RunCard委外製程序
   DEFINE l_pmn78  LIKE pmn_file.pmn78   #作業編號

   CASE 
      #runcard工單
      WHEN (cl_null(l_pmn32) = FALSE AND l_pmn32 > 0 AND cl_null(l_pmn18) = FALSE) 
         SELECT sgm04 INTO l_pmn78 FROM sgm_file
          WHERE sgm01 = l_pmn18 AND sgm03 = l_pmn32 AND sgm012 = l_pmn012
          
      #委外採購單
      WHEN (cl_null(l_pmn43) = FALSE AND l_pmn43 > 0 )
         SELECT ecm04 INTO l_pmn78 FROM ecm_file
          WHERE ecm01 = l_pmn41 AND ecm03 = l_pmn43 AND ecm012 = l_pmn012
   END CASE    

   IF cl_null(l_pmn78) THEN
      LET l_pmn78 = ' '
   END IF 
   
   RETURN l_pmn78   
END FUNCTION
#FUN-C10002 --END--
#FUN-B50046
