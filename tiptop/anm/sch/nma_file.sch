/*
================================================================================
檔案代號:nma_file
檔案名稱:银行账户资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nma_file
(
nma01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
nma02       varchar2(40),            /*银行简称                               */
                                     /*銀行簡稱                               */
nma03       varchar2(80),            /*银行全名                               */
                                     /*銀行全名                               */
nma04       varchar2(30),            /*银行帐号                               */
                                     /*銀行帳號                               */
nma05       varchar2(24),            /*银行存款会计科目                       */
                                     /*銀行存款會計科目                       */
nma061      varchar2(255),           /*地址(第一行)                           */
                                     /*地址          #genero 改為TEXTEDIT     */
nma062      varchar2(255),           /*地址(第二行)                           */
                                     /*NO USE        #genero                  */
nma07       varchar2(40),            /*电话号码                               */
                                     /*電話號碼                               */
nma08       varchar2(30),            /*连络人                                 */
                                     /*連絡人                                 */
nma09       varchar2(4),             /*存款类型                               */
                                     /*存款類別                               */
nma10       varchar2(4),             /*存款币种                               */
                                     /*存款幣別                               */
nma11       varchar2(1),             /*No Use                                 */
nma12       varchar2(20),            /*套印程序编号                           */
                                     /*套印程式編號(若為套印支票)             */
nma13       varchar2(10),            /*No Use                                 */
nma14       number(5),               /*No Use                                 */
nma15       number(5),               /*No Use                                 */
nma16       varchar2(24),            /*应付票据会计科目                       */
                                     /*應付票據會計科目 (02/06/14 no use)     */
nma17       varchar2(24),            /*应收票据会计科目                       */
                                     /*應收票據會計科目 (02/06/14 no use)     */
nma18       number(13,2),            /*No Use                                 */
nma19       number(13,2),            /*No Use                                 */
nma20       number(13,2),            /*No Use                                 */
nma21       date,                    /*上次对帐日期                           */
                                     /*上次對帳日期                           */
nma22       number(20,6),            /*上次对帐存款余额                       */
                                     /*上次對帳存款餘額      02/11/26 alter   */
nma23       number(20,6),            /*当前存款余额(原币)                     */
                                     /*目前存款餘額(原幣)    02/11/26 alter   */
nma24       number(20,6),            /*应收票据余额                           */
                                     /*應收票據餘額(本幣)    02/11/26 alter   */
nma25       number(20,6),            /*应付票据余额                           */
                                     /*應付票據餘額(原幣)    02/11/26 alter   */
nma26       number(20,6),            /*融资票据余额                           */
                                     /*融資票據餘額(本幣)    02/11/26 alter   */
nma27       number(20,6),            /*当前存款余额(本币)                     */
                                     /*目前存款餘額(本幣)    02/11/26 alter   */
nma28       varchar2(1),             /*1.支存 2.活存 3.其他                   */
nma29       number(13,2),            /*No Use                                 */
nma30       number(13,2),            /*No Use                                 */
nma31       number(13,2),            /*No Use                                 */
nma32       number(13,2),            /*No Use                                 */
nma33       number(13,2),            /*No Use                                 */
nma34       number(13,2),            /*No Use                                 */
nma35       number(13,2),            /*No Use                                 */
nma36       number(13,2),            /*No Use                                 */
nmaacti     varchar2(1),             /*有效码                                 */
                                     /*有效碼                                 */
nmauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nma051      varchar2(24),            /*银行存款会计科目二                     */
nma37       varchar2(1),             /*银行类型                               */
                                     /*For 內部帳戶                           */
nma38       varchar2(10),            /*内部银行所在结算中心                   */
                                     /*For 內部帳戶                           */
nma39       varchar2(20),            /*开户银行编号                           */
nma40       date,                    /*期初余额日期                           */
nma41       number(20,6),            /*原币期初余额                           */
nma42       number(20,6),            /*本币期初余额                           */
nma43       varchar2(1),             /*是否开通网络银行                       */
nmaud01     varchar2(255),           /*自订字段-Textedit                      */
nmaud02     varchar2(40),            /*自订字段-文字                          */
nmaud03     varchar2(40),            /*自订字段-文字                          */
nmaud04     varchar2(40),            /*自订字段-文字                          */
nmaud05     varchar2(40),            /*自订字段-文字                          */
nmaud06     varchar2(40),            /*自订字段-文字                          */
nmaud07     number(15,3),            /*自订字段-数值                          */
nmaud08     number(15,3),            /*自订字段-数值                          */
nmaud09     number(15,3),            /*自订字段-数值                          */
nmaud10     number(10),              /*自订字段-整数                          */
nmaud11     number(10),              /*自订字段-整数                          */
nmaud12     number(10),              /*自订字段-整数                          */
nmaud13     date,                    /*自订字段-日期                          */
nmaud14     date,                    /*自订字段-日期                          */
nmaud15     date,                    /*自订字段-日期                          */
nma44       varchar2(80),            /*户名                                   */
nma45       varchar2(1) DEFAULT '1' NOT NULL, /*传POS否*/
nma46       varchar2(1) DEFAULT 'N' NOT NULL, /*收银帐户*/
nmaoriu     varchar2(10),            /*资料建立者                             */
nmaorig     varchar2(10),            /*资料建立部门                           */
nma47       varchar2(10)             /*接口银行编码                           */
);

alter table nma_file add  constraint nma_pk primary key  (nma01) enable validate;
grant select on nma_file to tiptopgp;
grant update on nma_file to tiptopgp;
grant delete on nma_file to tiptopgp;
grant insert on nma_file to tiptopgp;
grant index on nma_file to public;
grant select on nma_file to ods;
