/*
================================================================================
檔案代號:ofr_file
檔案名稱:竞争厂商资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ofr_file
(
ofr01       varchar2(10) NOT NULL,   /*竞争厂商编号                           */
                                     /*競爭廠商編號                           */
ofr02       varchar2(40),            /*竞争厂商简称                           */
                                     /*競爭廠商簡稱                           */
ofr03       varchar2(80),            /*公司全名-1                             */
ofr031      varchar2(80),            /*公司全名-2                             */
ofr04       varchar2(255),           /*地址一                                 */
ofr05       varchar2(255),           /*地址二                                 */
ofr06       varchar2(255),           /*地址三                                 */
ofr07       varchar2(255),           /*地址四                                 */
ofr08       varchar2(40),            /*公司负责人                             */
                                     /*公司負責人                             */
ofr09       number(5),               /*员工人数                               */
                                     /*員工人數                               */
ofr10       date,                    /*创业日                                 */
                                     /*創業日                                 */
ofr11       number(20,6),            /*资本额                                 */
                                     /*資本額                                 */
ofr12       number(20,6),            /*年营业额                               */
                                     /*年營業額                               */
ofr13       varchar2(40),            /*电话                                   */
                                     /*電話                                   */
ofr14       varchar2(40),            /*传真                                   */
                                     /*傳真                                   */
ofr15       varchar2(255),           /*产品描述-1                             */
                                     /*產品描述-1                             */
ofr151      varchar2(255),           /*产品描述-2                             */
                                     /*產品描述-2                             */
ofr152      varchar2(255),           /*产品描述-3                             */
                                     /*產品描述-3                             */
ofr16       varchar2(255),           /*备注-1                                 */
                                     /*備注-1                                 */
ofr161      varchar2(255),           /*备注-2                                 */
                                     /*備注-2                                 */
ofr162      varchar2(255),           /*备注-3                                 */
                                     /*備注-3                                 */
ofr163      varchar2(255),           /*备注-4                                 */
                                     /*備注-4                                 */
ofr164      varchar2(255),           /*备注-5                                 */
                                     /*備注-5                                 */
ofracti     varchar2(1),             /*资料有效码                             */
ofruser     varchar2(10),            /*资料所有者                             */
ofrgrup     varchar2(10),            /*资料所有群                             */
ofrmodu     varchar2(10),            /*资料更改者                             */
ofrdate     date,                    /*最近更改日                             */
ofroriu     varchar2(10),            /*资料建立者                             */
ofrorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofr_file add  constraint ofr_pk primary key  (ofr01) enable validate;
grant select on ofr_file to tiptopgp;
grant update on ofr_file to tiptopgp;
grant delete on ofr_file to tiptopgp;
grant insert on ofr_file to tiptopgp;
grant index on ofr_file to public;
grant select on ofr_file to ods;
