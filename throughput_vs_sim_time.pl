#!/usr/bin/perl
use strict;
use warnings;

# Lấy các tham số đầu vào từ dòng lệnh
my $infile = $ARGV[0];
my $flow_id = $ARGV[1];
my $tonode = $ARGV[2];

# Khởi tạo các biến
my $sum = 0;
my $start_time = -1;
my $end_time = 0;

# Mở tệp dữ liệu đầu vào
open(my $data_fh, '<', $infile) or die "Can't open $infile: $!";

# Đọc từng dòng của tệp dữ liệu
while (<$data_fh>) {
    my @x = split(' ');

    # Kiểm tra nếu sự kiện tương ứng với việc nhận gói tin
    if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
        if ($start_time == -1) {
            $start_time = $x[1];
        } else {
            $sum += $x[5];
            if ($x[1] != $start_time) {
                my $throughput = $sum / ($x[1] - $start_time);
                $throughput = $throughput * 8 / 1024;  # Đổi sang Kbps
                print STDOUT "$x[1] $throughput\n";
            }
        }
    }
}

# Đóng tệp dữ liệu
close($data_fh);
exit(0);

