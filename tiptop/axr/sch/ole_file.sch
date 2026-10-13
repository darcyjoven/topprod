/*
================================================================================
檔案代號:ole_file
檔案名稱:信用状历史单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ole_file
(
ole01       varchar2(20) NOT NULL,   /*收状单号                               */
                                     /*收狀單號                               */
ole02       number(5) NOT NULL,      /*更改序号                               */
                                     /*修改序號                               */
ole03       date,                    /*开状日                                 */
                                     /*開狀日                                 */
ole04       date,                    /*有效日                                 */
ole05       date,                    /*最后装船日                             */
                                     /*最後裝船日                             */
ole06       varchar2(6),             /*收款条件                               */
                                     /*收款條件                               */
ole07       number(20,6),            /*信用状金额                             */
                                     /*信用狀金額                             */
ole081      varchar2(255),           /*备注一                                 */
                                     /*備註一                            genero*/
ole082      varchar2(255),           /*备注二                                 */
                                     /*no use                            genero*/
ole083      varchar2(255),           /*备注三                                 */
                                     /*no use                            genero*/
ole084      varchar2(255),           /*备注四                                 */
                                     /*no use                            genero*/
ole09       date,                    /*更改日期                               */
                                     /*修改日期                               */
ole10       number(20,6),            /*差额                                   */
                                     /*差額                                   */
ole11       number(20,10),           /*汇率                                   */
                                     /*匯率  (99/05/11)                       */
ole12       varchar2(10),            /*科目分类                               */
                                     /*科目分類 (99/05/11)                    */
ole13       date,                    /*凭证日期                               */
                                     /*傳票日期 (99/05/21)                    */
ole14       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號     (99/05/11)                */
ole15       varchar2(4),             /*币种                                   */
                                     /*幣別         (99/05/11)                */
ole16       varchar2(1),             /*No Use                                 */
ole17       varchar2(1),             /*No Use                                 */
ole18       varchar2(1),             /*No Use                                 */
ole19       varchar2(1),             /*No Use                                 */
ole20       varchar2(1),             /*No Use                                 */
ole21       varchar2(1),             /*No Use                                 */
ole22       varchar2(1),             /*No Use                                 */
ole23       varchar2(1),             /*No Use                                 */
ole24       varchar2(1),             /*No Use                                 */
ole25       varchar2(1),             /*No Use                                 */
ole26       varchar2(1),             /*No Use                                 */
ole27       varchar2(1),             /*No Use                                 */
ole28       varchar2(1),             /*财务审核                               */
                                     /*財務確認 (Y/N)         (99/05/11)      */
ole29       varchar2(10),            /*审核/取消审核人员                      */
                                     /*確認/取消確認人員      (99/05/11)      */
ole30       varchar2(10),            /*审核者                                 */
                                     /*確認者                                 */
oleconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
oleuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
olegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
olemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oledate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ole31       varchar2(10),            /*出货来源营运中心代码                   */
ole32       varchar2(10),            /*部门                                   */
ole930      varchar2(10),            /*成本中心                               */
oleud01     varchar2(255),           /*自订字段-Textedit                      */
oleud02     varchar2(40),            /*自订字段-文字                          */
oleud03     varchar2(40),            /*自订字段-文字                          */
oleud04     varchar2(40),            /*自订字段-文字                          */
oleud05     varchar2(40),            /*自订字段-文字                          */
oleud06     varchar2(40),            /*自订字段-文字                          */
oleud07     number(15,3),            /*自订字段-数值                          */
oleud08     number(15,3),            /*自订字段-数值                          */
oleud09     number(15,3),            /*自订字段-数值                          */
oleud10     number(10),              /*自订字段-整数                          */
oleud11     number(10),              /*自订字段-整数                          */
oleud12     number(10),              /*自订字段-整数                          */
oleud13     date,                    /*自订字段-日期                          */
oleud14     date,                    /*自订字段-日期                          */
oleud15     date,                    /*自订字段-日期                          */
olelegal    varchar2(10) NOT NULL,   /*所属法人                               */
oleoriu     varchar2(10),            /*资料建立者                             */
oleorig     varchar2(10)             /*资料建立部门                           */
);

create        index ole_02 on ole_file (ole14);
alter table ole_file add  constraint ole_pk primary key  (ole01,ole02) enable validate;
grant select on ole_file to tiptopgp;
grant update on ole_file to tiptopgp;
grant delete on ole_file to tiptopgp;
grant insert on ole_file to tiptopgp;
grant index on ole_file to public;
grant select on ole_file to ods;
