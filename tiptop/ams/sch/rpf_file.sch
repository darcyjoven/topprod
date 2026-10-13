/*
================================================================================
檔案代號:rpf_file
檔案名稱:资源项目单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rpf_file
(
rpf01       varchar2(10) NOT NULL,   /*资源项目编号                           */
                                     /*資源項目代號                           */
                                     /*舉凡對於生產資源項目均可設定一資源項目:*/
                                     /*如人力, 廠房空間, 成本...              */
rpf02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
                                     /*資源項目的說明                         */
rpf03       varchar2(4),             /*产能单位                               */
                                     /*產能單位                               */
                                     /*1.人時 2.機時                          */
rpf04       number(15,3),            /*资源数量                               */
                                     /*資源數量                               */
rpf05       number(15,3),            /*每日最大产能                           */
                                     /*No use                                 */
rpf06       varchar2(10),            /*工作中心                               */
rpf07       varchar2(1),             /*粗略产能考虑否                         */
                                     /*粗略產能考慮否                         */
rpf08       varchar2(1),             /*No Use                                 */
rpf09       varchar2(1),             /*No Use                                 */
rpf10       varchar2(1),             /*No Use                                 */
rpfacti     varchar2(1),             /*资料有效码                             */
rpfuser     varchar2(10),            /*资料所有者                             */
rpfgrup     varchar2(10),            /*资料所有群                             */
rpfmodu     varchar2(10),            /*资料更改者                             */
rpfdate     date,                    /*最近更改日                             */
rpforiu     varchar2(10),            /*资料建立者                             */
rpforig     varchar2(10)             /*资料建立部门                           */
);

alter table rpf_file add  constraint rpf_pk primary key  (rpf01) enable validate;
grant select on rpf_file to tiptopgp;
grant update on rpf_file to tiptopgp;
grant delete on rpf_file to tiptopgp;
grant insert on rpf_file to tiptopgp;
grant index on rpf_file to public;
grant select on rpf_file to ods;
