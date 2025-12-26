resource "null_resource" "cassandra_scaling" {
  depends_on = [kubernetes_stateful_set_v1.cassandra]

  provisioner "local-exec" {
    command = <<-EOT
        bash -c ' 
            set -e  # Exit on error
            
            echo "=== Begin gradual Cassandra scaling ==="
            kubectl scale statefulset cassandra --replicas=1
            max=${var.cassandra_replicas}
            for i in $(seq 2 $max); do
                echo "Wait 90 seconds for settling node $((i-1))..."
                sleep 90
                echo "Scaling to $i replicas..."
                kubectl scale statefulset cassandra --replicas=$i
            done
            
            echo "=== Scaling completed: $max/$max replicas ==="
            kubectl get statefulset cassandra -o jsonpath='{.status.readyReplicas}'
        '
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl scale statefulset cassandra --replicas=1 || true"
  }
}
