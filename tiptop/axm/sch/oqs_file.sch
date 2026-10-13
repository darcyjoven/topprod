/*
================================================================================
檔案代號:oqs_file
檔案名稱:其他相关资料档(报价单用)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqs_file
(
oqs01       varchar2(10) NOT NULL,   /*登录用户                               */
                                     /*登錄使用者                             */
oqs13       varchar2(80),            /*抬头                                   */
                                     /*抬頭                                   */
oqs141      varchar2(255),           /*文件内容1                              */
                                     /*文件內容1                              */
oqs142      varchar2(255),           /*文件内容2                              */
                                     /*文件內容2                              */
oqs143      varchar2(255),           /*文件内容3                              */
                                     /*文件內容3                              */
oqs151      varchar2(255),           /*收款-1                                 */
oqs152      varchar2(255),           /*收款-2                                 */
oqs161      varchar2(255),           /*出货-1                                 */
                                     /*出貨-1                                 */
oqs162      varchar2(255),           /*出货-2                                 */
                                     /*出貨-2                                 */
oqs171      varchar2(255),           /*包装-1                                 */
                                     /*包裝-1                                 */
oqs172      varchar2(255),           /*包装-2                                 */
                                     /*包裝-2                                 */
oqs173      varchar2(255),           /*包装-3                                 */
                                     /*包裝-3                                 */
oqs181      varchar2(255),           /*保险-1                                 */
                                     /*保險-1                                 */
oqs182      varchar2(255),           /*保险-2                                 */
                                     /*保險-2                                 */
oqs191      varchar2(255),           /*有效码-1                               */
                                     /*有效碼-1                               */
oqs192      varchar2(255),           /*有效码-2                               */
                                     /*有效碼-2                               */
oqs20       varchar2(40),            /*签名人                                 */
                                     /*簽名人                                 */
oqsacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oqsuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oqsgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oqsmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oqsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oqsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqslegal    varchar2(10) NOT NULL,   /*所属法人                               */
oqsoriu     varchar2(10),            /*资料建立者                             */
oqsorig     varchar2(10)             /*资料建立部门                           */
);

alter table oqs_file add  constraint oqs_pk primary key  (oqs01) enable validate;
grant select on oqs_file to tiptopgp;
grant update on oqs_file to tiptopgp;
grant delete on oqs_file to tiptopgp;
grant insert on oqs_file to tiptopgp;
grant index on oqs_file to public;
grant select on oqs_file to ods;
