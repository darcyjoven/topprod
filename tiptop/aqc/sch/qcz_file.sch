/*
================================================================================
檔案代號:qcz_file
檔案名稱:品管系统参数档(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table qcz_file
(
qcz00       varchar2(1) NOT NULL,    /*KEY VALUE                              */
                                     /*KEY, VALUE(0), 隱藏欄位                */
qcz01       varchar2(1),             /*质量记录是否录入明细测量值             */
qcz02       number(10),              /*CR 不良数基准分子                      */
                                     /*CR 不良數基準分子                      */
qcz021      number(10),              /*CR 不良数基准分母                      */
                                     /*CR 不良數基準分母                      */
qcz03       number(10),              /*MA 不良数基准分子                      */
                                     /*MA 不良數基準分子                      */
qcz031      number(10),              /*MA 不良数基准分母                      */
                                     /*MA 不良數基準分母                      */
qcz04       number(10),              /*MI 不良数基准分子                      */
                                     /*MI 不良數基準分子                      */
qcz041      number(10),              /*MI 不良数基准分母                      */
                                     /*MI 不良數基準分母                      */
qcz05       varchar2(1),             /*IQC 检验不良是否放入待交换仓           */
                                     /*IQC 檢驗不良是否放入待交換倉           */
qcz051      varchar2(10),            /*待交换仓库编号                         */
                                     /*待交換倉庫編號                         */
qcz052      varchar2(10),            /*待交换库位                             */
                                     /*待交換儲位                             */
qcz06       number(5),               /*连续几批中有几批退货则由正             */
                                     /*連續qcz06批中有qcz061批退貨,則由正常轉加*/
qcz061      number(5),               /*连续几批中有几批退货则由正             */
                                     /*同上                                   */
qcz07       number(5),               /*连续几批合格则由加严转正常             */
                                     /*連續qcz07批合格, 則由加嚴轉正常        */
qcz08       number(5),               /*连续几批合格则由正常转减量             */
                                     /*連續qcz08批合格, 則由正常轉減量        */
qcz09       number(5),               /*连续几批退货则由减量转正常             */
                                     /*連續qcz09批退貨, 則由減量轉正常        */
qcz10       number(5),               /*连续几批减量则由减量转免验             */
                                     /*連續qcz10批減量, 則由減量轉免驗        */
qcz11       number(5),               /*连续几批加严则由加严转除名             */
                                     /*連續qcz11批加嚴, 則由加嚴轉除名        */
qcz12       varchar2(1),             /*是否启动检验程度转换规则               */
                                     /*是否啟動檢驗程度轉換規則(Y/N)          */
qcz13       varchar2(1),             /*QC是否控制承认文号                     */
                                     /*QC是否管制承認文號(AVL)(Y/N)           */
qczud01     varchar2(255),           /*自订字段                               */
qczud02     varchar2(40),            /*自订字段                               */
qczud03     varchar2(40),            /*自订字段                               */
qczud04     varchar2(40),            /*自订字段                               */
qczud05     varchar2(40),            /*自订字段                               */
qczud06     varchar2(255),           /*自订字段                               */
qczud07     number(15,3),            /*自订字段                               */
qczud08     number(15,3),            /*自订字段                               */
qczud09     number(15,3),            /*自订字段                               */
qczud10     number(10),              /*自订字段                               */
qczud11     number(10),              /*自订字段                               */
qczud12     number(10),              /*自订字段                               */
qczud13     date,                    /*自订字段                               */
qczud14     date,                    /*自订字段                               */
qczud15     date,                    /*自订字段                               */
qcz14       varchar2(1) DEFAULT 'N' NOT NULL
);

alter table qcz_file add  constraint qcz_pk primary key  (qcz00) enable validate;
grant select on qcz_file to tiptopgp;
grant update on qcz_file to tiptopgp;
grant delete on qcz_file to tiptopgp;
grant insert on qcz_file to tiptopgp;
grant index on qcz_file to public;
grant select on qcz_file to ods;
