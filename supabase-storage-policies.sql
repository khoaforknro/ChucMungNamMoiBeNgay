-- Supabase Dashboard > SQL Editor. Thay BUCKET ID nếu đặt tên khác.
-- 1) Tạo bucket tên voice-messages ở Storage, chọn PRIVATE, giới hạn file 5 MB,
--    allowed MIME types: audio/webm, audio/mp4, audio/ogg, audio/wav (có thể thêm audio/mpeg).
-- 2) Tạo tài khoản admin trong Authentication > Users (không bật public sign-up).
-- 3) Các policy dưới đây: khách chưa đăng nhập chỉ được upload; chỉ tài khoản đăng nhập
--    mới được list/read/delete. Không cấp SELECT cho anon.

create policy "Anonymous can upload voice messages"
on storage.objects for insert to anon
with check (
  bucket_id = 'voice-messages'
  and lower(storage.extension(name)) in ('webm','m4a','ogg','wav','mp3')
);

create policy "Authenticated admin can list voice messages"
on storage.objects for select to authenticated
using (bucket_id = 'voice-messages');

create policy "Authenticated admin can delete voice messages"
on storage.objects for delete to authenticated
using (bucket_id = 'voice-messages');

-- LƯU Ý: policies trên cho phép mọi khách ẩn danh upload vào bucket; giới hạn 5 MB
-- và MIME types cần đặt trong phần bucket settings. Để chống spam mạnh hơn cần CAPTCHA
-- hoặc endpoint/server-side rate limit. Nếu có nhiều người dùng đăng nhập ngoài admin,
-- hãy khóa SELECT/DELETE theo auth.uid() của admin thay vì role authenticated chung.
