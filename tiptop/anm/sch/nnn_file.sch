/*
================================================================================
檔案代號:nnn_file
檔案名稱:融资种类基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nnn_file
(
nnn01       varchar2(10) NOT NULL,   /*融资种类                               */
                                     /*融資種類                               */
nnn02       varchar2(40),            /*融资种类名称                           */
                                     /*融資種類名稱                           */
nnn03       varchar2(1),             /*计息方式                               */
                                     /*計息方式                               */
                                     /*'0':不計                               */
                                     /*'1':要計                               */
                                     /*'2':平均(不用了)    #No:8935取消       */
nnn04       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
nnn05       varchar2(1),             /*是否生成应付票据                       */
                                     /*是否產生應付票據   99/09/10 add        */
nnn06       varchar2(1),             /*类型                                   */
                                     /*類別  00/05/19 add                     */
nnn07       varchar2(1),             /*是否生成银行异动                       */
                                     /*是否產生銀行異動(nme_file) No:8935 add */
nnnacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nnnuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnngrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nnnmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nnndate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nnn041      varchar2(24),            /*会计科目二                             */
nnnorig     varchar2(10),            /*资料建立部门                           */
nnnoriu     varchar2(10)             /*资料建立者                             */
);

alter table nnn_file add  constraint nnn_pk primary key  (nnn01) enable validate;
grant select on nnn_file to tiptopgp;
grant update on nnn_file to tiptopgp;
grant delete on nnn_file to tiptopgp;
grant insert on nnn_file to tiptopgp;
grant index on nnn_file to public;
grant select on nnn_file to ods;
