/*
================================================================================
檔案代號:apt_file
檔案名稱:部门―账款类型缺省会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apt_file
(
apt01       varchar2(10) NOT NULL,   /*帐款类型                               */
                                     /*帳款類別                               */
apt02       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
apt03       varchar2(24),            /*借方科目编号                           */
                                     /*借方科目編號                           */
apt031      varchar2(24),            /*借方科目编号二                         */
apt032      varchar2(24),            /*No Use                                 */
apt033      varchar2(24),            /*No Use                                 */
apt034      varchar2(24),            /*No Use                                 */
apt035      varchar2(24),            /*No Use                                 */
apt036      varchar2(24),            /*No Use                                 */
apt037      varchar2(24),            /*No Use                                 */
apt038      varchar2(24),            /*No Use                                 */
apt039      varchar2(24),            /*No Use                                 */
apt04       varchar2(24),            /*贷方科目编号                           */
                                     /*貸方科目編號                           */
apt05       varchar2(24),            /*结案科目编号                           */
                                     /*結案科目編號                           */
aptacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
aptuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
aptgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
aptmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
aptdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
apt041      varchar2(24),            /*贷方科目编号二                         */
aptud01     varchar2(255),           /*自订字段-Textedit                      */
aptud02     varchar2(40),            /*自订字段-文字                          */
aptud03     varchar2(40),            /*自订字段-文字                          */
aptud04     varchar2(40),            /*自订字段-文字                          */
aptud05     varchar2(40),            /*自订字段-文字                          */
aptud06     varchar2(40),            /*自订字段-文字                          */
aptud07     number(15,3),            /*自订字段-数值                          */
aptud08     number(15,3),            /*自订字段-数值                          */
aptud09     number(15,3),            /*自订字段-数值                          */
aptud10     number(10),              /*自订字段-整数                          */
aptud11     number(10),              /*自订字段-整数                          */
aptud12     number(10),              /*自订字段-整数                          */
aptud13     date,                    /*自订字段-日期                          */
aptud14     date,                    /*自订字段-日期                          */
aptud15     date,                    /*自订字段-日期                          */
apt06       varchar2(24),            /*代销科目                               */
apt061      varchar2(24),            /*代销科目二                             */
aptoriu     varchar2(10),            /*资料建立者                             */
aptorig     varchar2(10),            /*资料建立部门                           */
apt07       varchar2(10),            /*　                                     */
apt08       varchar2(5)              /*AP单别                                 */
);

alter table apt_file add  constraint apt_pk primary key  (apt01,apt02) enable validate;
grant select on apt_file to tiptopgp;
grant update on apt_file to tiptopgp;
grant delete on apt_file to tiptopgp;
grant insert on apt_file to tiptopgp;
grant index on apt_file to public;
grant select on apt_file to ods;
