/*
================================================================================
檔案代號:ofu_file
檔案名稱:佣金客户明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ofu_file
(
ofu01       varchar2(10) NOT NULL,   /*佣金编号                               */
                                     /*佣金代號                               */
ofu02       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
ofu03       varchar2(1),             /*计算基准                               */
                                     /*計算基准                               */
                                     /*1.銷售數量                             */
                                     /*2.銷售金額                             */
                                     /*3.標准售價                             */
                                     /*4.利潤                                 */
ofu04       number(12,3),            /*比率                                   */
ofu05       number(15,3),            /*基准一                                 */
                                     /*基準一                                 */
ofu06       number(12,3),            /*比率一                                 */
ofu07       number(15,3),            /*基准二                                 */
                                     /*基準二                                 */
ofu08       number(12,3),            /*比率二                                 */
ofu09       number(15,3),            /*基准三                                 */
                                     /*基準三                                 */
ofu10       number(12,3),            /*比率三                                 */
ofu11       number(15,3),            /*基准四                                 */
                                     /*基準四                                 */
ofu12       number(12,3),            /*比率四                                 */
ofu13       number(15,3),            /*基准五                                 */
                                     /*基準五                                 */
ofu14       number(12,3),            /*比率五                                 */
ofuuser     varchar2(10),            /*资料所有者                             */
ofugrup     varchar2(10),            /*资料所有群                             */
ofumodu     varchar2(10),            /*资料更改者                             */
ofudate     date,                    /*最近更改日                             */
ofuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofulegal    varchar2(10) NOT NULL,   /*所属法人                               */
ofuoriu     varchar2(10),            /*资料建立者                             */
ofuorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofu_file add  constraint ofu_pk primary key  (ofu01,ofu02) enable validate;
grant select on ofu_file to tiptopgp;
grant update on ofu_file to tiptopgp;
grant delete on ofu_file to tiptopgp;
grant insert on ofu_file to tiptopgp;
grant index on ofu_file to public;
grant select on ofu_file to ods;
