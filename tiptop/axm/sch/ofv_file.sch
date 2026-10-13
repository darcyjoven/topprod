/*
================================================================================
檔案代號:ofv_file
檔案名稱:佣金料件明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ofv_file
(
ofv01       varchar2(10) NOT NULL,   /*佣金编号                               */
                                     /*佣金代號                               */
ofv02       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
ofv03       varchar2(1),             /*计算基准                               */
                                     /*計算基准                               */
                                     /*1.銷售數量                             */
                                     /*2.銷售金額                             */
                                     /*3.標准售價                             */
                                     /*4.利潤                                 */
ofv04       number(12,3),            /*比率                                   */
ofv05       number(15,3),            /*基准一                                 */
                                     /*基準一                                 */
ofv06       number(12,3),            /*比率一                                 */
ofv07       number(15,3),            /*基准二                                 */
                                     /*基準二                                 */
ofv08       number(12,3),            /*比率二                                 */
ofv09       number(15,3),            /*基准三                                 */
                                     /*基準三                                 */
ofv10       number(12,3),            /*比率三                                 */
ofv11       number(15,3),            /*基准四                                 */
                                     /*基準四                                 */
ofv12       number(12,3),            /*比率四                                 */
ofv13       number(15,3),            /*基准五                                 */
                                     /*基準五                                 */
ofv14       number(12,3),            /*比率五                                 */
ofvuser     varchar2(10),            /*资料所有者                             */
ofvgrup     varchar2(10),            /*资料所有群                             */
ofvmodu     varchar2(10),            /*资料更改者                             */
ofvdate     date,                    /*最近更改日                             */
ofvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ofvoriu     varchar2(10),            /*资料建立者                             */
ofvorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofv_file add  constraint ofv_pk primary key  (ofv01,ofv02) enable validate;
grant select on ofv_file to tiptopgp;
grant update on ofv_file to tiptopgp;
grant delete on ofv_file to tiptopgp;
grant insert on ofv_file to tiptopgp;
grant index on ofv_file to public;
grant select on ofv_file to ods;
